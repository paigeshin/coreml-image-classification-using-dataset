//
//  VisionClassifier.swift
//  fruit-classification-starter
//
//  Created by paige shin on 10/22/23.
//  Copyright © 2023 Mohammad Azam. All rights reserved.
//

import Foundation
import CoreML
import Vision
import UIKit

final class VisionClassifier {
    
    private let model: VNCoreMLModel
    private var completion: (String) -> Void = { _ in }
    
    private lazy var requests: [VNCoreMLRequest] = {
        let request = VNCoreMLRequest(model: self.model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            if !results.isEmpty {
                if let result = results.first {
                    self.completion(result.identifier)
                }
            }
        }
        request.imageCropAndScaleOption = .centerCrop
        return [request]
    }()
    
    init?(mlModel: MLModel) {
        if let model = try? VNCoreMLModel(for: mlModel) {
            self.model = model
        } else {
            return nil
        }
    }
    
    func classify(_ image: UIImage, completion: @escaping (String) -> Void) {
        self.completion = completion
        DispatchQueue.global().async {
            guard let cgImage = image.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform(self.requests)
            } catch {
                print(error)
            }
        }
    }
    
}
