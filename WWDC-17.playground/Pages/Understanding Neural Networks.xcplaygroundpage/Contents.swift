//:  [Table of Contents](Table%20of%20contents) | [Next](Training%20a%20neural%20network) | [Previous](Diving%20into%20neural%20networks)

import Foundation
import UIKit
/*:
 # What's a neural network
 */
var neuralNetwork = UIImage(named: "simple_nn.png")
/*:
 This is a neural network. First, most neural networks are organized in layers and in each layer there are a number of nodes. Weights connect each node in the previous layer to every node in the next layer. For every layer except the last layer, there is a bias node.
 
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
 
 The two step process above is repeated until some output is yield. Here is an example
 
 First, the neural network recieves some input, let's call it matrix [x] with values 1 and 0.
 */
let x =  Matrix([[1.0, 1.0]])
/*:
 Connect the input layer to the hidden layer are some weights. There are two sets of weights in our simple neural network.
 
 - Note: when a neural network is initialized, all the weights are randomly generated, with the range of [-1, 1].
 */

let weights = Matrix([[0.683, 0.2373, 0.2613],
                 [-0.1892, 0.2593, 0.5824]])
/*:
 Each input value will be multiply by coorsponding weight, add together with each other results. This might sound complicated, but it's identical to multiplying the input values `[x]` with the weights `[w1]`. Let's call the result of that operation `[z]`.
 */
let z = x * weights
var output = activate(x: z)

var visualization = UIImage(named: "ff.png")

/*:
 ## Backpropagation

 Congratulations, now, our network can make some predictions. However, the predictions might be off from the desired output. Don't worry, we can go back and change the weights to make the prediction closer to the desired result. 
 
 ### Quantifing the error
 First, we have to come up with a way to quantify error for an output node: `1/2 * calculated_output - desired_output^2`. By adding all the errors for the output layer, we can go back to modify the weights to improve the network's performance. This is the math behind this:
*/
var crazyMath = UIImage(named: "crazy_math.png")

/*:
 Don't worry, this all can be done in two steps and under 50 lines of Swift code.
 
 1. Calculate the error between two layers
 2. Modify the weights with the calculation
 
 To better visualize this, here is a diagram
 */
var backprop = UIImage(named: "nnbp.png")

/*:
 ### Step 1: Calculate error between layers
 
 This might sound complicated, however, if we know the error for the output layer, then everything before that will fall into its place. Like I stated in the beginning, the output layer error is `(calculated - desired) * activationDerivative(calculated)`.
 
 Let's begin by declaring some variables, we are using the numbers we calculated in the previous section.
 */
var desired = [1.0, 1.0]

var hiddenLayerOutput = [0.3789, 0.3783, 0.3007]

var calculated = [0.3943, 0.3874]

var outputLayerError : [Double]

var hiddenLayerError: [Double]

let w1 = [[0.683, 0.2373, 0.2613],
          [-0.1892, 0.2593, 0.5824]]

let w2 = [[0.3283, 0.9373],
          [0.2013, -0.1892],
          [0.7593, 0.5804]]

// Calculate output errors
outputLayerError = sigmoidPrime(x: calculated) * desired - calculated

hiddenLayerError = outputLayerError * sigmoidPrime(x: hiddenLayerOutput) * transpose(x: w2)
/*:
 ### Step 2: Modify the current weights based on calculated error
 
 Now, we have calculated all the error, let's subtract that from the current weights. Hopefully, it will bring down the errors of the neural network.
 */
/*:
 ## Training
 Similar to almost all machine learning algorithms, neural networks need to be trained in order to return useful results. The process of training is repeating forward feeding and backpropagation until the output of the network reaches a certain threshold. For example, later on, we will train a neural network that can recognize handwritten digits. We will repeat backpropagation, which updates the weights, until the neural network can recognize 95% of the testing datas.
 */
//:  [Table of Contents](Table%20of%20contents) | [Next](Training%20a%20neural%20network) | [Previous](Diving%20into%20neural%20networks)
