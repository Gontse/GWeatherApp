//
//  GWALocationAuthorization.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
import CoreLocation
import  Swinject


extension NSNotification.Name {
    static let GWALocationAuthorized = NSNotification.Name(rawValue: "NSNotification.Name.GWALocationAuthorized")
}

protocol GWALocationAuthorizationDelegate: class {
    func authorizationDenied(for locationAuthorization: GWADefaultLocationAuthorization)
}

protocol GWALocationAuthorization: class {
    var delegate: GWALocationAuthorizationDelegate? { get set }
    func checkAuhorization()
}

class GWADefaultLocationAuthorization {
    var delegate: GWALocationAuthorizationDelegate?
    
    let locationManager: GWALocationManager
    init(locationManager: GWALocationManager) {
        self.locationManager = locationManager
        locationManager.authorizationDelegate = self
    }
}
extension GWADefaultLocationAuthorization : GWALocationAuthorization {
    func checkAuhorization() {
        switch locationManager.autherizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension GWADefaultLocationAuthorization: GWALocationManagerAuthorizationDelegate {
    func locationManager(_ manager: GWALocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            NotificationCenter.default.post(name: .GWALocationAuthorized, object: self)
        case .denied, .restricted:
            delegate?.authorizationDenied(for: self)
        default:
            break
        }
    }
}

class GWALocationAuthorizationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GWADefaultLocationAuthorization.self, factory:  { r in
            let locationManager = r.resolve(GWALocationManager.self)!
            return  GWADefaultLocationAuthorization(locationManager: locationManager)
        }).inObjectScope(.weak)
    }
    
    
}
