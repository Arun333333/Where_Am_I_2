//
//  ViewController.swift
//  Where_Am_I
//
//  Created by MacsSuck on 2020-11-18.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

class HomeViewController: UIViewController {
    let dataManager     = DataManager()
    let locationManager = LocationManager()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAuth()
        
        //self.mapView.setUserTrackingMode(.follow, animated: true)
        self.loadNewLocation()
    }
    
    @IBAction func refreshLocation(_ sender: Any) {
        self.loadNewLocation()
    }
    
    func loading(_ condition:Bool) {
        self.refreshButton.isHidden = condition
        if condition {
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    func loadNewLocation() {
        self.loading(true)
        
        self.locationManager.requestCurrentLocation { loc, error in
            self.loading(false)

            if let error = error {
                // handle error
                print(error)
                return
            }
            
            guard let location  = loc else {
                print ("Unknown location!")
                return
            }
            
            print("Inside the view controller \(location)")
            
            // load map detrails
            self.mapView.centerToLocation(location, regionRadius: 1000)
            self.loadAddress(location: location)
        }
    }
    
    func loadAddress(location:CLLocation) {
        self.loading(true)
        location.geocode { placemark, error in
            self.loading(false)

            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                    /*print("name:", placemark.name ?? "unknown")
                    print("address1:", placemark.thoroughfare ?? "unknown")
                    print("address2:", placemark.subThoroughfare ?? "unknown")
                    print("neighborhood:", placemark.subLocality ?? "unknown")
                    print("city:", placemark.locality ?? "unknown")
                    print("state:", placemark.administrativeArea ?? "unknown")
                    print("subAdministrativeArea:", placemark.subAdministrativeArea ?? "unknown")
                    print("zip code:", placemark.postalCode ?? "unknown")
                    print("country:", placemark.country ?? "unknown", terminator: "\n\n")
                    print("isoCountryCode:", placemark.isoCountryCode ?? "unknown")
                    print("region identifier:", placemark.region?.identifier ?? "unknown")
                    print("timezone:", placemark.timeZone ?? "unknown", terminator:"\n\n")*/
                    
                    // Mailing Address
                    print(placemark.mailingAddress ?? "unknown")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    let annotation = MKPointAnnotation()
                    annotation.title = placemark.mailingAddress
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    self.saveLocation(location: location, mailingAddress: placemark.mailingAddress, retrival: Date())
                }
            }
        }
    }
    
    func saveLocation (location:CLLocation, mailingAddress:String?, retrival time:Date) {
        //save data
        let _ = DataManager.shared.location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, mailingAddress: mailingAddress, time: time)
        DataManager.shared.save()
    }
}

