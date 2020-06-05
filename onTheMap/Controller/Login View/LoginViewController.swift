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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocations(urlFormat: .order) { (success, error) in }
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        UdacityClient.validateUser(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handelLoginResponse(success:error:))
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!);
    }
    
    func handelLoginResponse(success: Bool, error: Error?){
        if success {
            performSegue(withIdentifier: "goToTabViewController", sender: nil);
        } else {
            showLoginFailure(message: error!.localizedDescription);
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
