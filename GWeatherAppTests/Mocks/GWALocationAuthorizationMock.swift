//
//  GWALocationAuthorizationMock.swift
//  GWeatherAppTests
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
@testable import GWeatherApp
import CoreLocation


class GWALocationAuthorizationMock: GWALocationAuthorization {
    weak var delegate: GWALocationAuthorizationDelegate?
    
    var didCheckAuthorization = false
    
    func checkAuthorization() {
        didCheckAuthorization = true
    }
    
    
}
