//
//  HandwritingLearnViewController.swift
//  Swift-AI-iOS
//
//  Created by Neil Nie on March 01 2017
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit

class LearnerView : UIView{
    
    var network: SwiftMind!
    var textField = UITextField()
    var canvas = UIImageView()
    var processButton = UIButton()
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let url = Bundle.main.url(forResource: "MindData_learn", withExtension: nil)!
        self.network = Storage.read(url)
        
        backgroundColor = UIColor.init(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
        canvas = UIImageView(frame: CGRect.init(x: 25, y: 60, width: Double(frame.size.width - 50), height: 470))
        canvas.backgroundColor = UIColor.white
        self.addSubview(canvas)
        
        processButton = UIButton(frame: CGRect.init(x: 330, y: 13, width: 80, height: 50))
        processButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        processButton.setTitle("Clear", for: UIControlState.normal)
        processButton.addTarget(self, action: #selector(generate(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(processButton)
        
        textField = UITextField(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        self.addSubview(textField)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generate(sender: UIButton?) {
        self.canvas.image = self.generateCharacter(digit: Int(self.textField.text!)!)
    }
}

// MARK: Neural network and drawing methods

extension LearnerView {
    
    public func generateCharacter(digit: Int) -> UIImage? {
        guard let inputArray = self.digitToArray(digit: digit) else {
            print("Error: Invalid digit: \(digit)")
            return nil
        }
        do {
            let output = try self.network.predict(inputs: inputArray)
            let image = self.pixelsToImage(pixelFloats: output!)
            return image
        } catch {
            print(error)
        }
        return nil
    }
    
    private func pixelsToImage(pixelFloats: [Float]) -> UIImage? {
        guard pixelFloats.count == 784 else {
            print("Error: Invalid number of pixels given: \(pixelFloats.count). Expected: 784")
            return nil
        }
        struct PixelData {
            let a: UInt8
            let r: UInt8
            let g: UInt8
            let b: UInt8
        }
        var pixels = [PixelData]()
        for pixelFloat in pixelFloats {
            pixels.append(PixelData(a: UInt8(pixelFloat * 255), r: 0, g: 0, b: 0))
        }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        var data = pixels
        let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size))
        let cgim = CGImage(width: 28, height: 28, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: 28 * MemoryLayout<PixelData>.size, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        return UIImage(cgImage: cgim!)
    }
    
    
    private func digitToArray(digit: Int) -> [Float]? {
        guard digit >= 0 && digit <= 9 else {
            return nil
        }
        var array = [Float](repeating: 0, count: 10)
        array[digit] = 1
        return array
    }
    
}
