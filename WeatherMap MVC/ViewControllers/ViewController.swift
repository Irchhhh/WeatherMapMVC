//
//  ViewController.swift
//  WeatherMap MVC
//
//  Created by Ирина on 10.03.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    lazy var locManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.requestLocation()
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        self.presentSearchAlertController(
            withTitle: "Enter city name", message: nil,
            style: .alert
        ) { city in
            NetworkManager.shared.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.cityLabel.isHidden = false
            
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.temperatureLabel.isHidden = false
            
            self.feelsLikeTemperatureLabel.text = "Feels like \(weather.feelsLikeTemperatureString)°C"
            self.feelsLikeTemperatureLabel.isHidden = false
            
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
            self.weatherIconImageView.isHidden = false
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        NetworkManager.shared.fetchCurrentWeather(
            forRequestType: .coordinate(latitude: latitude, longitude: longitude)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


