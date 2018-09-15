//
//  ViewController.swift
//  Qurba Task
//
//  Created by Admin on 8/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON



class ViewController: UIViewController,CLLocationManagerDelegate {

    var loc :JSON = ""
    var name :String = ""
    var pic :String = ""
    var category :String = ""
    var address :String = ""
    var locationsArray :[JSON] = []
    var names :[String] = []
    var coverPics :[String] = []
    var categories :[String] = []
    var allAddresses :[String] = []
    
    @IBOutlet weak var mapView: MKMapView!
    var locationMgr: CLLocationManager!
    var currentLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    
    
    func determineMyCurrentLocation() {
        locationMgr = CLLocationManager()
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationMgr.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // zoom to user location
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: false)
        
//  stopUpdatingLocation() to stop listening for location updates
         manager.stopUpdatingLocation()
        
                var jwt = ""
       
        
   let parameters: [String : Any] = ["payload":["deviceId":"12467876790"]]
   let parameter: [String : Any] = ["payload":["lng":"\(userLocation.coordinate.longitude)",
                    "lat":"\(userLocation.coordinate.latitude)"
                    ]]
        //this property causes the map view to use the Core Location framework to find the current location
        mapView.showsUserLocation = true
        
     // POST method, request the url and get the jwt value for next request
   Alamofire.request("https://backend-user-alb.qurba-dev.com/auth/login-guest/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        do {
                        if let json = response.data {
                            let data = try JSON(data: json)
        
                             jwt = data["response"]["payload"]["jwt"].stringValue
                        }// end if
                            let headers = [ "Authorization": "jwt \(jwt)"]
                            
   // POST method, request this url and result will be data of all nearby places
   Alamofire.request("https://backend-user-alb.qurba-dev.com/places/places/nearby?page=1", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                                .responseJSON {
                                    response in
                                    do{
                                        if let json = response.data {
                                        let data = try JSON(data: json)
                                            for i in 0 ... 19{
                                                
                                                // get the names, locations , pictures .. from the result
                                                self.loc = data["response"]["payload"][i]["location"]["coordinates"]
                                                self.name = data["response"]["payload"][i]["name"]["en"].stringValue
                                                self.pic = data["response"]["payload"][i]["placeProfileCoverPictureUrl"].stringValue
                                                self.category = data["response"]["payload"][i]["categories"][0]["name"]["en"].stringValue
                                                self.address = data["response"]["payload"][i]["address"]["firstLine"]["en"].stringValue
                                                
                                                // fill the arrayes with data from parsing
                                                self.locationsArray.append(self.loc)
                                                self.names.append(self.name)
                                                self.coverPics.append(self.pic)
                                                self.categories.append(self.category)
                                                self.allAddresses.append(self.address)
                                            } // end for
                                            
                                            // save data in user defaults
                                            let defaults = UserDefaults.standard
                                            defaults.set(self.names, forKey: "names")
                                            defaults.set(self.coverPics, forKey: "pics")
                                            defaults.set(self.categories, forKey: "cats")
                                            defaults.set(self.allAddresses, forKey: "loc")

                         var i = 0
           for location in self.locationsArray {
            
                // add map annotations to all nearby places
               let annotation = MKPointAnnotation()
               annotation.coordinate = CLLocationCoordinate2D(latitude: location[1].double!, longitude: location[0].double! )
            
                // set title to each of them by their name
               annotation.title = self.names[i]
               self.mapView.addAnnotation(annotation)
                     i+=1
                                            } // end for
                                        }// end if
                                    }// end do
                                    catch let err as NSError {
                                        print(err)
                                    }
                            } // end alamofire
                            
                        }// end do
        
                        catch _ as NSError {
                            print("error1")
                        } // end alamofire
        }// end func
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
