//
//  TermsAndConditionsVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI

struct TermsAndConditionsVC: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Başlık
                Text("Kullanım Koşulları ve Gizlilik Politikası")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .padding(.horizontal)

                // Giriş Metni
                Text("Rüya Günlüğüm uygulamasını kullanmadan önce lütfen aşağıdaki kullanım koşullarını ve gizlilik politikasını dikkatlice okuyunuz. Uygulamayı kullanarak bu şartları kabul etmiş sayılırsınız.")
                    .font(.body)
                    .padding(.horizontal)

                // Kullanım Koşulları Başlığı
                Text("Kullanım Koşulları")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Kullanım Koşulları Metni
                Text("""
                1. MyDreams uygulaması, rüyalarınızı kaydedip anlamlarını keşfetmenize yardımcı olmak amacıyla geliştirilmiştir.
                2. Uygulamanın içeriğini değiştirme, kopyalama veya çoğaltma hakkı geliştiriciye aittir.
                3. Uygulama içerisinde yer alan bilgilerin doğruluğu garanti edilmemektedir. Kullanıcı, bu bilgileri kendi sorumluluğu altında kullanır.
                4. Uygulamanın kullanımında herhangi bir problem yaşanması durumunda geliştirici ile iletişime geçilmelidir.
                5. Kullanıcı, uygulamayı yalnızca kişisel amaçlarla kullanabilir ve ticari amaçla kullanması yasaktır.
                """)
                .font(.body)
                .padding(.horizontal)

                // Gizlilik Politikası Başlığı
                Text("Gizlilik Politikası")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Gizlilik Politikası Metni
                Text("""
                1. MyDreams uygulaması, kullanıcıların kişisel verilerini toplamaz ve saklamaz.
                2. Kullanıcı rüyaları yalnızca cihazda saklanır ve üçüncü şahıslarla paylaşılmaz.
                3. Uygulama, kullanıcıların gizliliğini en üst düzeyde korumayı taahhüt eder.
                4. Kullanıcılar, gizlilik politikası ile ilgili soruları için geliştiriciyle iletişime geçebilir.
                5. Gizlilik politikası ve kullanım koşulları, herhangi bir bildirimde bulunmadan değiştirilebilir. Kullanıcılar, uygulamayı kullanmaya devam ederek bu değişiklikleri kabul etmiş sayılırlar.
                """)
                .font(.body)
                .padding(.horizontal)

                // Kabul Butonu
                Button(action: {
                    // Kullanıcı kabul ettiğinde yapılacak işlemler
                }) {
                    Text("Kabul Ediyorum")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    TermsAndConditionsVC()
}
