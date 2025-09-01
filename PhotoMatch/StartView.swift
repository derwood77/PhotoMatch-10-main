//
//  StartView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.

// Version 2 ... changed builtphotos to builtphotos
// Version 3 ... changed Card to BuiltPhoto
// Version 4 ... changed showingplayerNameSheet to showingPlayerNameView
// Version 5 ... changed userName to playerName
// Version 6 ... put alert into alertResponse function and timer onReceive into onReceiveResponse
// Version 7 ... put onAppear into onAppearResponse
// Version 8 ... animate congrates smiley emoji
// Version 9 ... Changed Home to PhotoMatch in NavigationTitle and upsized game result display in StartView
// Version 10 ... Improved some button code by using 'borderProminent' modifier etc

import SwiftUI
import SwiftData

struct StartView: View {
    
    @Environment(\.modelContext) private var context
    
    @Environment(Model.self) var model
    
    @State var showingSheet = false
        
    // @Query private var savedImages: [SavedImage] - Don't need this now as done via code for more control
    
    
    // Initialising array of Doubles tricky with repeat param - so this looks clumsy but is much simpler
    // Set start values to be much higher than likely real times
    @AppStorage("savedNumbers") var   bestTimes = [1500.0, 1500.0, 1500.0,1500.0,1500.0,1500.0,1500.0,1500.0,1500.0, 1500.0]
    
    @State var playerName: String = ""
    
    @AppStorage("playerName") var storedplayerName: String = ""  //  Save current useName between sessions
    
    @State private var savedImages: [SavedImage] = []
    
    @State private var showChoosePhotosView: Bool = false  // trigger to show GetPhotos View
    
    @State var showAlert: Bool = false // trigger to show Alert
    
    @State var showingPlayerNameView: Bool = false // trigger to show playerNameSheet
    
    @AppStorage("bestTimesModdedCopy") var  bestTimesModdedCopy: [String] = []  // Don't need @Binding in another view - just do same as this
    
