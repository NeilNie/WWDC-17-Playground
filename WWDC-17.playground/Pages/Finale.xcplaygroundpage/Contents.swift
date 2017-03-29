//: [Previous](@previous)
import Foundation
import UIKit
import PlaygroundSupport
/*:
 # Finale
 */
 /*:
 Thank you for staying with me throughtout this journey. We have explored the advantages of neural networks, how to create one, and use one to recognize handwritings. 
 
  You might realize that sometimes the software fails to recognize some digits, even though the network can recongize more than 95% of the testing data.
 
 To further illustrate the power of neural networks and how cool they are, I created handwriting learner view that can generate images of numbers instead of recognizing them. Instead of giving the network pixels, I give the network
 */
let input = [0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
/*:
 And ask the network to generate 784 pixels.
 */
var view = LearnerView()
PlaygroundPage.current.liveView = view
/*:
 I hope you have joyed this playground. I look forward to a wonderful WWDC this year!
 */
//: [Next](@next)
