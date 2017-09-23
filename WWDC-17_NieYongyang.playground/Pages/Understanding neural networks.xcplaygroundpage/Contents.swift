//:  [Table of Contents](Table%20of%20contents) | [Next](Training%20a%20neural%20network) | [Previous](Diving%20into%20neural%20networks)
import Foundation
import UIKit
/*:
 # What's a neural network
 */
var neuralNetwork = UIImage(named: "simple_nn.png")
/*:
 This is a neural network. Most neural networks are organized in layers and in each layer there are a number of nodes. Weights connect each node in the previous layer to every node in the next layer.
 
 In a typical artificial neural network, there are:
 - Input layer
 - Hidden layer(s)
 - Output layer
 - Weights
 - Baises
 */
/*:
 ## Forward Feed
 
 The first thing that any neural network has to do is to make some predictions, or return some outputs. The process can be summerized into two steps:
 - Take the previous layer output, multiply it by the weights
 - Apply activation function to the result of the previous step. (This become the output of the next layer)
 
 The two step process above is repeated until some output is yield. Here is an example:
 
 First, the neural network recieves the input matrix [input]
 */
let input =  Matrix([[1.0, 1.0]])
/*:
 Connecting the input layer to the hidden layer are some randomly generaated weights.
 */
let weights = Matrix([[0.683, 0.2373, 0.2613],
                      [-0.1892, 0.2593, 0.5824]])
/*:
 Multiply `[input]` with `[w1]`, let's call the result `[product]`.
 */
let product = input * weights
/*:
 Apply the activation function to every value in [product], this's the output values for that layer.
 - Note: 
 The activation is the sigmoid function. `f(x) = 1/(1+e^-x)`
 */
var output = activate(x: product)

var visualization = UIImage(named: "ff.png")
/*:
 ## Backpropagation
 
 Congratulations, now, our network can make some predictions. However, the predictions might be off from the desired output. Don't worry, we can go back and change the weights to make the prediction closer to the desired result. This is the math behind this:
 */
var crazyMath = UIImage(named: "crazy_math.png")
/*:
 Don't worry, this all can be done in a few steps and under 40 lines of Swift code.
 
 1. Calculate the error between layers
 2. Modify the weights with the calculation
 
 ### Step 1: Calculate error between layers
 
 1. calculate the difference between the calculated output and actual output.
 2. apply the derivative of the activation function to the calcualted output.
 3. multiple each element of those two array with each other.
 
 `outputLayerError = (calculated - desired) * activationDerivative(calculated)`.
 
 Once we know the error of the output layer, errors for previous layers can be done similarly. Here are some code demonstrating this process.
 */
//output for the middle layer
var hiddenLayerOutput = [0.3789, 0.3783, 0.3007]

//calculated output for the network. Pretty off from `desired`
var calculated = [0.3943, 0.3874]
var desired = [1.0, 1.0]

//two sets of randomly generated weights
let w1 = [[0.683, 0.2373, 0.2613],
          [-0.1892, 0.2593, 0.5824]]
let w2 = [[0.3283, 0.9373],
          [0.2013, -0.1892],
          [0.7593, 0.5804]]

var outputLayerError : [Double]
var hiddenLayerError: [Double]

// Calculate output errors
outputLayerError = sigmoidPrime(x: calculated) * (desired - calculated)

// Calculate hidden layer error
hiddenLayerError = outputLayerError * sigmoidPrime(x: hiddenLayerOutput) * transpose(x: w2)
/*:
 ### Step 2: Modify the current weights based on calculated error
 
 Now, we have calculated all the error, let's subtract that from the current weights. Hopefully, it will bring down the errors of the neural network.
 
 `newWeights (output) = oldWeights (output) - outputLayerError`
 */
/*:
 ## Training
 Similar to almost all machine learning algorithms, neural networks need to be trained in order to return useful results. The process of training is repeating forward feeding and backpropagation until the output of the network is very similar to the desired output. Later on, we will train a neural network that can recognize handwritten digits. We will repeat backpropagation, which updates the weights, until the neural network can recognize 95% of the testing data.
 */
//:  [Table of Contents](Table%20of%20contents) | [Next](Training%20a%20neural%20network) | [Previous](Diving%20into%20neural%20networks)
