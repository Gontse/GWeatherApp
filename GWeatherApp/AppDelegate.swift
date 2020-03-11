//
//  AppDelegate.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import UIKit
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    let mainAssembler = MainAssembler()
    let locationAuthorization : GWADefaultLocationAuthorization
    
    override init() {
        locationAuthorization = mainAssembler.resolver.resolve(GWADefaultLocationAuthorization.self)!
        super.init()
        locationAuthorization.delegate = self
    }
}

private extension AppDelegate {
    func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil)
        self.window = window
        
        window.backgroundColor = .yellow
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
}

extension AppDelegate: GWALocationAuthorizationDelegate {
    func authorizationDenied(for locationAuthorization: GWADefaultLocationAuthorization) {
        print("Access Denied")
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        locationAuthorization.checkAuhorization()
        
        setupWindow()
        return true
    }
}
