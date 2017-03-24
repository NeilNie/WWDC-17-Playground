//: [Previous](@previous)
import Foundation
import UIKit
/*:
 # Training the neural network.
 
 After we fimilarized ourselves with neural networks, it's time to see some action. Today, create a train a neural network that can recognize handwritten digits with a success rate of 95%. The training data will be provided by the National Institude for Standards and Technology, which have been proven to be very reliable. 
 
 First we have to understand the data that we are feeding into the network. The MNIST training data contains 60000 images of handwritten digits. Each image is a 28 * 28 pixels, therefore, the number of input nodes wil be 748.
 */
var handwriting = UIImage.init(named: "MNIST_data.png");
/*:
 I decided to use 35 hidden nodes, which have proven to be reliable. The output will be a 10 by 1 matrix with values ranging from 1 to 0.
 
 For example, if the output is 5, the matrix will look like the following. Every value except index 5 is zero. The value for index 5 is one.
*/
let output = [0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
/*:
 Of course, the values will be floating point numbers that will not look like this, but they are very close to the desire value.
 
 Now, let's create the network with 784 hidden nodes, (28*28), 35 hidden nodes, and ten outputs. Learning rate and momentum below are values that helps the network learn. Details about them are beyond the scope of this playground.
 */
var neuralNetwork = SwiftMind(size: [784, 35, 10], learningRate: 0.2, momentum: 0.5)
/*:
 ## The Trainer
 
 To orangize the training process, I created the `Trainer` class that will extract training and testing data, create a neural network, and train the network.
 */
let methodStart = Date()

let trainer = Trainer()
/*:
  Inside the constructor, Trainer will extract the training and testing data, and also create a `[784, 35, 10]` neural network. In the console below, you can find details about the init process and training process.
 */
trainer.trainNetwork(batchSize: 1000, accuracy: 0.90)
/*:
 This method is where all the magic happens. First, I specified how many times to train per each batch. Secondly, I set a accuracy value to tell to network to stop training when the accuracy is above 95%. The method will return an array of floats which represents the training progress of the network. It will help us visualize the network's improvement over time. Sit back and enjoy.
 */
//: [Next](@next)