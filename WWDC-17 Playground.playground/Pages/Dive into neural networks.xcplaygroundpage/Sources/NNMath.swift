//
//  NNMath.swift
//  
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation

class NNMath: NSObject {
    
    /**
     @brief Apply sigmoid function to a given value
     */
    class func sigmoid(x: Float) -> Float{
        return 1 / (1 + powf(Float(M_E), x))
    }
    
    /**
     @brief Apply sigmoid prime function to a given value
     */
    class func sigmoidPrime(y: Float) -> Float{
        return y * (1 - y)
    }
}
