//
//  SwiftMind.swift
//
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation
import UIKit

public class Trainer {
    
    public var swiftMind : SwiftMind
    var trainImages = [[Float]]()
    var trainLabels = [UInt8]()
    var testImages = [[Float]]()
    var testLabels = [UInt8]()
    
    func extractTrainingData() {
        print("Extracting training data...")
        // Create variables for storing data
        var trainImages = [[Float]]()
        var trainLabels = [UInt8]()
        var testImages = [[Float]]()
        var testLabels = [UInt8]()
        // Define image size
        let numTrainImages = 60_000
        let numTestImages = 10_000
        let imageSize = CGSize(width: 28, height: 28)
        let numPixels = Int(imageSize.width * imageSize.height)
        // Extract training data
        let executablePath = Bundle.main.executablePath!
        let projectURL = NSURL(fileURLWithPath: executablePath).deletingLastPathComponent
        let trainImagesURL = projectURL?.appendingPathComponent("train-images-idx3-ubyte")
        let trainImagesData = try! Data(contentsOf: trainImagesURL!)
        // Extract testing data
        let testImagesURL = projectURL?.appendingPathComponent("t10k-images-idx3-ubyte")
        let testImagesData = try! Data(contentsOf: testImagesURL!)
        // Extract training labels
        let trainLabelsURL = projectURL?.appendingPathComponent("train-labels-idx1-ubyte")
        let trainLablelsData = try! Data(contentsOf: trainLabelsURL!)
        // Extract testing labels
        let testLabelsURL = projectURL?.appendingPathComponent("t10k-labels-idx1-ubyte")
        let testLablelsData = try! Data(contentsOf: testLabelsURL!)
        // Store image/label byte indices
        var imagePosition = 16 // Start after header info
        var labelPosition = 8 // Start after header info
        for imageIndex in 0..<numTrainImages {
            if imageIndex % 10_000 == 0 || imageIndex == numTrainImages - 1 {
                print("\((imageIndex + 1) * 100 / numTrainImages)%")
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
            if imageIndex < numTestImages {
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
        self.trainImages = trainImages
        self.trainLabels = trainLabels
        self.testImages = testImages
        self.testLabels = testLabels
    }
    
    init() {
        self.swiftMind = SwiftMind.init(dimension: [784, 30, 10], learningRate: 0.8, momentum: 0.0, weights: nil)
        
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
