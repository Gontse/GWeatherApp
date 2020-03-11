//
//  GWALocationAuthorizationTests.swift
//  GWeatherAppTests
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import XCTest
@testable import GWeatherApp

class GWALocationAuthorizationTests: XCTestCase {

    var sut: GWALocationAuthorization!
    
      var locationManagerMock: GWALocationManagerMock
    var delegateMock : GWALocationAuthorizationDelegateMock
    

    override func setUp() {
        
        locationManagerMock = GWALocationManagerMock
        delegateMock = GWALocationAuthorizationDelegateMock
        sut = GWADefaultLocationAuthorization(locationManager: locationManagerMock)
        sut.delegate = delegateMock
    }
    
    func test_CheckAutherization_notDeterminedRequestAuthorization(){
        
    }
    
    func test_CheckAutherization_determined_doesNotRequestAuthorization(){
           
       }
    
    func test_DidChangeAuthorizationStatus_authorizeWhenInUse_notificationIsPosted(){
        
    }
    
}
