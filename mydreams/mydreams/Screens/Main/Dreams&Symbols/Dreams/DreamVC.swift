//
//  DreamVC.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import SwiftUI

struct DreamVC: View {
    @StateObject private var viewModel = DreamViewModel()
    @State private var showingSaveDreamVC = false
    @State private var selectedDream: Dream?

    var body: some View {
        VStack {
            // Display total number of dreams
            Text("Toplam Rüya Sayınız: \(viewModel.dreams.count)")
                .font(.headline)
                .padding()
            
            List {
                ForEach(viewModel.dreams) { dream in
                    Button(action: {
                        selectedDream = dream
                    }) {
                        VStack(alignment: .leading) {
                            Text(dream.title)
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text(dream.details)
                                .font(.subheadline)
                                .lineLimit(1) // Display only one line
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            viewModel.addToFavorites(dream)
                        }) {
                            Label("Favorilere Ekle", systemImage: "star")
                        }
                        .tint(.yellow)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteDream(dream)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        Button(action: {
                            viewModel.removeFromFavorites(dream)
                        }) {
                            Label("Favorilerden Kaldır", systemImage: "star.fill")
                        }
                        .tint(.gray)
                    }
                }
            }
            .navigationTitle("Rüyalar")
            .navigationBarItems(trailing: Button(action: {
                showingSaveDreamVC = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingSaveDreamVC) {
                SaveDreamVC(viewModel: viewModel)
            }
        }
        .background(
            NavigationLink(
                destination: DetailDreamVC(dream: selectedDream, viewModel: viewModel),
                isActive: Binding(
                    get: { selectedDream != nil },
                    set: { _ in selectedDream = nil }
                ),
                label: { EmptyView() }
            )
        )
    }
}


struct DetailDreamVC: View {
    @ObservedObject var viewModel: DreamViewModel
    @State private var isEditing: Bool = false
    @State private var newTitle: String
    @State private var newDetails: String
    @State private var newEmotion: String
    @State private var newDate: Date
    
    init(dream: Dream?, viewModel: DreamViewModel) {
        self._newTitle = State(initialValue: dream?.title ?? "")
        self._newDetails = State(initialValue: dream?.details ?? "")
        self._newEmotion = State(initialValue: dream?.emotion ?? "")
        self._newDate = State(initialValue: dream?.date ?? Date())
        self.viewModel = viewModel
        self.dream = dream
    }
    
    let dream: Dream?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let _ = dream {
                if isEditing {
                    // Editing View
                    Form {
                        TextField("Başlık", text: $newTitle)
                        TextField("Detaylar", text: $newDetails)
                        TextField("Duygu", text: $newEmotion)
                        DatePicker("Tarih", selection: $newDate, displayedComponents: .date)
                        
                        Button("Değişiklikleri Kaydet") {
                            saveChanges()
                        }
                        .padding()
                    }
                } else {
                    // Display View
                    Text(newTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text(newDetails)
                        .font(.body)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("Duygu:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(newEmotion)
                            .font(.body)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("Tarih:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(newDate, style: .date)
                            .font(.body)
                    }
                    
                    Button("Düzenle") {
                        startEditing()
                    }
                    .padding()
                    
                    Spacer()
                }
            } else {
                Text("Seçili bir rüya yok")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationTitle("Rüya Detayı")
        .onAppear {
            if let dream = dream {
                newTitle = dream.title
                newDetails = dream.details
                newEmotion = dream.emotion
                newDate = dream.date
            }
        }
    }
    
    private func startEditing() {
        isEditing = true
    }
    
    private func saveChanges() {
        guard let updatedDream = dream else { return }
        
        var newDream = updatedDream
        newDream.title = newTitle
        newDream.details = newDetails
        newDream.emotion = newEmotion
        newDream.date = newDate
        
        viewModel.addDream(newDream)
        isEditing = false
    }
}

struct DetailDreamVC_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailDreamVC(dream: nil, viewModel: DreamViewModel())
        }
    }
}

#Preview {
    DreamVC()
}
