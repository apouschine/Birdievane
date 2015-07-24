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
            let int_carry = carryField.text.toInt()
            let int_loft = loftField.text.toInt()
            
            let club = Club(name: nameField.text!, carry: int_carry!, loft: int_loft!)
            Bag.sharedInstance.add(club)
        }
    }
}
