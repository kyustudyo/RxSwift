//
//  URLRequest+Extension.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/16.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}
enum requestError: Error {
    case notResponse(String)
    case notDecode(String)
}
extension URLRequest {
    static func load<T>(resource: Resource<T>) -> Observable<T?> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T? in
                return try? JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
    
    static func loadWithErrorHandling<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }.map { (response, data) -> T in
                if 200..<300 ~= response.statusCode {
                    if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                        return decoded
                    }
                    else {throw requestError.notDecode("can not decode")}
                    
                } else {
                    throw requestError.notResponse("can not respond")
//                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
        
    }
    
}

