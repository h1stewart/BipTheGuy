//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Hailey Stewart on 2/14/23.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem? //an optional, meaning it could be nil
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true // 90% to 100% using spring animation
                    }
                }
            
            
            Spacer()
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            } //can add button styles to photo pickers
            .onChange(of: selectedPhoto) { newValue in
                Task{
                    do {
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data){
                                bipImage = Image(uiImage: uiImage)
                            }
                        }
                    } catch{print("😡ERROR: loading failed \(error.localizedDescription)") // a function that throws an error will give you a value **DOES NOT WORK WITH try?
                    }
                }
            }
            .padding()
        }
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else{
            print("😡 Could not read file name \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
