//
//  ProfileVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileVC: View {
    @State private var showingEditProfile = false
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var profileImage: Image = Image(systemName: "person.circle.fill")
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 30)
            } else {
                // Profil Fotoğrafı
                VStack {
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        .padding(.top, 30)

                    Text("Merhaba \(userName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)

                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Profil Bilgileri
                List {
                    HStack {
                        Text("Profili Düzenle")
                        Spacer()
                        Button(action: {
                            showingEditProfile.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Ayarlar")
                        Spacer()
                        NavigationLink(destination: SettingsVC()) {
                            Image(systemName: "gear")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Hakkında")
                        Spacer()
                        NavigationLink(destination: AboutVC()) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }

                    HStack {
                        Text("Şikayet ve Öneri")
                        Spacer()
                        Link(destination: URL(string: "mailto:sengun.software@gmail.com")!) {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
            }
        }
        .navigationTitle("Profil")
        .sheet(isPresented: $showingEditProfile) {
            EditProfileVC(userName: $userName, email: $email)
                .onDisappear {
                    // Profil güncellemelerini kontrol et
                    loadUserProfile()
                }
        }
        .onAppear(perform: loadUserProfile)
    }

    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else {
            self.isLoading = false
            return
        }
        
        // Firebase'den kullanıcı bilgilerini al
        self.email = user.email ?? ""
        self.userName = user.displayName ?? "User"
        
        // Profil fotoğrafını güncelle
        if let photoURL = user.photoURL {
            loadImage(from: photoURL)
        } else {
            // Varsayılan profil fotoğrafı
            self.profileImage = Image(systemName: "person.circle.fill")
        }
        
        self.isLoading = false
    }

    private func loadImage(from url: URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: url.absoluteString)

        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                self.profileImage = Image(systemName: "person.circle.fill")
            } else if let data = data, let uiImage = UIImage(data: data) {
                self.profileImage = Image(uiImage: uiImage)
            }
        }
    }
}

// Preview
struct ProfileVC_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileVC() // Ensure ProfileVC is inside a NavigationView for previews
        }
    }
}
