//: [Previous](@previous)
import UIKit
import Foundation
/*:
 ## Forward Feeding
 
 The first thing that any neural network has to do is to make some predictions, or return some outputs. This process is quite simple. Let's use the `neuralNetwork` image above as an example.
 
 First, the neural network recieves some input, let's call it [x] (the matrix of x). [x]  is a 1 by 2 matrix with value of 1 and 0.
 */
let x =  Matrix([[1.0, 1.0]])
/*:
 Connect the input layer to the hidden layer are some weights. There are two sets of weights in our simple neural network.
 
 - Note: when a neural network is initialized, all the weights are randomly generated, with the range of [-1, 1].
 */

let w1 = Matrix([[0.683, 0.2373, 0.2613],
                 [-0.1892, 0.2593, 0.5824]])

let w2 = Matrix([[0.3283, 0.9373],
                 [ 0.2013, -0.1892],
                 [0.7593, 0.5804]])

/*:
 Each input value will be multiply by coorsponding weight, add together with each other results. This might sound complicated, but it's identical to multiplying the input values `[x]` with the weights `[w1]`. Let's call the result of that operation `[z]`.
 */
let z1 = x * w1
var output1 = activate(x: z1)
print("Hidden layer output: \(output1)")

/*:
 In the lines above, we successfully calucated the output for the hidden layer by applying the activation function to `[z1]`. Now, with `output1`, we can calculate the final output for the network with the same techneques.
 */
var z2 = output1 * w2
var output2 = activate(x: z2)
print("Final layer output: \(output2)")
var visualization = UIImage(named: "ff.png")

//: [Backpropagation](@next)