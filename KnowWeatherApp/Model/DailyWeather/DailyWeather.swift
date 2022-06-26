//
//  DailyWeather.swift
//  KnowWeatherApp
//

import Foundation

class DailyWeather: Codable {
    let lat,lon: Double
    let hourly: [Hourly]
    let daily: [Daily]
    let current: Hourly
}


class Daily: Codable {
    let dt: TimeInterval
    let weather: [WeatherIcon]
    let temp: Temp
}

class Hourly: Codable {
    let dt: TimeInterval
    let weather: [WeatherIcon]
    let temp: Double
}

class WeatherIcon: Codable {
    let icon: String
}

class Temp: Codable {
    let min: Double
    let max: Double
}
