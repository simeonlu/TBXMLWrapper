//
//  Banner.swift
//  TBXMLWrapper
//
//  Created by simeon on 27/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//

import Foundation

class Banner:RootMappedObject{
    
    var images:[Icon] = []
    var urls:[BannerIconUrl] = []
  
    
    override func foundAttributes(attributes: NSDictionary, elementName: NSString) {
        if attributes.count > 0{
            if elementName.isEqualToString("Image") {
                let icon = Icon(language: attributes["Lang"] as? String, path: attributes["Path"] as? String);
                images.append(icon);
            }
            if elementName.isEqualToString("Url") {
                let url = BannerIconUrl(language: attributes["Lang"] as? String)
                urls.append(url);
            }
        }
    }

 
   override var debugDescription: String {
        get {
         return "\n banner -> images:" + images.debugDescription + "\n urls:" + urls.description + "\n"
        }
    }
}

class BetTypeIcons:RootMappedObject {
    
    var betTypeIcons:[BetTypeIcon] = []
    
    override func foundAttributes(attributes: NSDictionary, elementName: NSString) {
        if attributes.count > 0{
            if elementName.isEqualToString("Icon") {
                let typeIcon = BetTypeIcon()
                betTypeIcons.append(typeIcon)
                let icon = Icon(language: attributes["Lang"] as? String, path: attributes["Path"] as? String);
                typeIcon.icon = icon
            }
            if elementName.isEqualToString("Display"){
                if let typeIcon = betTypeIcons.last{
                   let display = Display(poolName: attributes["Pool"] as? String, raceNo: attributes["RaceNo"] as? String, venue: attributes["Venue"] as? String)
                    typeIcon.displays.append(display)
                }
            }
        }
    }

    override var debugDescription: String {
        get {
            return "\n bettypeIcons  -> " + betTypeIcons.description + "\n"
        }
    }
}
class BetTypeIcon:DebugPrintable {

    var displays:[Display] = []
    var icon:Icon?
    
    var debugDescription:String {
        get {
            return "bet type icons, icon: \(icon!)" + "\n display: " + displays.description
        }
    }
}



struct Display : DebugPrintable {
    let poolName:String?
    let raceNo:String?
    let venue:String?
        // MARK
    var debugDescription:String {
        get {
            return "dispaly: race: \(raceNo!), pool: \(poolName!),venue: \(venue!)"
        }
    }
}


struct Icon:DebugPrintable {
    let language:String?
    let path:String?
    
    var debugDescription:String {
        get {
            return "icon struct: language: \(language!), venue: \(path!)"
        }
    }
}


struct BannerIconUrl:DebugPrintable {
    
    let language:String?
   
    var debugDescription:String {
        get{
            return "banner image: language: \(language!)"
        }
    }
}
