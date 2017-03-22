//
//  Storage.swift
//  MNIST Training Test
//
//  Created by Yongyang Nie on 3/18/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import Foundation

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
        let n = SwiftMind()
        n.dimension = size
        n.weights = weights
        n.learningRate = learningRate
        n.momentum = momentum
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

}
