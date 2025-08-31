//
//  SavedImage.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI
import PhotosUI
import SwiftData


// SWIFT DATABASE SET UP
@Model
class SavedImage {
    var id: UUID
    @Attribute(.unique) var imageData: Data  // Filter out duplicates
    
    
    init(imageData: Data) {
        self.id = UUID()
        self.imageData = imageData
    }
}
