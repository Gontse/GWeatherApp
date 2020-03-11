//
//  GWAWeatherProvider.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/08.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation
import CoreLocation
import Swinject


protocol GWAWeatherProviderDelegate: class {
    func didRecieveCurrentWeather(weather: CurrentWeatherModel?)
}

protocol GWAWeatherForcastDelegate: class {
   func didRecieveForcasts(forcast: ForecastWeatherModel?)
}


protocol GWAWeatherProvider: class {}

class GWADefaultWeatherProvider {

   private let APPID = "724609282aebf937ea664af46f37e53a"
   private let BASE_PATH = "http://api.openweathermap.org/data/2.5/"
    
    weak var delegate : GWAWeatherProviderDelegate?
    weak var forecastDelegate: GWAWeatherForcastDelegate?
    
    let locationProvider : GWADefaultLocationProvider
    init(locationProvider : GWADefaultLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}

private extension GWADefaultWeatherProvider {
    
    func getCurrentWeather(coOrdinate: CLLocationCoordinate2D) {
        let url = URL(string: "\(BASE_PATH)weather?lat=\(coOrdinate.latitude)&lon=\(coOrdinate.longitude)&appid=\(APPID)")
        let requestResource = Resource<CurrentWeatherModel>(url: url!)
        ServiceHelper().load(resource: requestResource) { [weak self] (result) in
            switch result{
            case .success(let currentWeather):
                self?.delegate?.didRecieveCurrentWeather(weather: currentWeather)
            case .failure(_): break
            }
        }        
        delegate?.didRecieveCurrentWeather(weather: nil)
        get_Five_daysWeatherForcast(coOrdinate: coOrdinate)
    }
    
    func get_Five_daysWeatherForcast(coOrdinate: CLLocationCoordinate2D)  {
        let url = URL(string: "\(BASE_PATH)forecast?lat=\(coOrdinate.latitude)&lon=\(coOrdinate.longitude)&appid=\(APPID)")
               let requestResource = Resource<ForecastWeatherModel>(url: url!)
               ServiceHelper().load(resource: requestResource) { [weak self] (result) in
                   switch result{
                   case .success(let weatherFocast):
                    print("FORECAST: \(weatherFocast)")
                    self?.forecastDelegate?.didRecieveForcasts(forcast: weatherFocast)
                   case .failure(_): break
                   }
               }
          //Commenet out the code below to get real time updates
            locationProvider.locationManager.stopUpdatingLocation()
           }
    }
    
extension GWADefaultWeatherProvider : GWAWeatherProvider { }

extension GWADefaultWeatherProvider: GWALocationConsumer {
    func consumerLocation(_ location: CLLocation) {
        getCurrentWeather(coOrdinate: location.coordinate)
        
    }
}

class GWAWeatherProviderAssembly : Assembly {
    func assemble(container: Container) {
        container.register(GWADefaultWeatherProvider.self, factory:  { r in
            let locationProvider =  r.resolve(GWADefaultLocationProvider.self)!
            return GWADefaultWeatherProvider(locationProvider: locationProvider)
        }).inObjectScope(.weak)
    }
    
    
}
