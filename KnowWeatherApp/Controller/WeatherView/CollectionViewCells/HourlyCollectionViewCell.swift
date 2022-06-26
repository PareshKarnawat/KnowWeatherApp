//
//  HourlyCollectionViewCell.swift
//  KnowWeatherApp
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourlyImageVew: UIImageView!
    @IBOutlet weak var hourlyTemp: UILabel!
    @IBOutlet weak var hourlyTime: UILabel!
    
    @IBOutlet weak var hourlyContainerView: UIView!
    
    func configure(hourly: Hourly?, indexPath: Int) {
        if hourly != nil {
            hourlyTemp.textColor = .white
            hourlyTime.textColor = .white
            
            hourlyContainerView.layer.cornerRadius = CGFloat(Constants.CornerRadius3)
            hourlyContainerView.layer.masksToBounds = true
            hourlyContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            if let icon = hourly?.weather.first?.icon {
                let iconUrl = URL(string: "\(ApiEndpoints.imageIconBaseURL)\(icon).png")
                hourlyImageVew.kf.setImage(with: iconUrl)
            }
                        
            if let hourlyTempObj = hourly?.temp.doubleToString(){
                hourlyTemp.text = "\(hourlyTempObj)°"
            }
        }
    }
}
