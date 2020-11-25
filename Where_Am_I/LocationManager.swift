//
//  LocationManager.swift
//  Where_Am_I
//
//  Created by John Poku on 2020-11-20.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case unauthorized
}

class LocationManager: NSObject {
    let clLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        clLocationManager.delegate = self
    }
    
    // NEED TO HANDLE CONDITION OF <ION 14
    var authorized: Bool {
        if #available(iOS 14.0, *) {
            let status = clLocationManager.authorizationStatus
            return status == .authorizedAlways || status == .authorizedWhenInUse
        }
        // NEED TO HANDLE CONDITION OF <ION 14 HERE
        return false
    }
    
    func requestAuth() {
        clLocationManager.requestAlwaysAuthorization()
    }
    
    private var requestedLocation: (CLLocation?, Error?) -> () = {_,_ in }
    
    func requestCurrentLocation(_ cb: @escaping (CLLocation?, Error?) -> ()) {
        guard authorized else {
            cb(nil, LocationError.unauthorized)
            return
        }
        
        requestedLocation = cb
        self.clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clLocationManager.pausesLocationUpdatesAutomatically = true
        self.clLocationManager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("authorized \(authorized)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        requestedLocation(location, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location manager \(error)")
    }
}
