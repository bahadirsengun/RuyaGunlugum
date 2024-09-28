//
//  SaveDreamVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SaveDreamVC: View {
    @ObservedObject var viewModel: DreamViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var details = ""
    @State private var selectedEmotion = "Mutlu" // Default emotion
    @State private var isSaving = false // To prevent multiple saves
    
    let emotions = ["Mutlu", "Üzgün", "Korkmuş", "Öfkeli", "Sakin", "Heyecanlı", "Şaşkın", "Tiksinme", "Diğer"] // Emotion options

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rüya Başlığı")) {
                    TextField("Başlık", text: $title)
                }
                
                Section(header: Text("Rüya Detayları")) {
                    TextEditor(text: $details)
                        .frame(height: 150) // Adjust height as needed
                        .border(Color.gray, width: 1)
                }
                
                Section(header: Text("Rüyada Hangi Duyguya Hakimsiniz?")) {
                    Picker("Duygu Seçin", selection: $selectedEmotion) {
                        ForEach(emotions, id: \.self) { emotion in
                            Text(emotion).tag(emotion)
                        }
                    }
                }
                
                Button(action: {
                    // Prevent saving if already saving
                    guard !isSaving else { return }
                    isSaving = true
                    
                    let newDream = Dream(
                        title: title,
                        details: details,
                        emotion: selectedEmotion,
                        date: Date() // Current date and time
                    )
                    viewModel.addDream(newDream)
                    
                    // Ensure the UI is updated and the view is dismissed
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Rüyayı Kaydet")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Yeni Rüya")
            .navigationBarItems(trailing: Button("İptal") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
