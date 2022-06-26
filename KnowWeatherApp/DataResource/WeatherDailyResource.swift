//
//  WeatherDailyResource.swift
//  KnowWeatherApp
//

import Foundation

struct WeatherDailyResource {
    func getDailyWeather(lat:Double,lon:Double, completion: @escaping (Result<DailyWeather,NetworkError>) -> Void)
    {
        let httpUtility = HttpUtility()
        let queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),
                          URLQueryItem(name: "lon", value: "\(lon)"),
                          URLQueryItem(name: "exclude", value: "minutely"),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "appid", value: "\(Bundle.main.AppID)")]
        
        var urlComps = URLComponents(string: "\(ApiEndpoints.dailyWeatherBaseUrl)")!
        urlComps.queryItems = queryItems
        let requestUrl = urlComps.url!
        
        httpUtility.getApiData(requestUrl: requestUrl, resultType: DailyWeather.self) { result in
            _ = completion(result)
        }
    }
}
