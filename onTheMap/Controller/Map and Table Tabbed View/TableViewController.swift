//
//  ListViewController.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 01/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        tableView.reloadData();
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
    
    
    // MARK: - TableView Functions
    
    // MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.studentLocations.count;
    }
    
    // MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell;
        let name = Locations.studentLocations[indexPath.row].firstName + " " +  Locations.studentLocations[indexPath.row].lastName;
        let url = Locations.studentLocations[indexPath.row].mediaURL;
        
        cell.firstLable.text = name;
        cell.secondLabel.text = url;
        
        return cell;
    }
    // MARK: didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        
        app.open(URL(string: Locations.studentLocations[indexPath.row].mediaURL)!)
        
    }
}

extension TableViewController: NavigationBarDelegate {
    func navigationBarRefreshButtonClicked() {
        tableView.reloadData();
    }
    
    func navigationBarPlusButtonClicked() {
        let vc = storyboard?.instantiateViewController(identifier: "addLocationIdentifier") as! AddLocationViewController;
        
        present(vc, animated: true, completion: nil);
        vc.onDone = handelAddLocationDismission(success:userLocation:);
        
    }
    
    func navigationBarLogOutButtonClicked() {
        UdacityClient.deleteSession{ (success, error) in
            let vc = self.storyboard?.instantiateViewController(identifier: "logInViewController") as! LoginViewController;
            vc.modalPresentationStyle = .fullScreen;
            self.present(vc, animated: true, completion: nil);
        };
    }
    
    func handelAddLocationDismission(success: Bool, userLocation: StudentLocation?) {
        if success {
            let vc2 = self.storyboard?.instantiateViewController(identifier: "mapViewIdentifier") as! ConfirmAddLocationViewController;
            vc2.location = userLocation!;
            print("Befor presention!!");
            print(userLocation!);
            self.present(vc2, animated: true);
            vc2.onDone = handelConfirmAddLocationDismission;
        }
    }
    func handelConfirmAddLocationDismission(){
        tableView.reloadData();
    }
}
