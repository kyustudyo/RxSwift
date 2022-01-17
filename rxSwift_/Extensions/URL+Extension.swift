//
//  URL+Extension.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=aa5b5932aa2a5865ebd946e12b1b26a7&units=imperial")
    }
    
}
