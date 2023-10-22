//
//  ContentView.swift
//  ImageClassificationCustomDSCamera
//
//  Created by Mohammad Azam on 2/6/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var showPhotoOptions: Bool = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var label = ""
    
    private var classifier: VisionClassifier? {
        guard let model = try? FruitClassifier(configuration: MLModelConfiguration()).model else { return nil }
        return VisionClassifier(mlModel: model)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()
                Image(uiImage: self.image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Button("Choose Picture") {
                    // open action sheet
                    self.showSheet = true
                    
                }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                            .default(Text("Photo Library")) {
                                // open photo library
                                self.showPhotoOptions = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                // open camera
                                self.showPhotoOptions = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                        
                }
                
                Text(self.label)
                    .font(.largeTitle)
                    .padding(.top, 80)
                
                Spacer()
                
                Button("Classify") {
                    
                    // perform image classification
                    self.classifier?.classify(self.image!, completion: { result in
                        self.label = result
                    })
                    
                }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(10)
                
            }
            .navigationBarTitle("Image Classification")
        }.sheet(isPresented: $showPhotoOptions) {
            ImagePicker(image: self.$image, isShown: self.$showPhotoOptions, sourceType: self.sourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
