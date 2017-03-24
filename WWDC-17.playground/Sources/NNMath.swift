//
//  NNMath.swift
//  
//  (c) Yongyang Nie
//  Created by Yongyang Nie on 3/11/17.
//
// This class is written for WWDC 2017 Scholarship application

import Foundation

public class NNMath: NSObject {
    
    /**
     @brief Apply sigmoid function to a given value
     */
    /// Sigmoid activation function.
    public class func sigmoid(_ x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    /// Derivative for the sigmoid activation function.
    public class func sigmoidDerivative(_ y: Float) -> Float {
        return y * (1 - y)
    }
    
    /**
     @brief Apply sigmoid prime function to a given value
     */
    public class func sigmoidPrime(y: Float) -> Float{
        return y * (1 - y)
    }
    public class func sigmoidPrimed(y: Double) -> Double{
        return y * (1 - y)
    }
}
