//
//  CityListViewModel.swift
//  KnowWeatherApp
//


import Foundation
import UIKit
import Kingfisher
import AVFoundation

class CurrentWeatherViewModel {

    var reloadCollectionView: (()->())?
    var onErrorHandling : ((NetworkError?) -> Void)?
    var dailyCollectionView = Bindable<DailyWeather?>(nil)
    var dailyWeather : DailyWeather? = nil
    var timeZone : Int?
    
    var currentPressure = Bindable<String?>(nil)
    var currentHumidity = Bindable<String?>(nil)
    var currentDescription =  Bindable<String?>(nil)
    var currentTemperature = Bindable<String?>(nil)
    var currentFeelingWeather = Bindable<String?>(nil)
    var currentImageWeather = Bindable<UIImage?>(nil)
    var currentMinWeather = Bindable<String?>(nil)
    var currentMaxWeather = Bindable<String?>(nil)
    var currentWindSpeed = Bindable<String?>(nil)
    var currentTime = Bindable<String?>(nil)
    var backgroundImageView = Bindable<UIImage?>(nil)
    
    //MARK: - Collection View Number of Rows Methods
    
    var numberOfDailyCells: Int {
        return dailyWeather?.daily.count ?? 0
    }
    
    var numberOfHourlyCells: Int {
        return dailyWeather?.hourly.count ?? 0
    }
    
    //MARK: - Get Current City Weather Data
    func getCurrentWeatherData(of city:String) 
    {
        let weatherResource = WeatherResource()
        weatherResource.getCurrentWeather(of: city) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                self?.updateUI(currentWeather)
            case .failure(let error):
                self?.onErrorHandling?(error)
            }
        }
    }
    
    //MARK: - Get Daily weather data using City Lat, long
    func getDailyWeather(lat: Double, lon:Double, completion: @escaping (_ result: DailyWeather?) -> Void) {
        
        let weatherDailyResource = WeatherDailyResource()
        
        weatherDailyResource.getDailyWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let dailyWeather):
                completion(dailyWeather)
            case .failure(let error):
                self?.onErrorHandling?(error)
            }
        }
    }
    
    //MARK: - Update UI for the Daily and Hourly Collection Cells
    
    func updateUI(_ currentWeather: CurrentWeather?) {
        DispatchQueue.main.async {
            if let curTemp = currentWeather?.main?.temp?.doubleToString() {
                self.currentTemperature.value = "\(curTemp)°"
            }
            if let curFeeling = currentWeather?.main?.feels_like?.doubleToString() {
                self.currentFeelingWeather.value = "\(curFeeling)°"
            }
            if let curMaxTemp = currentWeather?.main?.temp_max?.doubleToString() {
                self.currentMaxWeather.value = "\(curMaxTemp)°"
            }
            if let curMinTemp = currentWeather?.main?.temp_min?.doubleToString() {
                self.currentMinWeather.value = "\(curMinTemp)°"
            }
            if let curHumidity = currentWeather?.main?.humidity?.doubleToString() {
                self.currentHumidity.value = "\(curHumidity)%"
            }
            if let windSpeed = currentWeather?.wind?.speed {
                self.currentWindSpeed.value = "\(windSpeed)м/с"
            }
            if let curPressure = currentWeather?.main?.pressure {
                self.currentPressure.value = "\(curPressure)мм"
            }
            if let date = currentWeather?.dt, let timeZone = currentWeather?.timezone {
                let curTime = self.dateFormater(date: date, timeZone: timeZone,dateFormat: Constants.DateFormatForHourMinDay)
                self.currentTime.value = curTime
            }
            if let curDescription = currentWeather?.weather?.first?.description?.capitalizingFirstLetter() {
                self.currentDescription.value = curDescription
            }
            if let curWeatherIcon = currentWeather?.weather?.first!.icon {
                let iconUrl = URL(string: "\(ApiEndpoints.imageIconBaseURL)\(curWeatherIcon)@2x.png")
                let resource = ImageResource(downloadURL: iconUrl!)
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let iconImage):
                        self.currentImageWeather.value = iconImage.image
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                self.backgroundImageView.value = UIImage(named: "\(curWeatherIcon)-2")
            }
            if let lat = currentWeather?.coord?.lat, let lon = currentWeather?.coord?.lon {
                self.timeZone = currentWeather?.timezone
                self.getDailyWeatherBy(lat, lon)
            }
        }
    }
    
    fileprivate func dateFormater(date: TimeInterval?, timeZone: Int, dateFormat: String) -> String? {
        if date != nil {
            let dateText = Date(timeIntervalSince1970: date!)
            let formater = DateFormatter()
            formater.timeZone = TimeZone(secondsFromGMT: timeZone)
            formater.dateFormat = dateFormat
            return formater.string(from: dateText)
        }
        return ""
    }
}

//MARK: - Get Daily Weather Details

extension CurrentWeatherViewModel {
    func getDailyWeatherBy(_ lat: Double, _ lon: Double) {
        getDailyWeather(lat: lat, lon: lon) { [weak self] result in
            self?.dailyWeather = result
            self?.reloadCollectionView?()
        }
    }
}

//MARK: - Collection View Cell Configuration Methods

extension CurrentWeatherViewModel {
    //MARK: - Collection View Daily Cell configuration
    func dailyConfigureCell (cell: DailyCollectionViewCell, indexPath: IndexPath) -> DailyCollectionViewCell {
        cell.configure(daily: dailyWeather?.daily[indexPath.row], indexPath: indexPath.row)
        cell.dailyDate.text = dateFormater(date: (dailyWeather?.daily[indexPath.row].dt) , timeZone: timeZone ?? 0, dateFormat: Constants.DateFormatForDayDateMonth)
        return cell
    }
    
    //MARK: - Collection View Hourly Cell configuration
    func hourlyConfigureCell (cell: HourlyCollectionViewCell, indexPath: IndexPath) -> HourlyCollectionViewCell {
        cell.configure(hourly: dailyWeather?.hourly[indexPath.row], indexPath: indexPath.row)
        cell.hourlyTime.text = dateFormater(date: (dailyWeather?.hourly[indexPath.row].dt), timeZone: timeZone ?? 0,dateFormat: Constants.DateFormatForHourMin)
        return cell
    }
}
