//
//  Feed.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit


func fixJSONDate (data: NSData) ->NSData {
  let data = NSData()
  return data
}

class Feed: NSObject {
  var items = [FeedItem]()
  var sourceUrl = NSURL()
  
  init( feed:[FeedItem], sourceUrl:NSURL){
    self.items = feed
    self.sourceUrl = sourceUrl

  }
  
  convenience init?(data: NSData, sourceUrl: NSURL){
  
    var newItems = [FeedItem]()
    
    //let fixedData = fixJSONDate(data)
    
    var jsonObject: Dictionary<String, NSObject>?
    
    do {
      try jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, NSObject>
    } catch{
    
    }
    
    guard let feedRoot = jsonObject else{
      return nil
    }
    
    guard let items = feedRoot["items"] as? Array<AnyObject> else{
      return nil
    }
    
    for item in items{
    
      guard let itemDict = item as? Dictionary<String, NSObject> else {
        continue
      }
      
      guard let media = itemDict["media"] as? Dictionary<String, NSObject> else {
        continue
      }
      
      guard let urlString = media["m"] as? String else {
        continue
      }
      
      guard let url = NSURL(string: urlString) else {
        continue
      }
      
      let title = item["title"] as? String
      
      newItems.append(FeedItem(title: title ?? "other title", imageURL:url))
      
    }
    
    
    
    self.init(feed: newItems, sourceUrl: sourceUrl)
    
    
    
  }

}
