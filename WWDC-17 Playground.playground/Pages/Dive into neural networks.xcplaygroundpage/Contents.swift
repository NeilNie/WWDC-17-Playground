import UIKit
import PlaygroundSupport

/*:
 # Neural networks and machine learning
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
 ## Let's recongize numbers
 */
/*
 ## Building a framework
 
 */
