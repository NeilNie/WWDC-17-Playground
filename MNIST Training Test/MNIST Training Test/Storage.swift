//
//  Storage.swift
//  MNIST Training Test
//
//  Created by Yongyang Nie on 3/18/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import Cocoa

class Storage {
    
    /// Returns an NSURL for a document with the given filename in the default documents directory.
    public class func getFileURL(_ filename: String) -> URL {
        let manager = FileManager.default
        let dirURL = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return dirURL.appendingPathComponent(filename)
    }
    
    /// Reads a FFNN stored in a file at the given URL.
    public class func read(_ url: URL) -> SwiftMind? {
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let storage = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : AnyObject] else {
            return nil
        }
        
        // Read dictionary from file
        guard let size = storage["size"] as? [Int],
            let momentum = storage["momentum"] as? Float,
            let learningRate = storage["learningRate"] as? Float,
            let weights = storage["weights"] as? [[Float]] else {
                return nil
        }
        let n = SwiftMind.init(size: size, learningRate: learningRate, momentum: momentum, weights: weights)
        return n
    }
    
    /// Writes the current state of the FFNN to a file at the given URL.
    public class func write(_ url: URL, _ mind: SwiftMind) {
        
        var storage = [String : AnyObject]()
        storage["size"] = mind.dimension as AnyObject
        storage["weights"] = mind.weights  as AnyObject
        storage["learningRate"] = mind.learningRate as AnyObject
        storage["momentum"] = mind.momentum as AnyObject
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: storage)
        try? data.write(to: url, options: [.atomic])
    }
    /// Reads a FFNN stored in a file at the given URL.
    public class func readData(_ url: URL) -> (trainImg: [[Float]], testImg: [[Float]], trainLbl: [UInt8], testLbl: [UInt8])? {
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let storage = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : AnyObject] else {
            return nil
        }
        
        return ((storage["trainImg"] as? [[Float]])!, (storage["testImg"] as? [[Float]])!, (storage["trainLbl"] as? [UInt8])!, (storage["testLbl"] as? [UInt8])!)
    }
    
    /// Writes the current state of the FFNN to a file at the given URL.
    public class func writeData(url: URL, trainImg: [[Float]], testImg: [[Float]], trainLbl: [UInt8], testLbl: [UInt8]) {
        
        print("writing to file")
        var storage = [String : AnyObject]()
        storage["trainImg"] = trainImg as AnyObject
        storage["testImg"] = testImg  as AnyObject
        storage["trainLbl"] = trainLbl as AnyObject
        storage["testLbl"] = testLbl as AnyObject
        print("writing")
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: storage)
        try? data.write(to: url, options: [.atomic])
    }

}
