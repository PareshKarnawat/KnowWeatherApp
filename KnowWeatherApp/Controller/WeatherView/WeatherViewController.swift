//
//  ViewController.swift
//  KnowWeatherApp
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {

    @IBOutlet weak var shadowContainerView: UIView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentFeelingLabel: UILabel!
    @IBOutlet weak var currentMaxTemperatureLabel: UILabel!
    @IBOutlet weak var currentMinTempratureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPressureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var weatherImageContainerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    public var selectedCity = String()
    let currentWeatherVM = CurrentWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlelabel.text = selectedCity
        self.titlelabel.font = UIFont.systemFont(ofSize: 20)
        getWeatherData()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        initialUIUpate()
    }
    
    func bind() {
        self.currentWeatherVM.currentTemperature.bind { [weak self] currentTemperature in
            self?.currentTemperatureLabel.text = currentTemperature
        }
        self.currentWeatherVM.currentHumidity.bind { [weak self] currentHumidity in
            self?.currentHumidityLabel.text = currentHumidity
        }
        self.currentWeatherVM.currentDescription.bind { [weak self] currentDescription in
            self?.currentDescriptionLabel.text = currentDescription
        }
        
        self.currentWeatherVM.currentFeelingWeather.bind { [weak self] currentFeelingWeather in
            self?.currentFeelingLabel.text = currentFeelingWeather
        }
        self.currentWeatherVM.currentImageWeather.bind { [weak self] currentImageWeather in
            self?.weatherImageView.image = currentImageWeather
        }
        self.currentWeatherVM.currentMinWeather.bind { [weak self] currentMinWeather in
            self?.currentMinTempratureLabel.text = currentMinWeather
        }
        self.currentWeatherVM.currentMaxWeather.bind { [weak self] currentMaxWeather in
            self?.currentMaxTemperatureLabel.text = currentMaxWeather
        }
        self.currentWeatherVM.currentWindSpeed.bind { [weak self] currentWindSpeed in
            self?.currentWindSpeedLabel.text = currentWindSpeed
        }
        self.currentWeatherVM.currentTime.bind { [weak self] currentTime in
            self?.currentTimeLabel.text = currentTime
        }
        self.currentWeatherVM.backgroundImageView.bind { [weak self] backgroundImageView in
            self?.backgroundImageView.image = backgroundImageView
        }
        
        self.currentWeatherVM.reloadCollectionView = {
            DispatchQueue.main.async {
                self.dailyCollectionView.isHidden = false
                self.dailyCollectionView.reloadData()
                self.hourlyCollectionView.reloadData()
            }
        }
        self.currentWeatherVM.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "An error occured", message: error?.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func initialUIUpate() {
        // Shadow Container View
        self.shadowContainerView.layer.cornerRadius =  CGFloat(Constants.CornerRadius1)
        
        // Current Weather View
        self.currentWeatherView.layer.cornerRadius = CGFloat(Constants.CornerRadius1)
        self.currentWeatherView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.currentWeatherView.alpha = 0
        
        // Weather ImageView Container View
        self.weatherImageContainerView.layer.cornerRadius = CGFloat(Constants.CornerRadius1 / 2)
        self.weatherImageContainerView.addGradient()
        
        // Animation
        self.weatherViewAnimate()
        
        self.dailyCollectionView.isHidden = true
    }
    
    // Function to get the Current City Weather data
    func getWeatherData(){
        currentWeatherVM.getCurrentWeatherData(of: selectedCity)
    }
    
    // Function to animate views
    private func weatherViewAnimate() {
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.weatherImageContainerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8) {
            self.currentWeatherView.alpha = 1
            self.shadowContainerView.dropShadow()
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse], animations: {
            self.currentWeatherView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            self.currentWeatherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

//MARK: - IBAction Method

extension WeatherViewController {
    @IBAction func backButtonClicked(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - CollectionView Delegate and Datasource

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyCollectionView {
            return currentWeatherVM.numberOfDailyCells
        } else {
            return currentWeatherVM.numberOfHourlyCells
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            
            guard let hourlyCell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.HourlyCollectionViewCellIdentifier, for: indexPath) as? HourlyCollectionViewCell
            else { return UICollectionViewCell()}
            
            return currentWeatherVM.hourlyConfigureCell(cell: hourlyCell, indexPath: indexPath)
            
        } else {
            
            guard let dailyCell = dailyCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.DailyCollectionViewCellIdentifier, for: indexPath) as? DailyCollectionViewCell
            else { return UICollectionViewCell ()}
            
            return currentWeatherVM.dailyConfigureCell(cell: dailyCell, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
