//
//  SwiftMind.swift
//
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation
import UIKit

final public class Trainer {
    
    public var swiftMind : SwiftMind
    var trainImages = [[Float]]()
    var trainLabels = [UInt8]()
    var testImages = [[Float]]()
    var testLabels = [UInt8]()
    
    public init() {
        print("Extracting training data...")
        // Create variables for storing data

        let numPixels = 784
        let trainImagesData = try! Data(contentsOf: Bundle.main.url(forResource: "train-images-idx3-ubyte", withExtension: nil)!)
        let testImagesData = try! Data(contentsOf: Bundle.main.url(forResource: "t10k-images-idx3-ubyte", withExtension: nil)!)
        let trainLablelsData = try! Data(contentsOf: Bundle.main.url(forResource: "train-labels-idx1-ubyte", withExtension: nil)!)
        let testLablelsData = try! Data(contentsOf: Bundle.main.url(forResource: "t10k-labels-idx1-ubyte", withExtension: nil)!)
        
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        
        for imageIndex in 0..<60000 {
            
            if imageIndex % 10_000 == 0 || imageIndex == 60000 - 1 {
                print("\((imageIndex + 1) * 100 / 60000)%")
            }
            // Extract training image pixels
            var trainPixelsArray = [UInt8](repeating: 0, count: numPixels)
            (trainImagesData as NSData).getBytes(&trainPixelsArray, range: NSMakeRange(imagePosition, numPixels))
            // Convert pixels to Floats
            var trainPixelsFloatArray = [Float](repeating: 0, count: numPixels)
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
                var testPixelsArray = [UInt8](repeating: 0, count: numPixels)
                (testImagesData as NSData).getBytes(&testPixelsArray, range: NSMakeRange(imagePosition, numPixels))
                // Convert pixels to Floats
                var testPixelsFloatArray = [Float](repeating: 0, count: numPixels)
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
            imagePosition += numPixels
            labelPosition += 1
        }
        
        print("Finished, extracted: \(trainImages.count) training images")
        
        swiftMind = SwiftMind.init(dimension: [784, 35, 10], learningRate: 0.8, momentum: 0.8)
    }

    public func trainNetwork(batchSize: Int, accuracy: Float) {
        
        var rate : Float = 0.00;
        while rate < accuracy {
            
            for i in 0..<batchSize{
                self.swiftMind.predict(inputs: self.trainImages[i])
                rate = self.evaluate(count: 5000);
                var target : [Float] = [Float](repeating: 0, count: 10)
                target[Int(self.trainLabels[i])] = 1.0
                self.swiftMind.backProp(target: target)
            }
        }
    }
    
    public func evaluate(count: Int) -> Float{
        
        return 0.00
    }
}
