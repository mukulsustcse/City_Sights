//
//  ContentModel.swift
//  City_Sights
//
//  Created by M. A. Alim Mukul on 20.09.22.
//

import Foundation
import CoreLocation

class ContentModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    override init() {
        
        // init method of NSObject
        
        super.init()
        
        // set content model as the delegate of the location manager
        locationManager.delegate = self
        
        // request authorisation / permission from the user
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    // MARK: Location manager delegate methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            
            // we have permission
            
            // Start geo-locating the user, after getting the permission
            
            locationManager.startUpdatingLocation()
            
        }
        else if  locationManager.authorizationStatus == .denied {
            
            // we don't have permission
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // gives us the location of the user
        let userLocation = locations.first
        
        if userLocation != nil {
            
            // we have a location
            
            locationManager.stopUpdatingLocation()
            
            // to do : if we have the coordinates of the user, send into Yelp API
            
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            
            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
            
        }
        
        //        print(locations.first ?? "No location")
        
        // stop requesting the location after we get it once
    }
    
    func getBusinesses(category:String, location:CLLocation) {
        
        // create url
        
        /*
         let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
         let url = URL(string: urlString)
         */
        
        var urlComponents = URLComponents(string: Constants.apiURL)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        
        let url = urlComponents?.url
        
        if let url = url {
            
            // create url request
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            
            // create urlsession
            
            let session = URLSession.shared
            
            // create data task
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                // check that there isn't an error
                
                if error == nil {
                    
                    //                    print(response)
                    
                    // parse json
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        DispatchQueue.main.async {
                            
                            // assign results to the appropriate property
                            
                            /*if category == Constants.sightsKey {
                                
                                self.sights = result.businesses
                            }
                            else if category == Constants.restaurantsKey {
                                
                                self.restaurants = result.businesses
                            }*/
                            
                            switch category {
                                
                            case Constants.sightsKey:
                                self.sights = result.businesses
                                
                            case Constants.restaurantsKey:
                                self.restaurants = result.businesses
                                
                            default:
                                break
                            }
                        }
                        
                        
                        
                    } catch {
                        print(error)
                    }
                    
                }
            }
            
            // start the data task
            
            dataTask.resume()
        }
    }
}
