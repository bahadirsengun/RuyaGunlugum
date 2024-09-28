//
//  SplashVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 30.08.2024.
//

import SwiftUI

struct SplashVC: View {
    @State private var isActive: Bool = false
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0

    var body: some View {
        VStack {
            if isActive {
                // Ana ekrana geçiş
                HomeVC()
            } else {
                // Splash ekranı
                Image("logo") // 'logo' adında bir fotoğraf kullanılacak
                    .resizable()
                    .scaledToFit() // Ekrana sığacak şekilde ölçeklendirme
                    .clipShape(RoundedRectangle(cornerRadius: 25)) // Köşeleri yuvarlatma
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // Animasyonu başlatıyoruz
                        withAnimation(.easeIn(duration: 2)) {
                            self.scale = 1.0
                            self.opacity = 1.0
                        }
                    }
            }
        }
        .onAppear {
            // 2 saniye bekledikten sonra isActive değişkenini true yaparak ana ekrana geçiş yapıyoruz
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashVC()
}

