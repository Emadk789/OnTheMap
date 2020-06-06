//
//  ConfirmAddLocationViewController.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 03/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit;
import MapKit;

class ConfirmAddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: StudentLocation? = nil;
    
    var onDone: (() -> Void)?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        var annotations = [MKPointAnnotation]()

        guard let location = location else {
            return
        }
        
        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = location.firstName
        let last = location.lastName
        let mediaURL = location.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        annotations.append(annotation)

        self.mapView.addAnnotations(annotations)
        
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        UdacityClient.postStudentLocation(studentLocation: self.location!) { (success, error) in
            if success {
                self.dismiss(animated: true) {
                    self.onDone!();
                }
            } else {
                self.showFailureAlert(message: error!.localizedDescription);
            }
        }
    }
    
    
}
extension ConfirmAddLocationViewController: MKMapViewDelegate {
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

