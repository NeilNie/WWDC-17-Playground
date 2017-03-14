//
//  Mind.swift
//  Swift-AI
//
//  Created by NeilNie on 03/10/2017
//

import Accelerate
import Foundation


/// An enum containing all errors that may be thrown by FFNN.
public enum MindError: Error {
    case invalidInputsError(String)
    case invalidAnswerError(String)
    case invalidWeightsError(String)
}

/// A 3-Layer Feed-Forward Artificial Neural Network
public final class Mind {
    
    /// The number of input nodes to the network (read only).
    let numInputs: Int
    /// The number of hidden nodes in the network (read only).
    let numHidden: Int
    /// The number of output nodes from the network (read only).
    let numOutputs: Int
    
    /// The 'learning rate' parameter to apply during backpropagation.
    /// This parameter may be safely tuned at any time, except for during a backpropagation cycle.
    var learningRate: Float
    
    /// The 'momentum factor' to apply during backpropagation.
    /// This parameter may be safely tuned at any time, except for during a backpropagation cycle.
    var momentumFactor: Float
    
    /// The number of input nodes, INCLUDING the bias node.
    fileprivate let numInputNodes: Int
    /// The number of hidden nodes, INCLUDING the bias node.
    fileprivate let numHiddenNodes: Int
    /// The total number of weights connecting all input nodes to all hidden nodes.
    fileprivate let numHiddenWeights: Int
    /// The total number of weights connecting all hidden nodes to all output nodes.
    fileprivate let numOutputWeights: Int
    
    /// The current weights leading into all of the hidden nodes, serialized in a single array.
    fileprivate var hiddenWeights: [Float]
    /// The weights leading into all of the hidden nodes from the previous round of training, serialized in a single array.
    /// Used for applying momentum during backpropagation.
    fileprivate var previousHiddenWeights: [Float]
    /// The current weights leading into all of the output nodes, serialized in a single array.
    fileprivate var outputWeights: [Float]
    /// The weights leading into all of the output nodes from the previous round of training, serialized in a single array.
    /// Used for applying momentum during backpropagation.
    fileprivate var previousOutputWeights: [Float]
    
    /// The most recent set of inputs applied to the network.
    fileprivate var inputCache: [Float]
    /// The most recent outputs from each of the hidden nodes.
    fileprivate var hiddenOutputCache: [Float]
    /// The most recent output from the network.
    fileprivate var outputCache: [Float]
    
    /// Temporary storage while calculating hidden errors, for use during backpropagation.
    fileprivate var hiddenErrorSumsCache: [Float]
    /// Temporary storage while calculating hidden errors, for use during backpropagation.
    fileprivate var hiddenErrorsCache: [Float]
    /// Temporary storage while calculating output errors, for use during backpropagation.
    fileprivate var outputErrorsCache: [Float]
    /// Temporary storage while updating hidden weights, for use during backpropagation.
    fileprivate var newHiddenWeights: [Float]
    /// Temporary storage while updating output weights, for use during backpropagation.
    fileprivate var newOutputWeights: [Float]
    
