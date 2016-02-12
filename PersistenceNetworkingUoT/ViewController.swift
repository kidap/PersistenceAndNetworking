//
//  ViewController.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/09/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var dateLabel: UILabel!
  
  
  @IBAction func saveDate(sender: AnyObject) {
    dateLabel.text = NSDate().description
    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "buttonTapped")
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    if let date = NSUserDefaults.standardUserDefaults().objectForKey("buttonTapped") as? NSDate{
//      dateLabel.text = date.description
//    }
    
    dateLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("PhotoURLString")
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