    @State private var textOpacity: Double = 1.0 // Setting for flash text trigger
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing:30) {
                
                if playerName == "" {  // Prompt player to set up player name (playerName)
                    HStack {
                        
                        Text("Set player name")
                        
                      Image(systemName: "arrowshape.up.circle.fill").foregroundStyle(.black)
//                        
//                        Text(" above")
//                        
                    }
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.red)
                    .opacity(textOpacity)
                    
                } else {   // Player name set - so show it
                    
                    Text("Player Name: \(playerName)")
                        .padding()
                        .font(.title2)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                if  savedImages.count == 0 // Check for saved photos
                        
                {
                    Text("No photos saved yet") // warn if no photos selected yet
                        .font(.title)
                    
                } else {  // else display photos selected as start of Game
                    
                    NavigationLink {
                        GameView(savedImages: $savedImages)  // DISPLAY IMAGES CONVERTED FROM IMAGEDATA IN SEPARATE VIEW
                    } label: {
                        Text("Game")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button("Choose Photos") {
                    showChoosePhotosView = true // trigger to Select Photos View
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .tint(.blue)
                
                VStack(spacing: 20) {
                    
                    if model.averageMatchTime != 1500 {  // Game in play so show latest stats for this player
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.yellow)
                                .frame(width: 300, height: 200)
                            
                            
                            VStack(spacing: 10) {
                                
                                HStack {
                                    
                                    Image(systemName: "person.badge.clock.fill")
                                        .font(.system(size: 40))
                                    
                                    Text("Your Score")
                                        .font(.system(size: 20))
                                }
                                
                                
                                // Compensate for single/plural
                                
                                if model.thisPhotoCount == 1 {
                                    Text("For  \(Int(model.thisPhotoCount)) photo")
                                } else {
                                    Text("For  \(Int(model.thisPhotoCount)) photos")
                                }
                                
                                Text("timeElapsed \(model.timeElapsed,specifier: "%.2f")")
                                Text("AverageTimeToMatch \(model.averageMatchTime, specifier: "%.2f")")
                            }
                            
                        }
                        
                    }
                    
                    
                }
                .background(Color.yellow.opacity(0.2))
                .opacity(model.gameOver ? 1 : 0)
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .regular, design: .default))
                .padding()
                .cornerRadius(10)
                
                
                // SHOW FASTEST TIME RECORDS
                NavigationLink {
                    RecordsView(bestTimes: bestTimes, playerName: $playerName, bestTimesModdedCopy: bestTimesModdedCopy)
                } label: {
                    Text("Fastest Ever")
                    // .font(.title)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    //.opacity(model.gameOver ? 1 : 0)  Show this button all the time now
                }
                
                
            } // End of VStack
            
            // SHOW SMILEY FACE WELL DONE GOT RECORD SHEET
            .sheet(isPresented: $showingSheet) {
                CongratsView(playerName: $playerName, bestTimesModdedCopy: bestTimesModdedCopy)
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button(){
                        
                        showAlert = true  // Brings up sheet to enable reset of Fastest Times records
                        
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill").foregroundStyle(.black)
                        
                    }
                }
               
                
                ToolbarItem (placement: .navigationBarTrailing) {
                    
                    Button(){
                        
                        showingPlayerNameView = true   // Bring up set / change playerName (player)
                        
                    } label: {
                        Image(systemName: "person.fill").foregroundStyle(.black)
                    }
                }
                
            }
            .navigationTitle("PhotoMatch")
            .navigationBarTitleDisplayMode(.inline) // Keep title compact
            .navigationDestination(isPresented: $showChoosePhotosView) {
                
                // PASS THE BINDING DOWN TO GETPHOTOS VIEW SO IT CAN DISMISS ITSELF.
                
                ChoosePhotosView(isPresented: $showChoosePhotosView)
            }
            .onChange(of: showChoosePhotosView) { oldValue, newValue in
                
                if !newValue { // If newValue is false, GetPhotos view was dismissed
                    
                    // Perform any actions needed when returning to this view.
                    
                    fetchItems()  // Fetch image data from database (more controllable then @Qery
                }
            }
        }
        
        
        // TIMER RESPONSE RUN EVERY SECOND
        .onReceive(model.timer) { _ in
            onReceiveResponse()
        }
        .sheet(isPresented: $showingPlayerNameView) {
            PlayerNameView(playerName: $playerName)  // trigger to bring up playerName sheet
        }
        .alert(isPresented:$showAlert) { // warn reset fastest time records will delete them

            alertResponse()
        }
       .onAppear() {
           
           onApearResponce()

        }
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
    
    // WARN PLAYER NAME NOT SET BY FLASHING WARNING TEXT
    func flashText() {
        Task {
            for _ in 0..<5{
                // Fade out
                withAnimation(.easeInOut(duration: 0.3)) {
                    textOpacity = 0
                }
                try await Task.sleep(nanoseconds: 250_000_000) //
                
                // Fade in
                withAnimation(.easeInOut(duration: 0.3)) {
                    textOpacity = 1
                }
                try await Task.sleep(nanoseconds: 250_000_000) //
            }
        }
    }
    
    func onReceiveResponse () {
        
        if !model.gameOver {
            model.timeElapsed += 1  // tick the clock if game not over
            
        }
        
        if model.gameOver {       // GAMEOVER CHECK HERE ........................XXXXXXXXXXXXXXXXXXXXXXXX
            
            storedplayerName = model.playerNameRecovered // Copy from Model
            
            let tempIndex = Int(model.thisPhotoCount )
            
            if (model.averageMatchTime) < bestTimes[tempIndex] {  // Is this time a record ?  MAIN POINT OF APP
                
                bestTimes[tempIndex] = (model.averageMatchTime) // if so ... put it in the bestTimes array
                
                showingSheet = true // bring up the smiley face congrats you go the record sheet
                
              //  model.bestTimesCopy = bestTimes // save updated bestTimes for later transfer
                
            }
        }
        
    }
    
    func alertResponse () -> Alert {
        
        Alert(
            title: Text("Are you sure you want to reset faster times ever "),
            message: Text("There is no undo"),
            primaryButton: .destructive(Text("Reset")) {
                
                showAlert = false // clear showAlert trigger 'cos we're in it
                
                bestTimes = [1500.0, 1500.0, 1500.0,1500.0,1500.0,1500.0,1500.0,1500.0,1500.0, 1500.0] // reset to default values
                
                model.averageMatchTime = 1500 // Need to reset this as well to prevent triggering sheet again
                
             //   model.bestTimesCopy = bestTimes // Save to Model for later transfers or further processing
                
                model.bestTimesModded = [String](repeating: "No Record Set Yet", count: 15)
                bestTimesModdedCopy = [String](repeating: "No Record Set Yet", count: 15)
                
            },
            secondaryButton: .cancel()
        )
        
        
        
    }
    
    func onApearResponce () {
        
        
            
            if playerName.isEmpty {  // bring player's attention to name not set yet
                
                flashText()  // flash the warning text several times
            }
            
            playerName = storedplayerName // Get saved playerName from AppStorage
            
            model.playerNameRecovered = playerName // Copy playerName for transfer via Model
            
            if bestTimesModdedCopy.count == 0 {      //  If no record set yet - show in display
                
                model.bestTimesModded = [String](repeating: "No Record Set Yet", count: 15)
                bestTimesModdedCopy = [String](repeating: "No Record Set Yet", count: 15)
            }
            
            model.bestTimesModded = bestTimesModdedCopy  // Get record times from @AppStorage and copy for display by bestTimesModded
            
            fetchItems() // get images data from database.
            
            if model.myImages.count < savedImages.count {  // IF IMAGEDATA HASN'T BEEN CONVERTED - CONVERT AND SAVE THE IMAGES
                
                // Translate image data to images and save to myImages and imageCopy arrays
                
                for i in 0..<savedImages.count {
                    
                    let myImageTempImageData = savedImages[i].imageData
                    
                    if let uiImage = UIImage(data: myImageTempImageData) {
                        
                        model.myImages.append(uiImage)
                        
                      // model.imagesCopy.append(uiImage)
                        
                    }
                    
                }
                
                model.builtphotos =  model.initbuiltphotos(savedImages: savedImages) // THIS DOES THE BUSINESS ... update the builtphotos image array
            }
            
        }
    }
    



/*
 
 
 @AppStorage("playerName") var storedplayerName: String = "" ...  playerName saved between sessions if app not deleted
 
 @AppStorage("bestTimesModdedCopy") var  bestTimesModdedCopy: [String] = [] ... Record times as string array
 
 @AppStorage("savedNumbers") var   bestTimes = [1500.0, et1500.01500.0,1500.0,1500.0,1500] ... Clumsy but easier than initing array with repeat
 
 @AppStorage("playerName") var storedplayerName: String = ""  //  Save current use between sessions
 
 
 
 */




