//
//  GWALocationConsumerMock.swift
//  GWeatherAppTests
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
@testable import GWeatherApp
import CoreLocation

class GWALocationConsumerMock: GWALocationConsumer {
    
    var lastLocation : CLLocation?
    func consumerLocation(_ location: CLLocation) {
        lastLocation = location
    }
    
    
}
