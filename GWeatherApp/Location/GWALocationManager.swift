//
//  GWALocationManager.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject


protocol GWALocationManagerDelegate: class {
    func locationManager(_ manager: GWALocationManager, didUpdateLocations locations: [CLLocation])
}

protocol GWALocationManagerAuthorizationDelegate : class {
    func locationManager(_ manager: GWALocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

protocol GWALocationManager: class {
   
    var delegate : GWALocationManagerDelegate? { get set }
    var authorizationDelegate: GWALocationManagerAuthorizationDelegate? { get set }
    var autherizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
}

class GWAPLocationManagerProxy: NSObject {
    
    weak var delegate: GWALocationManagerDelegate?
    weak var authorizationDelegate: GWALocationManagerAuthorizationDelegate?
    
     let locationManager: CLLocationManager
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension GWAPLocationManagerProxy: GWALocationManager {
    
    var autherizationStatus: CLAuthorizationStatus { return CLLocationManager.authorizationStatus() }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        
    }
    func startUpdatingLocation() { locationManager.startUpdatingLocation()
        
    }
    func stopUpdatingLocation()  {
        locationManager.stopUpdatingLocation() }
}

extension GWAPLocationManagerProxy: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationDelegate?.locationManager(self, didChangeAuthorization: status)
    }
}

class GWALocationManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GWALocationManager.self, factory: { r in
            let locationManager = CLLocationManager()
            return GWAPLocationManagerProxy(locationManager: locationManager)
        }).inObjectScope(.weak)
    }
}
