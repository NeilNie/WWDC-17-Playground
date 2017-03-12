//: Playground - noun: a place where people can play

import UIKit
import MapKit
import CoreLocation

var str = "Hello, my name is Neil"
let myHome = CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)
var map = MKMapView.init()
let pin = MapPin(title: "My home", locationName: "", discipline: "", coordinate: myHome);
map.addAnnotation(pin)

