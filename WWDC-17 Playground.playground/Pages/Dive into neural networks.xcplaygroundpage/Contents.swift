import UIKit
import Foundation
import Accelerate
import PlaygroundSupport

/*:
 # Neural networks and machine learning
 */

/*:
 ## Welcome!
 */
var numbers = "1, 2, 3, 4"
/*:
  You can probably easily recognize those numbers above. We has humans can do this everyday, at any moment accurately. Imagine if we can create a program that can allow computers to do the same. This problems seems simple, "Neil, we are just telling the machines to read 10 numbers!".
 
 After a couple of decades of machine learning research, scientist came to the surprising conclusion that it's extremely difficult to do this. Scientist in the past often ended up with tens of thousands of lines of code for computer vision, which is hard to maintain and limited to certain cases.
 
- Important: What humans can do easily is difficult for machine, tasks that are hard for us is relatively simple for machines. This is better known as the Moravec's Paradox.
 */
var handwriting = UIImage.init(named: "MNIST_data.png");
/*:
 How do we solve problems such as recognizing handwriting or natural language processing? Today, we will create a neural network in Swift that can recognize handwritten digits.
 
 */
/*:
 ## Table of Content
 
 - Introduction: what's a neural network
 - Forward feeding
 - Back propagation
 - Let's recognize numbers
    - Training data set
    - Training the neural network
    - Recognize handwritten digits.
 */
/*:
 ## Introduction: what's a neural networks
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

/*:
 In the lines above, we successfully calucated the output for the hidden layer by applying the activation function to `[z1]`. Now, with `output1`, we can calculate the final output for the network with the same techneques.
 */
var z2 = output1 * w2
var output2 = activate(x: z2)
print(output2)
var visualization = UIImage(named: "ff.png")

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
 
 This might sound complicated, however, if we know the error for the output layer, then everything before that will fall into its place. Like I stated in the beginning, the output layer error is `(calculated - desired) * activationDerivative(calculated)` . The error before that
 */
var hiddenLayerOutput = [Float].init()
var calculated = [Float].init()
var outputLayerError = [Float].init()
var desired = [Float].init()
var weights = [Float].init()
var hiddenLayerError = [Float].init()

// Calculate output errors
for (outputIndex, result) in calculated.enumerated() {
    outputLayerError[outputIndex] = NNMath.sigmoidPrime(y: Float(result)) * (desired[outputIndex] - result)
}

// Calculate hidden errors
vDSP_mmul(outputLayerError, 1,
          weights, 1,
          &hiddenLayerError, 1,
          vDSP_Length(1), vDSP_Length(3), vDSP_Length(2))
for (errorIndex, error) in hiddenLayerError.enumerated() {
    hiddenLayerError[errorIndex] = NNMath.sigmoidPrime(y: Float(hiddenLayerOutput[errorIndex])) * error
}

/*:
 ## Let's recongize numbers
 */

/*
 ## Building a framework
 
 */