    /// The output error indices corresponding to each output weight.
    fileprivate var outputErrorIndices = [Int]()
    /// The hidden output indices corresponding to each output weight.
    fileprivate var hiddenOutputIndices = [Int]()
    /// The hidden error indices corresponding to each hidden weight.
    fileprivate var hiddenErrorIndices = [Int]()
    /// The input indices corresponding to each hidden weight.
    fileprivate var inputIndices = [Int]()
    
    
    /// Initializes a feed-forward neural network.
    public init(inputs: Int, hidden: Int, outputs: Int, learningRate: Float = 0.7, momentum: Float = 0.4, weights: [Float]? = nil) {
        
        self.numHiddenWeights = (hidden * (inputs + 1))
        self.numOutputWeights = (outputs * (hidden + 1))
        
        self.numInputs = inputs
        self.numHidden = hidden
        self.numOutputs = outputs
        
        self.numInputNodes = inputs + 1
        self.numHiddenNodes = hidden + 1
        
        self.learningRate = learningRate
        self.momentumFactor = momentum
        
        self.inputCache = [Float](repeating: 0, count: self.numInputNodes)
        self.hiddenOutputCache = [Float](repeating: 0, count: self.numHiddenNodes)
        self.outputCache = [Float](repeating: 0, count: outputs)
        
        self.outputErrorsCache = [Float](repeating: 0, count: self.numOutputs)
        self.hiddenErrorSumsCache = [Float](repeating: 0, count: self.numHiddenNodes)
        self.hiddenErrorsCache = [Float](repeating: 0, count: self.numHiddenNodes)
        self.newOutputWeights = [Float](repeating: 0, count: self.numOutputWeights)
        self.newHiddenWeights = [Float](repeating: 0, count: self.numHiddenWeights)

        for weightIndex in 0..<self.numOutputWeights {
            self.outputErrorIndices.append(weightIndex / self.numHiddenNodes)
            self.hiddenOutputIndices.append(weightIndex % self.numHiddenNodes)
        }
        
        for weightIndex in 0..<self.numHiddenWeights {
            self.hiddenErrorIndices.append(weightIndex / self.numInputNodes)
            self.inputIndices.append(weightIndex % self.numInputNodes)
        }
        
        self.hiddenWeights = [Float](repeating: 0, count: self.numHiddenWeights)
        self.previousHiddenWeights = self.hiddenWeights
        self.outputWeights = [Float](repeating: 0, count: outputs * self.numHiddenNodes)
        self.previousOutputWeights = self.outputWeights
        
        if let weights = weights {
            guard weights.count == numHiddenWeights + numOutputWeights else {
                print("FFNN initialization error: Incorrect number of weights provided. Randomized weights will be used instead.")
                self.randomizeWeights()
                return
            }
            self.hiddenWeights = Array(weights[0..<self.numHiddenWeights])
            self.outputWeights = Array(weights[self.numHiddenWeights..<weights.count])
        } else {
            self.randomizeWeights()
        }
        
    }
    
    public func update(inputs: [Float]) throws -> [Float] {
        // Ensure that the correct number of inputs is given
        guard inputs.count == self.numInputs else {
            throw MindError.invalidAnswerError("Invalid number of inputs given: \(inputs.count). Expected: \(self.numInputs)")
        }
        
        // Cache the inputs
        // Note: A bias node is inserted at index 0, followed by each of the given inputs
        self.inputCache[0] = 1.0
        for i in 1..<self.numInputNodes {
            self.inputCache[i] = inputs[i - 1]
        }
        
        // Calculate the weighted sums for the hidden layer
        vDSP_mmul(self.hiddenWeights, 1,
            self.inputCache, 1,
            &self.hiddenOutputCache, 1,
            vDSP_Length(self.numHidden), vDSP_Length(1), vDSP_Length(self.numInputNodes))
        
        // Apply the activation function to the hidden layer nodes
        // Note: Array elements are shifted one index to the right, in order to efficiently insert the bias node at index 0
        self.activateHidden()
        
        // Calculate the weighted sums for the output layer
        vDSP_mmul(self.outputWeights, 1,
            self.hiddenOutputCache, 1,
            &self.outputCache, 1,
            vDSP_Length(self.numOutputs), vDSP_Length(1), vDSP_Length(self.numHiddenNodes))
        
        // Apply the activation function to the output layer nodes
        self.activateOutput()
        
        // Return the final outputs
        return self.outputCache
    }
    
