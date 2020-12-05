//
//  SearchViewController.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation
import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchB: UISearchBar!
    @IBOutlet weak var businessesTableView: UITableView!
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    var messageLabel: UILabel!
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMessage("Type a business name to display results")
        determineMyCurrentLocation()
        self.title = "Business Search"
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        businessesTableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "businessCell")
        businessesTableView.separatorStyle = .none
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if currentLocation == nil {
            checkLocationServices()
        }
        else {
            let fetch = APIRequests()
            fetch.getBusinesses(searchTerm:searchB.text ?? "", latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, limit: 50, sortBy: "distance", radius: customRadius){ (response, error) in
                if let response = response {
                    self.businesses = response.sorted(by: { $0.distance < $1.distance })
                    DispatchQueue.main.async {
                        if self.businesses.count == 0 {
                            self.messageLabel.text = "No Results. Try Again"
                        }
                        else {
                            self.messageLabel.text = ""
                        }
                        self.businessesTableView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.messageLabel.text = "An error occured. Please try Again"
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.businesses.removeAll()
            self.businessesTableView.reloadData()
        }
    }
    
    func showMessage (_ message : String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.businessesTableView.backgroundView = messageLabel
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        currentLocation = userLocation
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {

      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        determineMyCurrentLocation()
      case .denied:
        break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .restricted:
        break
      case .authorizedAlways:
        break
      }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        cell.nameLabel.text = businesses[indexPath.row].name
        cell.distanceLabel.text = String(format: "%.2f mi",businesses[indexPath.row].distance/1609.344)
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedBusiness = businesses[indexPath.row]
            if let viewController = storyboard?.instantiateViewController(identifier: "bizDetailVC") as? BusinessDetailViewController {
                viewController.selectedBusiness = selectedBusiness
                navigationController?.pushViewController(viewController, animated: true)
            }
    }
}


