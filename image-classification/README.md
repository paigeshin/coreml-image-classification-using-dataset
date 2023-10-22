### Download Dataset

https://www.kaggle.com/datasets/moltean/fruits

### Vision Framework

- Computers "see" and understand about the contents of digital images and videos
- Landmark detection
- Text detection
- Barcode recognition
- Image registration
- Feature Tracking

### VisionClassifier

```swift
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

```

### Implementations

```swift
    private var classifier: VisionClassifier? {
        guard let model = try? FruitClassifier(configuration: MLModelConfiguration()).model else { return nil }
        return VisionClassifier(mlModel: model)
    }

    // perform image classification
    self.classifier?.classify(self.image!, completion: { result in
        self.label = result
    })

```
