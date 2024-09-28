//
//  AboutVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI

struct AboutVC: View {
    // Uygulama sürümünü dinamik olarak almak için bir değişken
    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "Sürüm \(version)"
        }
        return "Sürüm Bilgisi Yok"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Uygulama Logosu
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                    .frame(maxWidth: .infinity)

                // Başlık
                Text("Rüya Günlüğüm Uygulaması")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .padding(.horizontal)

                // Kısa Açıklama
                Text("Rüya Günlüğüm, rüyalarınızı kaydedip anlamlarını keşfetmenize yardımcı olan bir uygulamadır. Her gün rüyalarınızı kaydedin, sembolleri araştırın ve rüyalarınızın ardındaki gizemli anlamları keşfedin.")
                    .font(.body)
                    .padding(.horizontal)

                // Özellikler
                Text("Özellikler")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("Rüyalarınızı kaydedin ve organize edin.")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("Sembolleri araştırın ve anlamlarını keşfedin.")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("Favori rüyalarınızı işaretleyin.")
                    }
                }
                .padding(.horizontal)

                // Geliştirici Bilgisi
                Text("Geliştirici")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                Text("Bahadır Şengün")
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .onTapGesture {
                        openInstagramProfile()
                    }

                Spacer()

                // Sürüm Bilgisi
                Text(appVersion)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 50)
        }
    }
    
    
    func openInstagramProfile() {
        let username = "devsengun"
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let webURL = URL(string: "https://www.instagram.com/\(username)/")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(webURL)
        }
    }
    
}

#Preview {
    AboutVC()
}
