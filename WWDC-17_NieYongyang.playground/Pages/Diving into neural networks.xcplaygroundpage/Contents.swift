/*:
 [Table of Contents](Table%20of%20contents) | [Next](Understanding%20neural%20networks)
 */
import UIKit
import PlaygroundSupport
/*:
 # Diving into neural networks 🏊
 */
var numbers = "1, 2, 3, 4"
/*:
 You can probably easily recognize those numbers above. We as humans can do this effortlessly and accurately. Imagine if we can create a program that can allow computers to do the same. This problem seems simple, what's so hard about making a program to recognize digits?
 
 After a couple of decades of machine learning research, scientist came to the surprising conclusion that it's extremely difficult for machines to recongnize handwritings. One of the first solution comes to mind is to program rules to characterize those digits. But, this was a narrow approach. Once rules add up, it's hard to debug and maintain.
 
 Computer scienctists realized that tasks such as computer 👀, self-driving 🚙 are extremely hard to implement.
 
 - Important: What humans can do easily is difficult for machine, tasks that are hard for us is relatively simple for machines. This is better known as the Moravec's Paradox.
 */
var handwriting = UIImage.init(named: "MNIST_data.png");
/*:
 How do we solve the problem of computer vision or natural language processing? One of the most effective ways is to let the computer develop it's own knowledge through learning. Scientists discovered a great machine learning method, inspired by human neurons, it's called neural networks. Today, we will combine one of the most powerful machine leanring algorithm with one of the most elegant programming languages and create a neural network in Swift.
 */
/*:
 [Table of Contents](Table%20of%20contents) | [Next](Understanding%20neural%20networks)
 */
