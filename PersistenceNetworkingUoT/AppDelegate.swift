//
//  AppDelegate.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/09/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    NSUserDefaults.standardUserDefaults().registerDefaults(["PhotoURLString" : "https://api.flickr.com/services/feeds/photos_public.gne?tags=pug&format=json&nojsoncallback=1"])
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    let urlString = NSUserDefaults.standardUserDefaults().stringForKey("PhotoURLString")
    
    print(urlString)
    
    //guard let

    if let photoFeedURL = NSURL(string: urlString!) {
      self.loadOrUpdateFeed(photoFeedURL, completion: { (feed) -> Void in
        let viewController = application.windows[0].rootViewController as? FeedTableViewController
        
        viewController?.feed = feed
      })
    }
    
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func updateFeed(url:NSURL, completion: (feed:Feed?) ->Void){
    //let dataFile = NSBundle.mainBundle().URLForResource("photos_public.gne", withExtension: ".js")!
    //let data = NSData(contentsOfURL: dataFile)!
    //let data2 = NSData(contentsOfURL: url)!
    //let feedData = Feed(data: data2, sourceUrl: url)
    //completion(feed: feedData)
    
    let request = NSURLRequest(URL: url)
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
      if error == nil && data != nil {
        let feedData = Feed(data: data!, sourceUrl: url)
        
        if let goodfeed = feedData{
          if self.saveFeed(goodfeed){
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastUpdate")
          }
        }
        
        print("Loaded remote feed")
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completion(feed: feedData)
        })
      }
    }
    
    dataTask.resume()
    
  }
  
  
  func feedFilePath() -> String {
    let paths = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    let filePath = paths[0].URLByAppendingPathComponent("feedFile.plist")
    return filePath.path!
  }
  
  func saveFeed(feed: Feed) -> Bool {
    let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
    assert(success, "failed to write archive")
    return success
  }
  
  func readFeed(completion: (feed: Feed?) -> Void) {
    let path = feedFilePath()
    let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
    completion(feed: unarchivedObject as? Feed)
  }

  
  func loadOrUpdateFeed(url: NSURL, completion: (feed: Feed?) -> Void) {
    
    let lastUpdatedSetting = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdate") as? NSDate
    
    var shouldUpdate = true
    if let lastUpdated = lastUpdatedSetting where NSDate().timeIntervalSinceDate(lastUpdated) < 20 {
      shouldUpdate = false
    }
    if shouldUpdate {
      self.updateFeed(url, completion: completion)
    } else {
      self.readFeed { (feed) -> Void in
        if let foundSavedFeed = feed where foundSavedFeed.sourceUrl.absoluteString == url.absoluteString {
          print("loaded saved feed!")
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completion(feed: foundSavedFeed)
          })
        } else {
          self.updateFeed(url, completion: completion)
        }
        
        
      }
    }
    
    
    
  }

}