    public func backpropagate(answer: [Float]) throws -> Float {
        // Verify valid answer
        guard answer.count == self.numOutputs else {
            throw MindError.invalidAnswerError("Invalid number of outputs given in answer: \(answer.count). Expected: \(self.numOutputs)")
        }
        
        // Calculate output errors
        for (outputIndex, output) in self.outputCache.enumerated() {
            self.outputErrorsCache[outputIndex] = self.activationDerivative(output) * (answer[outputIndex] - output)
        }
        
        // Calculate hidden errors
        vDSP_mmul(self.outputErrorsCache, 1,
            self.outputWeights, 1,
            &self.hiddenErrorSumsCache, 1,
            vDSP_Length(1), vDSP_Length(self.numHiddenNodes), vDSP_Length(self.numOutputs))
        for (errorIndex, error) in self.hiddenErrorSumsCache.enumerated() {
            self.hiddenErrorsCache[errorIndex] = self.activationDerivative(self.hiddenOutputCache[errorIndex]) * error
        }
        
        // Update output weights
        for weightIndex in 0..<self.outputWeights.count {
            let offset = self.outputWeights[weightIndex] + (self.momentumFactor * (self.outputWeights[weightIndex] - self.previousOutputWeights[weightIndex]))
            let errorIndex = self.outputErrorIndices[weightIndex]
            let hiddenOutputIndex = self.hiddenOutputIndices[weightIndex]
            let mfLRErrIn = self.outputErrorsCache[errorIndex] * self.hiddenOutputCache[hiddenOutputIndex]
            self.newOutputWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(outputWeights, &previousOutputWeights, 1, vDSP_Length(numOutputWeights), 1, 1)
        vDSP_mmov(newOutputWeights, &outputWeights, 1, vDSP_Length(numOutputWeights), 1, 1)
        
        // Update hidden weights
        for weightIndex in 0..<self.hiddenWeights.count {
            let offset = self.hiddenWeights[weightIndex] + (self.momentumFactor * (self.hiddenWeights[weightIndex]  - self.previousHiddenWeights[weightIndex]))
            let errorIndex = self.hiddenErrorIndices[weightIndex]
            let inputIndex = self.inputIndices[weightIndex]
            // Note: +1 on errorIndex to offset for bias 'error', which is ignored
            let mfLRErrIn = self.hiddenErrorsCache[errorIndex + 1] * self.inputCache[inputIndex]
            self.newHiddenWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(hiddenWeights, &previousHiddenWeights, 1, vDSP_Length(numHiddenWeights), 1, 1)
        vDSP_mmov(newHiddenWeights, &hiddenWeights, 1, vDSP_Length(numHiddenWeights), 1, 1)
        
        // Sum and return the output errors
        return self.outputErrorsCache.reduce(0, { (sum, error) -> Float in
            return sum + abs(error)
        })
    }

    public func train(inputs: [[Float]], answers: [[Float]], testInputs: [[Float]], testAnswers: [[Float]], errorThreshold: Float) throws -> [Float] {
        guard errorThreshold > 0 else {
            throw MindError.invalidInputsError("Error threshold must be greater than zero!")
        }
        
        // TODO: Allow trainer to exit early or regenerate new weights if it gets stuck in local minima
        
        // Train forever until the desired error threshold is met
        while true {
            for (index, input) in inputs.enumerated() {
                try self.update(inputs: input)
                try self.backpropagate(answer: answers[index])
            }
            // Calculate the total error of the validation set after each epoch
            let errorSum: Float = try self.error(testInputs, expected: testAnswers)
            if errorSum < errorThreshold {
                break
            }
        }
        return self.hiddenWeights + self.outputWeights
    }
    
    /// Returns a serialized array of the network's current weights.
    public func getWeights() -> [Float] {
        return self.hiddenWeights + self.outputWeights
    }
    
    /// Resets the network with the given weights (i.e. from a pre-trained network).
    /// This change may be performed at any time except while the network is in the process of updating or backpropagating.
    /// - Parameter weights: An array of `Float`s, to be used as the weights for the network.
    /// - Important: The number of weights must equal numHidden * (numInputs + 1) + numOutputs * (numHidden + 1),
    /// or the weights will be rejected.
    public func resetWithWeights(_ weights: [Float]) throws {
        guard weights.count == self.numHiddenWeights + self.numOutputWeights else {
            throw MindError.invalidWeightsError("Invalid number of weights provided: \(weights.count). Expected: \(self.numHiddenWeights + self.numOutputWeights)")
        }
        
        self.hiddenWeights = Array(weights[0..<self.hiddenWeights.count])
        self.outputWeights = Array(weights[self.hiddenWeights.count..<weights.count])
    }
}

// MARK:- FFNN private methods

public extension Mind {
    
    /// Returns an NSURL for a document with the given filename in the default documents directory.
    public static func getFileURL(_ filename: String) -> URL {
        let manager = FileManager.default
        let dirURL = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return dirURL.appendingPathComponent(filename)
    }
    
    /// Reads a FFNN stored in a file at the given URL.
    public static func read(_ url: URL) -> Mind? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let storage = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : AnyObject] else {
            return nil
        }
        
        // Read dictionary from file
        guard let numInputs = storage["inputs"] as? Int,
            let numHidden = storage["hidden"] as? Int,
            let numOutputs = storage["outputs"] as? Int,
            let momentumFactor = storage["momentum"] as? Float,
            let learningRate = storage["learningRate"] as? Float,
            let hiddenWeights = storage["hiddenWeights"] as? [Float],
            let outputWeights = storage["outputWeights"] as? [Float] else {
                return nil
        }
        let weights = hiddenWeights + outputWeights
        
        let n = Mind(inputs: numInputs, hidden: numHidden, outputs: numOutputs, learningRate: learningRate, momentum: momentumFactor, weights: weights)
        return n
    }
    
