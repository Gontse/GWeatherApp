//
//  MainViewController.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/09.
//  Copyright © 2020 Gontze. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainCurrentWeatherLabel: UILabel!
    @IBOutlet weak var weatherDescrLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet {
            forecastTableView.delegate = self
        }
    }
    
    var weatherVM : CurrentWeatherViewModel?
    var foreCastVM : ForecastViewModel?
    
    var weatherProvider : GWADefaultWeatherProvider!{
        didSet {
            weatherProvider.delegate = self
            weatherProvider.forecastDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension MainViewController {
    func updateUI(){
        DispatchQueue.main.async {
            self.mainCurrentWeatherLabel.text = "\(self.weatherVM?.current_Temp.asCelcius ?? 0)"
            self.weatherDescrLabel.text = self.weatherVM?.WeatherDescription
            self.minTempLabel.text = "\(self.weatherVM?.min_Temp ?? 0)"
            self.maxTempLabel.text = "\(self.weatherVM?.max_Temp ?? 0)"
        }
    }
}

extension MainViewController: GWAWeatherProviderDelegate {
    func didRecieveCurrentWeather(weather: CurrentWeatherModel?) {
        if weather != nil{
            weatherVM = CurrentWeatherViewModel.init(currentWeather: weather!)
            updateUI()
        }
    }
}

extension MainViewController: GWAWeatherForcastDelegate {
    func didRecieveForcasts(forcast: ForecastWeatherModel?) {
      //  foreCastVM =  ForecastViewMode //forcast
    }
}

class MainViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.storyboardInitCompleted(MainViewController.self) { (r, c) in
            c.weatherProvider = r.resolve(GWADefaultWeatherProvider.self)!
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}


extension Double {
    var asCelcius: Double {
        return (self - 273)
    }
}
