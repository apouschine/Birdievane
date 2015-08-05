//
//  BagViewController.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import UIKit

class BagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bagTableView: UITableView!
    var activeIndex: Int?
    
    //var editViewController: EditClubViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.bagTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClubCellBag")
        
        let addClubButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addClubPressed")
        self.navigationItem.rightBarButtonItem = addClubButton
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.bagTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bag.sharedInstance.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = bagTableView.dequeueReusableCellWithIdentifier("ClubCellBag")! 
        
        let club = Bag.sharedInstance.get(indexPath.row)
        let carry_str = String(club.carry)
        let loft_str = String(club.loft)
        let subtitle = " (Carry: " + carry_str + ", " + " Loft: " + loft_str + ")"
        
        cell.textLabel?.text = club.name + subtitle
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeIndex = indexPath.row
        performSegueWithIdentifier("showEditClub", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditClub" {
            let navVC = segue.destinationViewController as! UINavigationController
            
            let destinationVC = navVC.viewControllers.first as! EditClubViewController
            destinationVC.index = activeIndex
        }
    }
    
    // MARK: - Button Actions
    
    func addClubPressed() {
        performSegueWithIdentifier("showAddClub", sender: self)
    }
    
}
