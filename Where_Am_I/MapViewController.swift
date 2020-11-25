//
//  MapView.swift
//  Where_Am_I
//
//  Created by Arundeep Singh on 2020/11/21.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController {
    var location : Location?
    var locations : [Location]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let l = location {
            self.dropPin(location: l)
        }
        
        if let ls = locations {
            self.dropPins(locations: ls, and: true)
        }
    }
    
    func dropPin(location : Location) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = location.address
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.centerToLocation(location.location, regionRadius: 1000)
    }
    
    func dropPins(locations:[Location], and navigate:Bool) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        for loc in locations {
            let annotation = MKPointAnnotation()
            annotation.title = loc.address
            annotation.coordinate = loc.coordinate
            self.mapView.addAnnotation(annotation)
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: locations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }

            let route = response.routes[0]

            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension MapViewController : MKMapViewDelegate{
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

        renderer.lineWidth = 5.0

        return renderer
    }
}
