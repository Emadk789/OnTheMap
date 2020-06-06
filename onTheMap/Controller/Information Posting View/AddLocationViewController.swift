//
//  AddLocationViewController.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 03/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit;
import MapKit;

class AddLocationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var userLocation: StudentLocation? = nil;
    
    var onDone: ((Bool, StudentLocation?) -> Void)?
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    // TODO :- Make the ConfirmVC get the userLocation
    @IBAction func findLocationButtonClicked(_ sender: Any) {
        
        findLocation();
    }
    func findLocation(){
        if urlTextField.text == "" || nameTextField.text == "" {
            let error: String = "You must both location and url";
            showLoginFailure(message: error);
            return;
        }
        else {
            getLocation(forPlaceCalled: nameTextField.text ?? "") { (fullLocationName, location) in
                guard let location = location else {
                    let error: String = "The location that you are looking for does not exist! sorry";
                    self.showLoginFailure(message: error);
                    return;
                }
                // I am just filling the first name to be the city name, because I could not retrieve the student public information using https://onthemap-api.udacity.com/v1/users/<userId>
                self.userLocation = StudentLocation(createdAt: "", firstName: fullLocationName!, lastName: "", latitude: location.coordinate.latitude as Double, longitude: location.coordinate.longitude as Double, mapString: fullLocationName!, mediaURL: self.urlTextField.text ?? "", objectId: "", uniqueKey: "", updatedAt: "");
                
                Locations.studentLocations.append(self.userLocation!);
                
                self.dismiss(animated: false) {
                    self.onDone!(true, self.userLocation);
                }
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmVC" {
            let vc = segue.destination as! ConfirmAddLocationViewController;
            vc.location = userLocation!;
        }
    }
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
// MARK: - Get Location
extension AddLocationViewController {
    
    
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(String?, CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil, nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil, nil)
                return
            }
            print("This is the placemark \(placemark.name) and \(placemark.country)");
            let fullLocationName = placemark.name! + ", " + placemark.country!;
            
            completion(fullLocationName, location)
        }
    }
}
