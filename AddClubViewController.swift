//
//  AddClubViewController.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import UIKit

class AddClubViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var carryField: UITextField!
    @IBOutlet var loftField: UITextField!
    
    var v0: Double = 0.0
    var club = Club(name: "", carry: 0, loft: 0, v0: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dismissAndSave" {
            let int_carry = Int(carryField.text!)
            let int_loft = Int(loftField.text!)
            
            club = Club(name: nameField.text!, carry: int_carry!, loft: int_loft!, v0: v0)
            Bag.sharedInstance.add(club)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // check if empty
        if identifier == "dismissAndCancel" {
            return true
        }
        
        if identifier == "dismissAndSave" {
        
            if (nameField.text!.isEmpty || carryField.text!.isEmpty || loftField.text!.isEmpty) {
                showError("All Fields Required")
                return false
            }
            
            if (Int(carryField.text!) == nil) {
                showError("Carry must be a number")
                return false
            }
            
            if (Int(loftField.text!) == nil) {
                showError("Loft must be a number")
                return false
            }
        
            if (Int(loftField.text!) > 90) {
                showError("Loft cannot be greater than 90 degrees")
                return false
            }
            
            if (Bag.sharedInstance.count >= 14) {
                showError("Bag already full")
                return false
            }
            
            v0 = club.get_velocity(Int(carryField.text!)!, loft: Int(loftField.text!)!)
            if v0 == -1.0 {
                showError("Simulated ball took over 30 seconds to land, check carry and loft values")
                return false
            }
            
            return true
        }
        
        return true
    }
    
    func showError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
