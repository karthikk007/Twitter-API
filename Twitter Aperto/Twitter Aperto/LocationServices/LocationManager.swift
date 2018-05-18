//
//  LocationManager.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 11/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdate {
    func locationUpdated(location: CLLocation)
}

class LocationManager: NSObject {
    
    private let locationManager: CLLocationManager
    private let geoCoader: CLGeocoder
    
    private var location: CLLocation? {
        didSet {
            if let location = location {
                delegate?.locationUpdated(location: location)
            }
        }
    }
    
    private var delegate: LocationUpdate?

    static let shared = LocationManager()
    
    private override init() {
        locationManager = CLLocationManager()
        location = nil
        geoCoader = CLGeocoder()
        delegate = nil
        
        super.init()
        setupLocation()
    }
    
    func updateDelegate(delegate: LocationUpdate) {
        self.delegate = delegate
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
        fetchCurrentLocation()
    }
    
    func getCurrentLocation() {
        fetchCurrentLocation()
    }
    
    private func fetchCurrentLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location: CLLocation = locations[locations.count - 1]
        
        self.location = location
    }
}
