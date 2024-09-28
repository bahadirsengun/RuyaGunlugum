//
//  Models.swift
//  mydreams
//
//  Created by Bahadır Sengun on 29.08.2024.
//

import Foundation
import FirebaseFirestore

struct Dream: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var details: String
    var emotion: String
    var date: Date
}


struct DreamSymbols: Identifiable {
    var symbolName: String // Sembolün adı
    var symbolMean: String // Sembolün anlamı
    var id: Int { symbolID } // Identifiable protokolü için id özelliği
    var symbolID: Int // Her öğe için benzersiz bir kimlik
    
    
    // Yapıcı fonksiyon
    init(symbolName: String, symbolMean: String, symbolID: Int) {
       
        self.symbolName = symbolName
        self.symbolMean = symbolMean
        self.symbolID = symbolID
    }
}
