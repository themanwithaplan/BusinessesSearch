//
//  BusinessDetailsViewController.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import CoreLocation

class BusinessDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var destinationPlacemark : CLPlacemark!
    var destinationPlacemarkMK : MKMapItem!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewRatings: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedBusiness : Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        nameLabel.text = selectedBusiness.name
        distanceLabel.text = String(format: "%.2f mi", selectedBusiness.distance/1609.344)
        let displayAddress = selectedBusiness.location.displayAddress.joined(separator: "\u{0085}")
        addressLabel.text = displayAddress
        reviewRatings.text = String(selectedBusiness.rating)
        let businessLongitude = selectedBusiness.coordinates.longitude
        let businessLatitude = selectedBusiness.coordinates.latitude
        self.destinationPlacemarkMK = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: businessLatitude, longitude: businessLongitude)))
        mapView.removeAnnotations(mapView.annotations)
        let annotations = MKPointAnnotation()
        annotations.title = selectedBusiness.name
        annotations.coordinate = CLLocationCoordinate2D(latitude: businessLatitude, longitude: businessLongitude)
        mapView.addAnnotation(annotations)
        self.getDirections()
    }
    
    func getDirections() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destinationPlacemarkMK
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response, error) in

            if let error = error {
               // print(error.localizedDescription)
            } else {
                if let response = response {
                    self.showRoute(response)
                }
            }
        })
    }

    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta), longitude: region.center.longitude - (region.span.longitudeDelta))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta), longitude: region.center.longitude + (region.span.longitudeDelta))
        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    func showRoute(_ response: MKDirections.Response) {
        let fastestRoute = response.routes.sorted(by: { $0.distance < $1.distance }).first!
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addOverlay(fastestRoute.polyline, level: .aboveRoads)
        let routeRect = fastestRoute.polyline.boundingMapRect
        let region = MKCoordinateRegion(routeRect)
        let resizedRouteRect = MKMapRectForCoordinateRegion(region: region)
        self.mapView.setVisibleMapRect(resizedRouteRect, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        return renderer
    }
    func handleError (_ error: Error?) {
        if let error = error {
//            print("error getting directions: \(error.localizedDescription)")
        }
    }
    
}

