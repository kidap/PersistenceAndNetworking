//
//  Feed.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit


func fixJsonData (data: NSData) -> NSData {
  var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
  dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
  return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
  
}

class Feed: NSObject,NSCoding {
  var items = [FeedItem]()
  var sourceUrl = NSURL()
  
  init( feed:[FeedItem], sourceUrl:NSURL){
    
    super.init()
    
    self.items = feed
    self.sourceUrl = sourceUrl

  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.items, forKey: "feedItems")
    aCoder.encodeObject(self.sourceUrl, forKey: "feedSourceURL")
  }

  required convenience init?(coder aDecoder:NSCoder){
    let storedItems = aDecoder.decodeObjectForKey("feedItems") as? [FeedItem]
    let storedURL = aDecoder.decodeObjectForKey("feedSourceURL") as? NSURL
    
    guard storedItems != nil && storedURL != nil else {
      return nil
    }
    self.init(feed: storedItems!, sourceUrl:storedURL!)
  }
  
  convenience init?(data: NSData, sourceUrl: NSURL){
  
    var newItems = [FeedItem]()
    
    let fixedData = fixJsonData(data)
    
    var jsonObject: Dictionary<String, NSObject>?
    
    do {
      try jsonObject = try NSJSONSerialization.JSONObjectWithData(fixedData, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, NSObject>
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
