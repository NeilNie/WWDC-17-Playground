//:  [Table of Contents](Table%20of%20contents) | [Next](Finale) | [Previous](Training%20a%20neural%20network)
import UIKit
import PlaygroundSupport
/*:
 # Reconigze Handwritten digits
 
 It's time to put our work into action, let's recongize some digits. I created a HandwritingView class, which can be found in the playground timeline. Write a digit on the screen and the result will be displayed in the bottom. Click clear to clear the canvas.
 */
var view = HandwritingView(frame: CGRect.init(x: 0, y: 0, width: 500, height: 780))
PlaygroundPage.current.liveView = view
/*:
 HandwritingView class includes a `SwiftMind` instance. Note:
 In order to save time and improve accuracy, the neural network in handwriting view is initialized with `mindData` file in the Recourses folder. I trained a neural network on my computer with the exact MNIST datas and classes in this playground. The network has a 95% success rate, which was turned into a file with `Storage` class.
 
 HandwritingView will crop and scale your written digit into a 28*28 image. Then the image is converted into an array with pixel alpha values, which can be passed in to the neural network.
 */
//:  [Table of Contents](Table%20of%20contents) | [Next](Finale) | [Previous](Training%20a%20neural%20network)