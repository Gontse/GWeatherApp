//
//  CurrentWeatherViewModel.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import Foundation

struct CurrentWeatherViewModel {
    let currentWeather : CurrentWeatherModel
}

extension CurrentWeatherViewModel {
    
    var WeatherDescription : String {
        return (currentWeather.weather?.first?.main)!
    }
    
    var current_Temp : Double {
        return (currentWeather.main?.temp)!
    }
    
    var min_Temp : Double {
        return (currentWeather.main?.tempMin) ?? 0
    }
    
    var max_Temp : Double {
        return (currentWeather.main?.tempMax) ?? 0
    }
}
