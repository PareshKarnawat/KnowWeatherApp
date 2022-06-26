//
//  Common.swift
//  KnowWeatherApp
//

import Foundation

struct ApiEndpoints
{
    static let currentWeatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let dailyWeatherBaseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    static let imageIconBaseURL = "http://openweathermap.org/img/wn/"
}

extension Bundle {
    var AppID: String {
        return object(forInfoDictionaryKey: "AppID") as? String ?? ""
    }
}
