//
//  EditClubViewController.swift
//  Birdievane
//
//  Created by Alex Pouschine on 8/3/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import UIKit

class EditClubViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var carryField: UITextField!
    @IBOutlet var loftField: UITextField!
    
    var index : Int?
    var new_club = Club(name: "", carry: 0, loft: 0, v0: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let sender = Bag.sharedInstance.clubs[index!]
        nameField.text = sender.name
        carryField.text = String(sender.carry)
        loftField.text = String(sender.loft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dismissAndUpdate" {
            let int_carry = carryField.text.toInt()
            let int_loft = loftField.text.toInt()
            var v0 = new_club.get_velocity(int_carry!, loft: int_loft!)
            new_club = Club(name: nameField.text!, carry: int_carry!, loft: int_loft!, v0: v0)
            Bag.sharedInstance.updateAtIndex(new_club, atIndex: index!)
        }
    }
    
}
