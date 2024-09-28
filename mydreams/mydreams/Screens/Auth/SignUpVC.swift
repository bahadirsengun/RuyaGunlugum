//
//  SignUpVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpVC: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showError: Bool = false // Show error message
    @State private var errorMessage: String = "" // Message to show in case of error
    @State private var showSuccess: Bool = false // Show success message
    @State private var successMessage: String = "" // Message to show in case of success
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // App Logo or Illustration
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 20)
            
            // Sign Up Text
            Text("Bir hesap oluşturun")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Yeni bir hesap oluşturmak için lütfen aşağıdaki bilgileri doldurun.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            // Email TextField
            VStack(alignment: .leading, spacing: 5) {
                Text("E-posta")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("E-postanızı girin", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(.horizontal, 30)
            
            // Password TextField
            VStack(alignment: .leading, spacing: 5) {
                Text("Şifre")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    if showPassword {
                        TextField("Şifrenizi girin", text: $password)
                    } else {
                        SecureField("Şifrenizi girin", text: $password)
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
            
            // Sign Up Button
            Button(action: {
                createUserWithEmail()
            }) {
                Text("Üye ol")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            // Error or Success Message
            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            if showSuccess {
                Text(successMessage)
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }
            
            Spacer()
            
            // Already have an account Link
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text("Zaten bir hesabınız var mı?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("Giriş yap")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .bold()
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.top, 50)
    }
    
    func createUserWithEmail() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                // Handle error
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        errorMessage = "Bu e-posta adresi ile zaten bir hesap mevcut."
                    case .invalidEmail:
                        errorMessage = "Geçersiz e-posta adresi."
                    case .weakPassword:
                        errorMessage = "Şifreniz çok zayıf. Daha güçlü bir şifre seçin."
                    default:
                        errorMessage = "Kullanıcı oluşturulurken bilinmeyen bir hata oluştu. Lütfen tekrar deneyin."
                    }
                }
                showError = true
                showSuccess = false
            } else {
                // User created successfully
                successMessage = "Kullanıcı başarıyla oluşturuldu. Doğrulama e-postası gönderiliyor..."
                showSuccess = true
                showError = false
                
                // Send email verification
                result?.user.sendEmailVerification { error in
                    if let error = error {
                        errorMessage = "Doğrulama e-postası gönderilirken bir hata oluştu: \(error.localizedDescription)"
                        showError = true
                        showSuccess = false
                    } else {
                        successMessage = "Doğrulama e-postası başarıyla gönderildi. Lütfen gelen kutunuzu kontrol edin."
                        showSuccess = true
                        showError = false
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpVC()
}

