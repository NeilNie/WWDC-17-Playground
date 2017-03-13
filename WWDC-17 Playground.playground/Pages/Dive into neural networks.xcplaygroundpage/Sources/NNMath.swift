//
//  NNMath.swift
//  
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation

public class NNMath: NSObject {
    
    /**
     @brief Apply sigmoid function to a given value
     */
    public class func sigmoid(x: Float) -> Float{
        return 1 / (1 + powf(Float(M_E), x))
    }
    
    public class func sigmoidD(x: Double) -> Double{
        return 1 / (1 + pow(M_E, x))
    }
    
    /**
     @brief Apply sigmoid prime function to a given value
     */
    public class func sigmoidPrime(y: Float) -> Float{
        return y * (1 - y)
    }
}
