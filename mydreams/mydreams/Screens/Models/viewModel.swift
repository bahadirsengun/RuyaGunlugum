//
//  ViewModel.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class DreamViewModel: ObservableObject {
    @Published var dreams: [Dream] = []
    @Published var favoriteDreams: [Dream] = []
    @Published var selectedDream: Dream? // Add this property

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        fetchDreams()
        fetchFavoriteDreams()
    }

    func fetchDreams() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("users").document(userId).collection("dreams")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching dreams: \(error)")
                    return
                }
                
                self?.dreams = snapshot?.documents.compactMap { document in
                    try? document.data(as: Dream.self)
                } ?? []
            }
    }
    
    func fetchFavoriteDreams() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("favoriteDreams")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching favorite dreams: \(error)")
                    return
                }
                
                self?.favoriteDreams = snapshot?.documents.compactMap { document in
                    try? document.data(as: Dream.self)
                } ?? []
            }
    }
    
    func addDream(_ dream: Dream) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Ensure unique ID or use the existing ID if provided
        let dreamId = dream.id ?? UUID().uuidString
        
        do {
            _ = try db.collection("users").document(userId).collection("dreams").document(dreamId).setData(from: dream)
        } catch {
            print("Error adding dream: \(error)")
        }
    }

    func updateDream(_ dream: Dream) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let dreamId = dream.id else { return }
        
        db.collection("users").document(userId).collection("dreams").document(dreamId).updateData([
            "title": dream.title,
            "details": dream.details,
            "emotion": dream.emotion,
            "date": dream.date
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                // Optionally refresh the list of dreams
                self.fetchDreams()
            }
        }
    }

    func deleteDream(_ dream: Dream) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let dreamId = dream.id else { return }
        
        db.collection("users").document(userId).collection("dreams").document(dreamId).delete { [weak self] error in
            if let error = error {
                print("Error deleting dream: \(error)")
            } else {
                // Remove from favorites if it exists there
                self?.removeFromFavorites(dream)
            }
        }
    }

    func addToFavorites(_ dream: Dream) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            _ = try db.collection("users").document(userId).collection("favoriteDreams").document(dream.id ?? UUID().uuidString).setData(from: dream)
        } catch {
            print("Error adding dream to favorites: \(error)")
        }
    }
    
    func removeFromFavorites(_ dream: Dream) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let dreamId = dream.id else { return }
        
        db.collection("users").document(userId).collection("favoriteDreams").document(dreamId).delete { error in
            if let error = error {
                print("Error removing dream from favorites: \(error)")
            }
        }
    }
}


