//
//  SwiftMind.swift
//
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation

enum TrainerError: Error {
    case ShufflingError, TrainingError, TrainingDataError
}

final public class Trainer {
    
    public var swiftMind : SwiftMind
    var trainImages = [[Float]]()
    var trainLabels = [UInt8]()
    var testImages = [[Float]]()
    var testLabels = [UInt8]()
    
    public init() {
        print("Extracting training data...")
        // Create variables for storing data

//        let trainImagesData = try! Data(contentsOf: Bundle.main.url(forResource: "train-images-idx3-ubyte", withExtension: nil)!)
//        let testImagesData = try! Data(contentsOf: Bundle.main.url(forResource: "t10k-images-idx3-ubyte", withExtension: nil)!)
//        let trainLablelsData = try! Data(contentsOf: Bundle.main.url(forResource: "train-labels-idx1-ubyte", withExtension: nil)!)
//        let testLablelsData = try! Data(contentsOf: Bundle.main.url(forResource: "t10k-labels-idx1-ubyte", withExtension: nil)!)
    
        let trainImagesData = try! Data(contentsOf: NSURL.fileURL(withPath: "/Users/Neil/Desktop/WWDC-17-Playground/MNIST Training Test/MNIST-TrainingData/train-images-idx3-ubyte"))
        let testImagesData = try! Data(contentsOf: NSURL.fileURL(withPath: "/Users/Neil/Desktop/WWDC-17-Playground/MNIST Training Test/MNIST-TrainingData/t10k-images-idx3-ubyte"))
        let trainLablelsData = try! Data(contentsOf: NSURL.fileURL(withPath: "/Users/Neil/Desktop/WWDC-17-Playground/MNIST Training Test/MNIST-TrainingData/train-labels-idx1-ubyte"))
        let testLablelsData = try! Data(contentsOf: NSURL.fileURL(withPath: "/Users/Neil/Desktop/WWDC-17-Playground/MNIST Training Test/MNIST-TrainingData/t10k-labels-idx1-ubyte"))
        
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        
        for imageIndex in 0..<30000 {
            
            if imageIndex % 10_000 == 0 || imageIndex == 60000 - 1 {
                print("\((imageIndex + 1) * 100 / 60000)%")
            }
            // Extract training image pixels
            var trainPixelsArray = [UInt8](repeating: 0, count: 784)
            (trainImagesData as NSData).getBytes(&trainPixelsArray, range: NSMakeRange(imagePosition, 784))
            // Convert pixels to Floats
            var trainPixelsFloatArray = [Float](repeating: 0, count: 784)
            for (index, pixel) in trainPixelsArray.enumerated() {
                trainPixelsFloatArray[index] = Float(pixel) / 255
            }
            // Append image to array
            trainImages.append(trainPixelsFloatArray)
            // Extract labels
            var trainLabel = [UInt8](repeating: 0, count: 1)
            (trainLablelsData as NSData).getBytes(&trainLabel, range: NSMakeRange(labelPosition, 1))
            // Append label to array
            trainLabels.append(trainLabel.first!)
            // Extract test image/label if we're still in range
            if imageIndex < 10000 {
                // Extract test image pixels
                var testPixelsArray = [UInt8](repeating: 0, count: 784)
                (testImagesData as NSData).getBytes(&testPixelsArray, range: NSMakeRange(imagePosition, 784))
                // Convert pixels to Floats
                var testPixelsFloatArray = [Float](repeating: 0, count: 784)
                for (index, pixel) in testPixelsArray.enumerated() {
                    testPixelsFloatArray[index] = Float(pixel) / 255
                }
                // Append image to array
                testImages.append(testPixelsFloatArray)
                // Extract labels
                var testLabel = [UInt8](repeating: 0, count: 1)
                (testLablelsData as NSData).getBytes(&testLabel, range: NSMakeRange(labelPosition, 1))
                // Append label to array
                testLabels.append(testLabel.first!)
            }
            // Increment counters
            imagePosition += 784
            labelPosition += 1
        }

        Storage.writeData(url: Storage.getFileURL("MNIST_data"), trainImg: trainImages, testImg: testImages, trainLbl: trainLabels, testLbl: testLabels)
        
        print("Finished, extracted: \(trainImages.count) training images")
        
        swiftMind = SwiftMind(size: [784, 35, 10], learningRate: 0.2, momentum: 0.8)
        print(swiftMind)
    }

    public func trainNetwork(batchSize: Int, accuracy: Float) {
        
        var rate : Float = 0.00;
        while rate < accuracy {
            for i in 0..<batchSize{
                _ = try! swiftMind.predict(inputs: self.trainImages[i])
                var target : [Float] = [Float](repeating: 0, count: 10)
                target[Int(self.trainLabels[i])] = 1.0
                try! swiftMind.backProp(answers: target)
            }
            rate = self.evaluate(count: 10000)
            print(rate * 100)
            let result = try! self.shuffle(array1: trainImages, array2: trainLabels)
            trainLabels = result.labels
            trainImages = result.images
        }
    }
    
    public func shuffle(array1: [[Float]], array2: [UInt8]) throws -> (images: [[Float]], labels: [UInt8]) {
        // empty and single-element collections don't shuffle
        guard array1.count == array2.count else {
            throw TrainerError.ShufflingError
        }
    
        var images = array1
        var labels = array2
        
        for i in 0 ..< array1.count {
            let j = Int(arc4random_uniform(UInt32(array1.count - i))) + i
            if i != j {
                swap(&images[i], &images[j])
                swap(&labels[i], &labels[j])
            }
        }
        return (images, labels)
    }
    
    public func evaluate(count: Int) -> Float{
        
        var correct: Float = 0.0
        
        for index in 0..<count {
            let result = try! swiftMind.predict(inputs: self.testImages[index])
            let label = self.outputResult(array: result!)?.label
            if label == Int(self.testLabels[index]) {
                correct = correct + 1.0
            }
        }
        return correct / Float(count)
    }
    
    private func outputResult(array: [Float]) -> (label: Int, percentage: Float)? {
        guard let max = array.max() else {
            return nil
        }
        return (array.index(of: max)!, max)
    }
}
