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
    
    @IBOutlet weak var mainCurrentWeatherLabel: UILabel!{
        didSet{
            mainCurrentWeatherLabel.text = "__"
        }
    }
    @IBOutlet weak var weatherDescrLabel: UILabel!{
        didSet{
            weatherDescrLabel.text = ""
        }
    }
    
    @IBOutlet weak var weatherSectionView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet{
            forecastTableView.separatorStyle = .none
            forecastTableView.delegate = self
            forecastTableView.dataSource = self
            
        }
    }
    
    var weatherVM : CurrentWeatherViewModel?
    var foreCastVMList = [ForecastViewModel]()
    
    var weatherProvider : GWADefaultWeatherProvider!{
        didSet {
            weatherProvider.delegate = self
            weatherProvider.forecastDelegate = self
        }
    }
}

private extension MainViewController {
    func updateUI(){
        DispatchQueue.main.async {
            self.mainCurrentWeatherLabel.text = "\(Int(self.weatherVM?.current_Temp.asCelcius ?? 0))"
            self.weatherDescrLabel.text = self.weatherVM?.WeatherDescription
            self.minTempLabel.text = "\(Int(self.weatherVM?.min_Temp.asCelcius ?? 0))º"
            self.maxTempLabel.text = "\(Int(self.weatherVM?.max_Temp.asCelcius ?? 0))º"
            self.currentTempLabel.text = self.mainCurrentWeatherLabel.text!+"º"
            self.setWeatherTheme(description: self.mainCurrentWeatherLabel.text!)
        }
    }
    
     func setWeatherTheme(description: String){
            if(description.contains("cloud")){
                cloudyTheme()
            }else if ( description.contains("rain")){
                rainnyTheme()
            }else{
                sunnyTheme()
            }
        }
        
        
    func rainnyTheme(){
        UIView.animate(withDuration: 0.3) {
            self.weatherImageView.image = UIImage(named:"forest_rainy")
            let primaryColor: UIColor = UIColor(named: "RAINY") ?? UIColor(rgb: 0x57575D)
            self.forecastTableView.backgroundColor = primaryColor
            self.weatherSectionView.backgroundColor = primaryColor
        }
    }
    
    func sunnyTheme(){
        UIView.animate(withDuration: 0.3) {
            self.weatherImageView.image = UIImage(named: "forest_sunny" )
            let primaryColor: UIColor = UIColor(named: "SUNNY") ?? UIColor(rgb: 0x47AB2F)
            self.forecastTableView.backgroundColor = primaryColor
            self.weatherSectionView.backgroundColor = primaryColor
        }
    }
    
    func cloudyTheme() {
        UIView.animate(withDuration: 0.3) {
            self.weatherImageView.image = UIImage(named: "forest_cloudy")
            let primaryColor: UIColor = UIColor(named: "CLOUDY") ?? UIColor(rgb: 0x54717A)
            self.forecastTableView.backgroundColor = primaryColor
            self.weatherSectionView.backgroundColor = primaryColor
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
        
        ///let allDates = forcast?.list!.map({ $0.dtTxt})
        
        let forecastList = (forcast?.list)!
        
        for f in forecastList where (f.dtTxt?.contains("00:00:00"))! {
            for w in f.weather! {
                foreCastVMList.append(ForecastViewModel(dayOfWeek: f.dtTxt?.asDayOfWeek, description: w.weatherDescription, temperature: f.main?.temp ))
            }
        }
        
        DispatchQueue.main.async {
            self.forecastTableView.reloadData()
        }
    }
}

class MainViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.storyboardInitCompleted(MainViewController.self) { (r, c) in
            c.weatherProvider = r.resolve(GWADefaultWeatherProvider.self)!
        }
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foreCastVMList.count == 0  {
            return 0
        }else{
             return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ForecastTableViewCell
        cell.forcast = foreCastVMList[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
}

extension Double {
    var asCelcius: Double {
        let currentValue = Double(Int(self - 273))
        return currentValue
    }
}

extension String {
    var asDayOfWeek: String? {
                
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
       let containedString = self
        dateFormatter.dateFormat = dateFormat
        let startDate = dateFormatter.date(from: containedString)
        print("Current date is \(String(describing: startDate))")

        let dateFormatter2 = DateFormatter()

        dateFormatter2.dateFormat = "EEEE, MMM d, yyyy"
        let currentDateString: String = dateFormatter2.string(from: startDate!)
        let dayOfWeek = currentDateString.components(separatedBy: ",").first

        return dayOfWeek
        
      
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
