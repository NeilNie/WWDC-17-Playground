//
//  ViewController.swift
//  SwiftMind-test
//
//  Created by Yongyang Nie on 3/14/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize network
        
        let weights : [[Float]] = [[-0.191460997, -0.144060001, 0.0403629988, -0.0634189993, -0.400186002, 0.365294993], [-0.287294, -0.0223479997, -0.409287989]]
        
        let network = SwiftMind(size: [2, 2, 1], learningRate: 0.2, momentum: 0.5, weights: weights)
        
        // Create training data
        let inputs: [[Float]] = [
            [0, 0], [0, 1], [1, 0], [1, 1]]
        
        // Define answers for training data
        let answers: [[Float]] = [
            [0], [1], [1], [0]]
        
        for _ in 0..<20000{
            for i in 0..<4{
                _ = try! network.predict(inputs: inputs[i])
                try! network.backProp(answers: answers[i])
                print(network.errors.last!)
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

