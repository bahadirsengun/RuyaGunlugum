//
//  SettingsVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SettingsVC: View {
    @State private var darkModeEnabled: Bool = false
    @State private var languageSelection: String = "Türkçe"
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    // Store user settings
    @AppStorage("darkModeEnabled") private var storedDarkModeEnabled: Bool = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Hesap")) {
                    Button(action: {
                        // Go back to previous screen
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text("Profil")
                            Spacer()
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {
                        logOut()
                    }) {
                        HStack {
                            Text("Çıkış Yap")
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(.red)
                        }
                    }

                    // Hesabı Sil Butonu
                    Button(action: {
                        deleteAccount()
                    }) {
                        HStack {
                            Text("Hesabı Sil")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Tercihler")) {
                    Button(action: {
                        // Redirect to device settings for notification permissions
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Text("Bildirim İzni")
                            Spacer()
                            Image(systemName: "bell")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Text("Karanlık Mod")
                    }
                    .onChange(of: darkModeEnabled) { newValue in
                        // Update the stored setting
                        storedDarkModeEnabled = newValue
                        // Apply the theme change
                        updateDarkMode(newValue)
                    }
                }
                
                Section(header: Text("Hakkımızda")) {
                    NavigationLink(destination: AboutVC()) {
                        HStack {
                            Text("Uygulama Hakkında")
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Bilgi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
        .onAppear {
            // Synchronize the dark mode toggle with stored value
            darkModeEnabled = storedDarkModeEnabled
            // Apply the stored theme setting on appearance
            updateDarkMode(storedDarkModeEnabled)
        }
    }
    
    func updateDarkMode(_ isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            // Navigate back to AuthVC
            if let window = UIApplication.shared.windows.first {
                let contentView = AuthVC()
                window.rootViewController = UIHostingController(rootView: contentView)
                window.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError.localizedDescription)
            alertMessage = "Çıkış yaparken bir hata oluştu. Lütfen tekrar deneyin."
            showingAlert = true
        }
    }
    
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "Hesabınızı silerken bir sorun oluştu. Lütfen tekrar deneyin."
            showingAlert = true
            return
        }

        // Yeniden kimlik doğrulama işlemi
        reauthenticateUser { success in
            if success {
                user.delete { error in
                    if let error = error {
                        print("Error deleting account: \(error.localizedDescription)")
                        alertMessage = "Hesabınızı silerken bir sorun oluştu. Lütfen tekrar deneyin."
                        showingAlert = true
                    } else {
                        // Kullanıcı hesabı silindi, uygulamadan çıkış yap
                        if let window = UIApplication.shared.windows.first {
                            let contentView = AuthVC()
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }
                }
            } else {
                alertMessage = "Yeniden kimlik doğrulama başarısız oldu. Lütfen tekrar deneyin."
                showingAlert = true
            }
        }
    }

    private func reauthenticateUser(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false)
            return
        }

        let alertController = UIAlertController(title: "Kimlik Doğrulama", message: "Lütfen şifrenizi girin:", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Şifre"
            textField.isSecureTextEntry = true
        }

        let confirmAction = UIAlertAction(title: "Onayla", style: .default) { _ in
            let password = alertController.textFields?.first?.text ?? ""

            let credential = EmailAuthProvider.credential(withEmail: email, password: password)

            user.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    print("Reauthentication failed: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
            completion(false)
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

}

// Preview
struct SettingsVC_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsVC()
        }
    }
}
 
