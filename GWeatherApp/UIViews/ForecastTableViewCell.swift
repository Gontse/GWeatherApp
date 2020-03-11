//
//  ForecastTableViewCell.swift
//  GWeatherApp
//
//  Created by Gontze on 2020/03/10.
//  Copyright © 2020 Gontze. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var descripIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var forcast : ForecastViewModel! {
        didSet{
            dayOfWeekLabel.text = forcast.dayOfWeek
            descripIcon.image = UIImage(named: "\(forcast.description?.localizedImageDesscription ?? "clear")")
            temperatureLabel.text = "\(Int(forcast.temperature?.asCelcius ?? 0))º"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension String {
    var localizedImageDesscription: String? {

              if(self.contains("cloud")){
                 return "partlysunny"
              }else if ( self.contains("rain")){
                 return "rain"
              }else{
                  return "clear"
              }
          }
}


