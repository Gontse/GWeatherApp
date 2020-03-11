//
//  GWALocationProviderMock.swift
//  GWeatherAppTests
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
@testable import GWeatherApp
import CoreLocation


class GWALocationProviderMock : GWALocationProvider  {
    var lastConsumer : GWALocationConsumer?
    
    func add(_ consumer: GWALocationConsumber) {
        lastConsumer = consumer
    }
}
