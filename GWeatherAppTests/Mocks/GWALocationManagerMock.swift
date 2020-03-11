//
//  GWALocationManagerMock.swift
//  GWeatherAppTests
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
@testable import GWeatherApp
import CoreLocation

class GWALocationManagerMock: GWALocationManager {
    
    weak var delegate: GWALocationManagerDelegate?
    weak var authorizationDelegate: GWALocationManagerAuthorizationDelegate?
    
    var requestWhenInUseAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLOcation = false
    
    func requestWhenInUseAuthorization () {
        requestWhenInUseAuthorization = true
    }
    
    func didStartUpdatingLocation () {
        didStartUpdatingLocation = true
    }
    
    func didStopUpdatingLOcation () {
        didStopUpdatingLOcation = true
    }
}
