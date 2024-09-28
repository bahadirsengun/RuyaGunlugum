//
//  AuthVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AuthVC: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignedIn: Bool = false
    @State private var showChangePasswordVC: Bool = false // Yeni State değişkeni
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                Text("Hoşgeldin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Giriş Yap ve Rüyalarını Keşfet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("E-posta")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("E-postanı girin", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 30)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Şifre")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if showPassword {
                            TextField("Şifreni girin", text: $password)
                        } else {
                            SecureField("Şifreni girin", text: $password)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    signInWithEmail()
                }) {
                    Text("Giriş yap")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                if showError {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Button(action: {
                    showChangePasswordVC = true // Bu satırı ekledik
                }) {
                    Text("Şifreni mı unuttun?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                .background(
                    NavigationLink(destination: ChangePasswordVC(), isActive: $showChangePasswordVC) {
                        EmptyView()
                    }
                )
                
                Spacer()
                
                NavigationLink(destination: SignUpVC().navigationBarBackButtonHidden(true)) {
                    HStack {
                        Text("Hesabın yok mu?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("Üye ol")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            
            // NavigationLink for HomeVC
            NavigationLink(destination: HomeVC().navigationBarBackButtonHidden(true), isActive: $isSignedIn) {
                EmptyView()
            }
            .onAppear {
                // Check if user is already signed in
                checkUserStatus()
            }
        }
    }

    func signInWithEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .userNotFound:
                        errorMessage = "Bu e-postayla ilgili bir hesap bulunamadı."
                    case .wrongPassword:
                        errorMessage = "Yanlış şifre. Lütfen tekrar deneyin."
                    case .invalidEmail:
                        errorMessage = "Geçersiz e-posta adresi biçimi."
                    default:
                        errorMessage = "Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin."
                    }
                }
                showError = true
            } else {
                // Check if email is verified
                if result?.user.isEmailVerified == true {
                    DispatchQueue.main.async {
                        isSignedIn = true
                    }
                } else {
                    errorMessage = "E-posta adresiniz doğrulanmamış. Lütfen doğrulama e-postasını kontrol edin."
                    showError = true
                }
            }
        }
    }

    func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                isSignedIn = true
            } else {
                errorMessage = "E-posta adresiniz doğrulanmamış. Lütfen doğrulama e-postasını kontrol edin."
                showError = true
                try? Auth.auth().signOut() // Kullanıcıyı çıkış yaptırıyoruz
            }
        }
    }
}

#Preview {
    AuthVC()
}

