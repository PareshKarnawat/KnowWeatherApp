//
//  CityTableViewCell.swift
//  KnowWeatherApp
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var citiNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
