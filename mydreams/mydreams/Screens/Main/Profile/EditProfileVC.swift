//
//  EditProfileVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct EditProfileVC: View {
    @Binding var userName: String
    @Binding var email: String

    @State private var newUserName: String = ""
    
    // Add Environment variable for presentation mode
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Sabit Profil Fotoğrafı
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        .padding(.top, 30)
                    
                    Text("Profil Fotoğrafı")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                // Kullanıcı Adı
                VStack(alignment: .leading, spacing: 5) {
                    Text("Kullanıcı adı")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Kullanıcı adınızı girin", text: $newUserName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Kaydet Butonu
                Button(action: {
                    saveProfile()
                }) {
                    Text("Değişiklikleri Kaydet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .navigationTitle("Profili Düzenle")
            .onAppear {
                // Sayfa yüklendiğinde mevcut değerleri al
                newUserName = userName
            }
        }
    }

    // Profil güncellemelerini kaydet
    private func saveProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        // Profil bilgilerini güncelle
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newUserName
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profil başarıyla güncellendi")
                // Sayfayı kapat ve geri dön
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// Preview
struct EditProfileVC_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileVC(userName: .constant("miasfir"), email: .constant("test@example.com"))
    }
}

