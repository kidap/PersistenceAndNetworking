//
//  FeedItem.swift
//  PersistenceNetworkingUoT
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import Foundation

class FeedItem: NSObject, NSCoding {
  var title: String
  var imageURL: NSURL
  
  init(title:String, imageURL:NSURL){
    
    self.title = title
    self.imageURL = imageURL
    
    super.init()
  
  }
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.title, forKey: "itemTitle")
    aCoder.encodeObject(self.imageURL, forKey: "itemURL")
  }
  
  required convenience init?(coder aDecoder:NSCoder){
    let storedTitle = aDecoder.decodeObjectForKey("itemTitle") as? String
    let storedImageURL = aDecoder.decodeObjectForKey("itemURL") as? NSURL
    
    guard storedTitle != nil && storedImageURL != nil else {
      return nil
    }
    
    self.init(title: storedTitle!, imageURL:storedImageURL!)
  }
}