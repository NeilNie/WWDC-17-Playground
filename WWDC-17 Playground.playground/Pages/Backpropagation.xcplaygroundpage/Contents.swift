//: [Previous](@previous)
import Foundation
import UIKit
import Accelerate
/*:
 ## Back propagation
 
 Congratulations, now, our network can make some predictions. However, the prediction is might be off from the desired output. Don't worry, we can come up with a way to quantify error for one output node: `1/2 * pow(calculated_output - desired_output, 2)` Then, by adding all the errors for the output layer, we can go back to modify the weights to improve the network's performance. This is the math behind this:
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
//: [Recognize digits](@next)
