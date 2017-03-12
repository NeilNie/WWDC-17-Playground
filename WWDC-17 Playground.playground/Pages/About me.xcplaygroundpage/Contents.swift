/*:
 [Next](@next)
 
 # WWDC-17 Playground
 -- by Neil Nie
    March - April, 2017
*/
import Foundation
import MapKit
import CoreLocation
import PlaygroundSupport

/*:
 ## About me
 */
var str = "Hello, I am Yongyang, you can call me Neil"

/*:
 
 I was born in Beijing and grew up in Beijing. When I was twelve, my family and I moved to the United States. Now I am currently attending Deerfield Academy in MA.
*/
let home = CLLocationCoordinate2DMake(39.9042, 116.4074)
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:500, height:500))

var mapRegion = MKCoordinateRegion()
mapRegion.center = home;
mapRegion.span.latitudeDelta = 0.05
mapRegion.span.longitudeDelta = 0.05
mapView.setRegion(mapRegion, animated: true)

let annotation = MKPointAnnotation()
annotation.coordinate = home
annotation.title = "Neil's home"
annotation.subtitle = "Beijing, PRC"

mapView.addAnnotation(annotation)
PlaygroundPage.current.liveView = mapView

/*:
 I begin developing iOS applications since I was thirteen. Over the past four and half years, I have made and publish any apps, from fitness trackers to task mangers; from voice controlled calculator to simple games.
 */
