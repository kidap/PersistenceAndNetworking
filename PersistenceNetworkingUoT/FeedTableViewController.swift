//
//  FeedTableViewController.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
  
  var feed: Feed?{
    didSet{
      self.tableView.reloadData()
    }
  }
  
  var urlSession:NSURLSession!
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    urlSession = NSURLSession(configuration: configuration)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    urlSession.invalidateAndCancel()
    urlSession = nil
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.feed?.items.count) ?? 0
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FeedTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FeedTableViewCell

        // Configure the cell...
      
      cell.feedText.text  = self.feed!.items[indexPath.row].title
      
        var request = NSURLRequest(URL: feed!.items[indexPath.row].imageURL)
      
        cell.dataTask = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            if error == nil && data != nil{
                if let image = UIImage(data: data!){
                  cell.feedImage.image = image
                }
          
            }
          })
      }
      
      cell.dataTask?.resume()
      
      return cell
    }
  override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = cell as? FeedTableViewCell{
        cell.dataTask?.cancel()
    }
  }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
