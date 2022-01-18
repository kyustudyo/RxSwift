//
//  GoodWeatherViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoodWeatherViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "city name_", attributes: [.foregroundColor : UIColor.systemGray])
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        return textField
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.numberOfLines = 0
        return label
    }()
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
        .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
//        self.cityNameTextField.rx.value//계속 request하면 api 너무 콜 하므로 위에것으로.
//            .subscribe(onNext: { city in
//
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    } else {
//                        self.fetchWeather(by: city)
//                    }
//                }
//
//            }).disposed(by: disposeBag)
        
        
        
    }
    
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(goToBack))
        navigationItem.title = "weather!"

        
        view.addSubview(cityNameTextField)
        view.addSubview(humidityLabel)
        view.addSubview(temperatureLabel)
        
        cityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            cityNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            cityNameTextField.widthAnchor.constraint(equalToConstant: 200),
            cityNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            humidityLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            temperatureLabel.centerXAnchor.constraint(equalTo: humidityLabel.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 30),
            
        ])
    }
    
    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "🙈"
            self.humidityLabel.text = "⦰"
        }
    }
    private func fetchWeather(by city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL.urlForWeatherAPI(city: cityEncoded) else {
                return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
//        URLRequest.load(resource: resource)
//            .observeOn(MainScheduler.instance)//dispatchmain queue 역할. 그거보다 간편.
//            .catchErrorJustReturn(WeatherResult.empty)//error시 0도 보여줌
//            .subscribe(onNext: { result in
//                guard let result = result else {return}
//                let weather = result.main
//                self.displayWeather(weather)
//
//            }).disposed(by: disposeBag)
        
        
        //bind이용
//        let search = URLRequest.load(resource: resource)
//            .observeOn(MainScheduler.instance)//dispatchmain queue 역할. 그거보다 간편.
//            .catchErrorJustReturn(WeatherResult.empty)//error시 0도 보여줌
//        search.map { "\($0?.main.temp) ℉" }
//        .bind(to: self.temperatureLabel.rx.text)
//        .disposed(by: disposeBag)
//        search.map { "\($0?.main.humidity) 💦" }
//        .bind(to: self.humidityLabel.rx.text)
//        .disposed(by: disposeBag)
        
        
        //driver이용
        
//        let search = URLRequest.load(resource: resource)
//            .observeOn(MainScheduler.instance)//dispatchmain queue 역할. 그거보다 간편.
//            .asDriver(onErrorJustReturn: WeatherResult.empty)//driver는 bind 없다. 따라서 drive로.
//
//        search.map { "\($0?.main.temp) ℉" }
//        .drive(self.temperatureLabel.rx.text)
//        .disposed(by: disposeBag)
//
//        search.map { "\($0?.main.humidity) 💦" }
//        .drive(self.humidityLabel.rx.text)
//        .disposed(by: disposeBag)
        
        //error handling
        let search = URLRequest.loadWithErrorHandling(resource: resource)
            .observeOn(MainScheduler.instance)
            .retry(3)//retry
            .catchError{ error in
                print(error)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℉" }
        .drive(self.temperatureLabel.rx.text)
        .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦" }
        .drive(self.humidityLabel.rx.text)
        .disposed(by: disposeBag)
    }
    @objc func goToBack(){
        self.dismiss(animated: true)
    }
}
