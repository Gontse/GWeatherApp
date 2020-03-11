//
//  GWALocationProvider.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject

protocol GWALocationConsumer: class {
    func consumerLocation(_ location: CLLocation)
}
protocol GWALocationProvider {
    func add(_ consumer: GWALocationConsumer)
}

class GWADefaultLocationProvider {
    let locationManager: GWALocationManager
    let locationAuthorization: GWALocationAuthorization
    
    var locationConsumers = [GWALocationConsumer]()
    init(locationManager: GWALocationManager, locationAuthorization: GWALocationAuthorization) {
        self.locationManager = locationManager
        self.locationAuthorization = locationAuthorization
        locationManager.delegate = self
    }
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension GWADefaultLocationProvider : GWALocationProvider {
    func add(_ consumer: GWALocationConsumer) {
        locationConsumers.append(consumer)
    }
}

extension GWADefaultLocationProvider: GWALocationManagerDelegate {
    func locationManager(_ manager: GWALocationManager, didUpdateLocations locations: [CLLocation]) {
        let sortedLocations = locations.sorted { (lhs, rhs) -> Bool in
            return lhs.timestamp.compare(rhs.timestamp) == .orderedDescending
        }
        guard let location = sortedLocations.first else { return }
        for consumer in locationConsumers {
            consumer.consumerLocation(location)
        }
    }
}

class GWALocationProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GWADefaultLocationProvider.self, factory:  { r in
            let locationManager = r.resolve(GWALocationManager.self)!
            let LocationAuthorization = r.resolve(GWADefaultLocationAuthorization.self)!
            
            return GWADefaultLocationProvider(locationManager: locationManager, locationAuthorization: LocationAuthorization)
        }).inObjectScope(.weak)
    }
}



