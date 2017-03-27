import UIKit
import PlaygroundSupport
/*:
 # Reconigze Handwritten digits
 
 It's time to put our work into action, let's recongize some digits. I created a HandwritingView class, which can be found in the playground timeline. Write a digit on the screen and the result will be displayed in the bottom. Click clear to clear the canvas.
 */
var view = HandwritingView(frame: CGRect.init(x: 0, y: 0, width: 500, height: 780))
PlaygroundPage.current.liveView = view
/*:
 HandwritingView class include a SwiftMind instance. The neural network is loaded from the stored file, mindData (can be found in the Resources folder). HandwritingView will convert your written digit into a 28*28 image which can be passed in to the neural network.
 
 You might realize that sometimes the software fails to recognize some digits, even though the network can recongize more than 95% of the testing data.
 */
