//
//  DailyCollectionViewCell.swift
//  KnowWeatherApp
//

import UIKit
import Kingfisher

class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dailyImage: UIImageView!
    @IBOutlet weak var dailyDate: UILabel!
    @IBOutlet weak var dailyMaxTemp: UILabel!
    @IBOutlet weak var dailyMinTemp: UILabel!
    @IBOutlet weak var dailyContainerView: UIView!
    
    func configure(daily: Daily?, indexPath: Int) {
        if daily != nil {
            dailyDate.textColor = .white
            dailyMaxTemp.textColor = .white
            dailyMinTemp.textColor = .white
          
            dailyContainerView.layer.cornerRadius = CGFloat(Constants.CornerRadius2)
            dailyContainerView.layer.masksToBounds = true
            
            dailyContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            if let icon = daily?.weather.first?.icon {
                let iconUrl = URL(string: "\(ApiEndpoints.imageIconBaseURL)\(icon).png")
                dailyImage.kf.setImage(with: iconUrl)
            }

            if let minTemp = daily?.temp.min.doubleToString(), let maxTemp = daily?.temp.max.doubleToString() {
                dailyMinTemp.text = "\(minTemp)°"
                dailyMaxTemp.text = "\(maxTemp)°"
            }
        }
    }
}
