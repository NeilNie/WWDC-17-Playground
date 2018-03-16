// Arithmetic.swift
//
// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
// This version by Neil Nie
// Copyright (c) 2017
// MIT License
// 

import Accelerate

public func transpose(x: [[Double]]) -> [Double] {
    let output = [Double]()
    
    return output
}

public func sigmoid(x: [Double]) -> [Double]{
    var output = x;
    for i in 0..<x.count{
        output[i] = Double(NNMath.sigmoid(Float(x[i])))
    }
    return output
}

public func sigmoidPrime(x: [Double]) -> [Double]{
    var output = x;
    for i in 0..<x.count{
        output[i] = NNMath.sigmoidPrimed(y: x[i])
    }
    return output
}

// MARK: Sum

public func float(a: [Double]) -> [Float] {
    
    var f = [Float]()
    for n in a {
        f.append(Float(n))
    }
    return f
}

public func sum(_ x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_sve(x, 1, &result, vDSP_Length(x.count))

    return result
}

public func sum(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_sveD(x, 1, &result, vDSP_Length(x.count))

    return result
}

// MARK: Add

public func add(_ x: [Float], y: [Float]) -> [Float] {
    var results = [Float](y)
    cblas_saxpy(Int32(x.count), 1.0, x, 1, &results, 1)

    return results
}

public func add(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](y)
    cblas_daxpy(Int32(x.count), 1.0, x, 1, &results, 1)

    return results
}

// MARK: Subtraction

public func sub(_ x: [Float], y: [Float]) -> [Float] {
    var results = [Float](y)
    catlas_saxpby(Int32(x.count), 1.0, x, 1, -1, &results, 1)
    
    return results
}

public func sub(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](y)
    catlas_daxpby(Int32(x.count), 1.0, x, 1, -1, &results, 1)
    
    return results
}

// MARK: Multiply

public func mul(_ x: [Float], y: [Float]) -> [Float] {
    var results = [Float](repeating: 0.0, count: x.count)
    vDSP_vmul(x, 1, y, 1, &results, 1, vDSP_Length(x.count))

    return results
}

public func mul(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))

    return results
}

// MARK: Dot Product

public func dot(_ x: [Float], y: [Float]) -> Float {
    precondition(x.count == y.count, "Vectors must have equal count")

    var result: Float = 0.0
    vDSP_dotpr(x, 1, y, 1, &result, vDSP_Length(x.count))

    return result
}


public func dot(_ x: [Double], y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")

    var result: Double = 0.0
    vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))

    return result
}

// MARK: - Operators

public func + (lhs: [Float], rhs: [Float]) -> [Float] {
    return add(lhs, y: rhs)
}

public func + (lhs: [Double], rhs: [Double]) -> [Double] {
    return add(lhs, y: rhs)
}

public func + (lhs: [Float], rhs: Float) -> [Float] {
    return add(lhs, y: [Float](repeating: rhs, count: lhs.count))
}

public func + (lhs: [Double], rhs: Double) -> [Double] {
    return add(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func - (lhs: [Float], rhs: [Float]) -> [Float] {
    return sub(lhs, y: rhs)
}

public func - (lhs: [Double], rhs: [Double]) -> [Double] {
    return sub(lhs, y: rhs)
}

public func - (lhs: [Float], rhs: Float) -> [Float] {
    return sub(lhs, y: [Float](repeating: rhs, count: lhs.count))
}

public func - (lhs: [Double], rhs: Double) -> [Double] {
    return sub(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func * (lhs: [Float], rhs: [Float]) -> [Float] {
    return mul(lhs, y: rhs)
}

public func * (lhs: [Double], rhs: [Double]) -> [Double] {
    return mul(lhs, y: rhs)
}

public func * (lhs: [Float], rhs: Float) -> [Float] {
    return mul(lhs, y: [Float](repeating: rhs, count: lhs.count))
}

public func * (lhs: [Double], rhs: Double) -> [Double] {
    return mul(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

