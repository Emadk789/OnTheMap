//
//  ViewController.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 31/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocations(urlFormat: .limitAndOrder(100)) { (success, error) in }
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        activityIndicator.isHidden = false;
        activityIndicator.startAnimating();
        UdacityClient.validateUser(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handelLoginResponse(success:error:))
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!);
    }
    
    func handelLoginResponse(success: Bool, error: Error?){
        activityIndicator.stopAnimating();
        if success {
            performSegue(withIdentifier: "goToTabViewController", sender: nil);
        } else {
            showFailureAlert(message: error!.localizedDescription);
        }
    }
    
}

