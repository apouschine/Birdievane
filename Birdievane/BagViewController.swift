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
        
        var addClubButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addClubPressed")
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
        var cell:UITableViewCell = bagTableView.dequeueReusableCellWithIdentifier("ClubCellBag") as UITableViewCell
        
        let club = Bag.sharedInstance.get(indexPath.row)
        var subtitle = " (Carry: " + String(club.carry) + ", " + " Loft: " + String(club.loft) + ")"
        
        cell.textLabel?.text = club.name + subtitle
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeIndex = indexPath.row
        performSegueWithIdentifier("showEditClub", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditClub" {
            var navVC = segue.destinationViewController as UINavigationController
            
            var destinationVC = navVC.viewControllers.first as EditClubViewController
            destinationVC.index = activeIndex
        }
    }
    
    // MARK: - Button Actions
    
    func addClubPressed() {
        performSegueWithIdentifier("showAddClub", sender: self)
    }
    
}
