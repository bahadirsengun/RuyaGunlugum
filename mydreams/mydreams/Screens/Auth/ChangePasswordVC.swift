//
//  ChangePasswordVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 30.08.2024.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordVC: View {
    @State private var email: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Şifremi Unuttum")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("E-posta adresinizi girerek şifrenizi sıfırlamak için bir bağlantı alabilirsiniz.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            TextField("E-posta Adresi", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: sendPasswordResetEmail) {
                Text("Şifre Sıfırlama E-postası Gönder")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }

    private func sendPasswordResetEmail() {
        guard !email.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin."
            return
        }
        
        // Şifre sıfırlama e-postası gönder
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = "E-posta gönderme hatası: \(error.localizedDescription)"
                successMessage = nil
            } else {
                successMessage = "Şifre sıfırlama e-postası başarıyla gönderildi. E-postanızı kontrol edin."
                errorMessage = nil
            }
        }
    }
}

#Preview {
    ChangePasswordVC()
}
