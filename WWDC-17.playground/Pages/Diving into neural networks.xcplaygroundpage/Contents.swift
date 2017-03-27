/*:
 [Table of Contents](Table%20Of%20Contents) | [Understanding Neural Networks](Understanding%20Neural%20Networks)
 */
import UIKit
import PlaygroundSupport
/*:
 # Neural networks and machine learning
 */
var numbers = "1, 2, 3, 4"
/*:
 You can probably easily recognize those numbers above. We has humans can do effortlessly and accurately. Imagine if we can create a program that can allow computers to do the same. This problems seems simple, "Neil, we are just telling the machines to read 10 numbers!".
 
 After a couple of decades of machine learning research, scientist came to the surprising conclusion that it's extremely difficult for machines to recongnize handwritings. Tasks such as computer vision, self-driving cars are extremely hard to implement.
 
 - Important: What humans can do easily is difficult for machine, tasks that are hard for us is relatively simple for machines. This is better known as the Moravec's Paradox.
 */
var handwriting = UIImage.init(named: "MNIST_data.png");
/*:
 How do we solve the problem of computer vision or natural language processing? One of the most effective ways is to let the computer develop it's own knowledge through learning. Scientists discover a great machine learning method that is somewhat similar to human neurons, it's called neural networks. In the Today, we will combine one of the most powerful machine leanring method with one of the most elegant programming languages and create a neural network in Swift.
 */
/*:
 [Table of Contents](Table%20Of%20Contents) | [Understanding Neural Networks](Understanding%20Neural%20Networks)
 */