    /// Writes the current state of the FFNN to a file at the given URL.
    public func write(_ url: URL) {
        var storage = [String : AnyObject]()
        storage["inputs"] = self.numInputs as AnyObject
        storage["hidden"] = self.numHidden as AnyObject
        storage["outputs"] = self.numOutputs as AnyObject
        storage["learningRate"] = self.learningRate as AnyObject
        storage["momentum"] = self.momentumFactor as AnyObject
        storage["hiddenWeights"] = self.hiddenWeights as AnyObject
        storage["outputWeights"] = self.outputWeights as AnyObject
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: storage)
        try? data.write(to: url, options: [.atomic])
    }
    
    /// Computes the error over the given training set.
    public func error(_ result: [[Float]], expected: [[Float]]) throws -> Float {
        
        var errorSum: Float = 0
        for (inputIndex, input) in result.enumerated() {
            let outputs = try self.update(inputs: input)
            for (outputIndex, output) in outputs.enumerated() {
                errorSum += abs(self.activationDerivative(output) * (expected[inputIndex][outputIndex] - output))
            }
        }
        errorSum /= Float(result.count)
        return errorSum
    }
    
    /// Applies the activation function to the hidden layer nodes.
    fileprivate func activateHidden() {
        for i in (1...self.numHidden).reversed() {
            self.hiddenOutputCache[i] = sigmoid(self.hiddenOutputCache[i - 1])
        }
    }
    
    /// Applies the activation function to the output layer nodes.
    fileprivate func activateOutput() {
        for i in 0..<self.numOutputs {
            self.outputCache[i] = sigmoid(self.outputCache[i])
        }
    }
    
    /// Calculates the derivative of the activation function, from the given `y` value.
    fileprivate func activationDerivative(_ output: Float) -> Float {
        return sigmoidDerivative(output)
    }
    
    /// Randomizes all of the network's weights, from each layer.
    fileprivate func randomizeWeights() {
        for i in 0..<self.numHiddenWeights {
            self.hiddenWeights[i] = randomWeight(numInputNodes: self.numInputNodes)
        }
        for i in 0..<self.numOutputWeights {
            self.outputWeights[i] = randomWeight(numInputNodes: self.numHiddenNodes)
        }
    }
    
}

// TODO: Generate random weights along a normal distribution, rather than a uniform distribution.
// Also, these weights are only optimal for sigmoid activation. They don't work well with other functions

/// Generates a random weight for a layer node, based on the parameters set for the network.
/// Will return a Float between +/- 1/sqrt(numInputNodes).
private func randomWeight(numInputNodes: Int) -> Float {
    let range = 1 / sqrt(Float(numInputNodes))
    let rangeInt = UInt32(2_000_000 * range)
    let randomFloat = Float(arc4random_uniform(rangeInt)) - Float(rangeInt / 2)
    return randomFloat / 1_000_000
}

// MARK: Error Functions

/// Sigmoid activation function.
private func sigmoid(_ x: Float) -> Float {
    return 1 / (1 + exp(-x))
}
/// Derivative for the sigmoid activation function.
private func sigmoidDerivative(_ y: Float) -> Float {
    return y * (1 - y)
}
