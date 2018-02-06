//
//  ViewController.swift
//  Tap
//
//  Created by Suyash Shetty on 2/2/18.
//  Copyright © 2018 Suyash Shetty. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    let marker = GMSMarker();
    var zoomLevel: Float = 18.0
    @IBOutlet var sourceLocation: LocationEntryButton!
    @IBOutlet var destinationLocation: LocationEntryButton!
    @IBOutlet var requestRideButton: UIButton!
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    var sourceModified: Bool = false;
    var selectedSource: String?
    var selectedDestination: String?
    var tag = -1;
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        marker.position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        marker.title = "Your Location"
        marker.isDraggable = true
        marker.map = mapView
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView);
        
        sourceLocation.isHidden = true;
        destinationLocation.isHidden = true;
        requestRideButton.isHidden = true;
        requestRideButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self;
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        getCurrentPlace(coordinate: marker.position);
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.marker.position = coordinate;
        getCurrentPlace(coordinate: coordinate);
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        sourceLocation.isHidden = false;
        destinationLocation.isHidden = false;
        requestRideButton.isHidden = false;
    }
    
    func getCurrentPlace(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder();
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if error == nil {
                let currentLocation = response?.firstResult()?.lines![0];
                self.sourceLocation.setTitle(currentLocation ?? "Set Pick Up Location", for: .normal);
                self.sourceLocation.titleLabel?.sizeToFit();
            }
        }
    }
    
    @IBAction func getPickUpLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        self.tag = 0;
        autocompleteController.delegate = self
        present(autocompleteController, animated: true);
    }
        
    @IBAction func getDropOffLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        self.tag = 1;
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func requestRide(_ sender: Any) {
        var start: [String:Double] = ["lat":0.0,"long":0.0] {
            didSet {
            }
        }
        var end: [String:Double] = ["lat":0.0,"long":0.0] {
            didSet {                
            }
        }
        
        if(self.selectedDestination != nil) {
            start["lat"] = self.marker.position.latitude;
            start["long"] = self.marker.position.longitude;
            let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=" + (self.selectedDestination?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)! + "&key=" + API_KEY;
            
            Alamofire.request(requestUrl).responseJSON { response in
                if let json = response.result.value as? [String:Any] {
                    let results = json["results"]
                    let result = results as! Array<Dictionary<String,Any>>;
                    let geometry = result[0]["geometry"] as! Dictionary<String, Any>
                    let location = geometry["location"] as! Dictionary<String, Double>
                    end["lat"] = location["lat"]!
                    end["long"] = location["lng"]!
                }
            }
        }
    }
    
    // Prepare the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// Delegates to handle events for the location manager.
extension ViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        self.marker.position.latitude = location.coordinate.latitude
        self.marker.position.longitude = location.coordinate.longitude
        getCurrentPlace(coordinate: location.coordinate)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        if(self.tag == 0) {
            self.sourceLocation.setTitle(prediction.attributedPrimaryText.string, for: .normal);
            self.selectedSource = prediction.attributedFullText.string;
            self.sourceModified = true;
            
            let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=" + (self.selectedSource?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)! + "&key=" + API_KEY;
            
            Alamofire.request(requestUrl).responseJSON { response in
                if let json = response.result.value as? [String:Any] {
                    let results = json["results"]
                    let result = results as! Array<Dictionary<String,Any>>;
                    let geometry = result[0]["geometry"] as! Dictionary<String, Any>
                    let location = geometry["location"] as! Dictionary<String, Double>
                    self.marker.position.latitude = location["lat"]!
                    self.marker.position.longitude = location["lng"]!
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: location["lat"]!,
                                                                  longitude: location["lng"]!,
                                                                  zoom: self.zoomLevel)
                }
            }
        } else {
            self.destinationLocation.setTitle(prediction.attributedPrimaryText.string, for: .normal);
            self.selectedDestination = prediction.attributedFullText.string;
        }
        return true;
    }
}
