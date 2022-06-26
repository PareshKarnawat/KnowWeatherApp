//
//  HttpUtility.swift
//  KnowWeatherApp
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}

struct HttpUtility
{
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T,NetworkError>)-> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            
            guard let data = responseData, error == nil else {
                completionHandler(.failure(.serverError))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(.decodingError))
            }
        }.resume()
    }
}
