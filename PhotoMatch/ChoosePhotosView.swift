//
//  ChoosePhotosView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//



import SwiftUI
import PhotosUI
import SwiftData

struct ChoosePhotosView: View {
    
    @Environment(\.modelContext) private var context
    
    @Environment(Model.self) var model
    
    // @Query private var savedImages: [SavedImage]
    
    @State private var savedImages: [SavedImage] = []  // images as original image data
    
    @State private var selectedItem: PhotosPickerItem? // selected photo via PhotoPicker
    
    @Binding var isPresented: Bool // trigger for bring up PhotoPicker
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                List {
                    ForEach(savedImages, id: \.id) { saved in
                        if let uiImage = UIImage(data: saved.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                .navigationTitle("") // Hide default title
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Text("Selected Photos")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                }
                
                .toolbar {
                    
                    PhotosPicker(selection: $selectedItem,  // PhotoPicker
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Add Photo", systemImage: "photo.on.rectangle")
                    }
                }
                
            }
            .onChange(of: selectedItem) { oldItem, newItem in  // respond if photo selected
                Task {
                    if let item = newItem, // is it new - set it
                       let data = try? await item.loadTransferable(type: Data.self) { // get image data via 'loadTransferable
                        let saved = SavedImage(imageData: data) // get ready for save to database
                        context.insert(saved) // insert into in-memory context
                        try? context.save() // save context
                        if let uiImage = UIImage(data: saved.imageData) { // create image from image data
                            
                            model.myImages.append(uiImage) // add to arrays
                          //  model.imagesCopy.append(uiImage)
                            
                            model.builtphotos.removeAll() // Clear out existing builtphotos ready for refresh
                            
                            fetchItems()  // get image data from database
                            
                            model.builtphotos =  model.initbuiltphotos(savedImages: savedImages)  //  THIS DOES THE BUSINESS - init builtphotos with updated images
                        }
                    }
                    selectedItem = nil // ensure no item still selected after processing
                }
            }
            
            // DELETE  ALL IMAGES FROM IN-MEMORY CONTEXT
            Button("Delete All") {
                savedImages.forEach { context.delete($0) } //  deleted each one and then save updated context
                try? context.save()
                
                savedImages.removeAll()  // reset savedImages to empty
            }
            
        } // end of navstack
        .onAppear()
        {
            fetchItems() // fetch images data from database
            
            model.builtphotos = model.initbuiltphotos(savedImages: savedImages)    // TEMP TO FIX CRASH ? reset builtphotos to latest data
        }
        
    }
    
    // DELETE SPECIFIC IMAGE - TRIGGERED BY LIST SWIPE LEFT
    
    private func deleteItems(at offsets: IndexSet) {
        
        if savedImages.isEmpty {  // Trying to delete from empty array would crash - so check first
            
            return
        }
        
        // WORK THROUGH  IMAGES ARRAYS AND CONTEXT, DELETING SPECIFIC ITEM FROM LIST ETC
        for index in offsets {
            
            model.myImages.remove(at: index)
            
            context.delete(savedImages[index])
            
        }
        try? context.save()
        
        model.builtphotos = model.initbuiltphotos(savedImages: savedImages) //  THIS FIXES THE PROBLEM
        
    }
    
    // GET IMAGES DATA FROM DATABASE
    
    func fetchItems() {
        let descriptor = FetchDescriptor<SavedImage>()
        do {
            savedImages = try context.fetch(descriptor)
            
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    
}

