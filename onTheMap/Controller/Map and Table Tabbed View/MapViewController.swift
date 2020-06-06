//
//  mapViewController.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 01/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        updateMapView();
    }
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        navigationBarLogOutButtonClicked();
        
    }
    @IBAction func refreshButtonClicked(_ sender: Any) {
        navigationBarRefreshButtonClicked();
    }
    @IBAction func plusButtonClicked(_ sender: Any) {
        navigationBarPlusButtonClicked();
    }
    func updateMapView(){
        
        if annotations.isEmpty {
            addAnnotations();
        }
        else {
            self.mapView.removeAnnotations(annotations);
            addAnnotations();
        }
    }
    func addAnnotations(){
        let locations = Locations.studentLocations;
        for dictionary in locations {
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        self.mapView.addAnnotations(annotations)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}

extension MapViewController: NavigationBarDelegate {
    func navigationBarRefreshButtonClicked() {
        updateMapView();
    }
    
    func navigationBarPlusButtonClicked() {
        let viewController = storyboard?.instantiateViewController(identifier: "addLocationIdentifier") as! AddLocationViewController;
        
        present(viewController, animated: true, completion: nil);
        viewController.onDone = handelAddLocationDismission(success:userLocation:);
        
    }
    
    func navigationBarLogOutButtonClicked() {
        UdacityClient.deleteSession{ (success, error) in
            let viewController = self.storyboard?.instantiateViewController(identifier: "logInViewController") as! LoginViewController;
            viewController.modalPresentationStyle = .fullScreen;
            self.present(viewController, animated: true, completion: nil);
        };
    }
    
    func handelAddLocationDismission(success: Bool, userLocation: StudentLocation?) {
        if success {
            let viewController = self.storyboard?.instantiateViewController(identifier: "mapViewIdentifier") as! ConfirmAddLocationViewController;
            viewController.location = userLocation!;
            print("Befor presention!!");
            print(userLocation!);
            self.present(viewController, animated: true);
            viewController.onDone = handelConfirmAddLocationDismission;
        }
    }
    func handelConfirmAddLocationDismission(){
        updateMapView();
    }
}
