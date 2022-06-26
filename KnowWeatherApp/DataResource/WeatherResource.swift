//
//  WeatherResource.swift
//  KnowWeatherApp
//

import Foundation

struct WeatherResource {
    func getCurrentWeather(of city: String, completion: @escaping (Result<CurrentWeather,NetworkError>) -> Void) {
        let httpUtility = HttpUtility()

        let queryItems = [URLQueryItem(name: "q", value: "\(city)"), URLQueryItem(name: "appid", value: "\(Bundle.main.AppID)"), URLQueryItem(name: "units", value: "metric")]
      
        var urlComps = URLComponents(string: "\(ApiEndpoints.currentWeatherBaseUrl)")!
        
        urlComps.queryItems = queryItems
        let requestUrl = urlComps.url!
    
        httpUtility.getApiData(requestUrl: requestUrl, resultType: CurrentWeather.self) { result in
            _ = completion(result)
        }
    }
}
