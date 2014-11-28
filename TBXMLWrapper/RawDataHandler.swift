//
//  RawDataHandler.swift
//  TBXMLWrapper
//
//  Created by simeon on 27/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//

import Foundation

class DataHandler:XMLObjectMapperDelegate {
   
    private var mapper:XMLObjectMapper? = nil
  
    var banners = [Banner]()
    var betTypeIcons:BetTypeIcons? = nil

    func mappingData(data:NSData) -> Bool{
        
        mapper = XMLObjectMapper(data: data, delegate: self);
        if mapper == nil {
            NSLog("failed to init mapper")
            return false;
        }
        mapper?.mapElementsToObjects()
        return true
    }
    
    
    
    func startMappingElement(#mapper:XMLObjectMapper, elementName: NSString, attributes:NSDictionary,
        currentObject:XMLMappedObject?) -> XMLMappedObject?{
            
            println("mapping element:\(elementName)");
            currentObject?.foundAttributes(attributes, elementName: elementName)
            
            if elementName.isEqualToString("Banner") {
                let banner = Banner();
                banners.append(banner)
                return banner;
            }
            
            if (elementName.isEqualToString("BetTypeIcons") ||
                elementName.isEqualToString("Display") ||
                elementName.isEqualToString("Displays")) {
                if  betTypeIcons == nil {
                   betTypeIcons = BetTypeIcons()
                }
                return betTypeIcons;
                
            }

            return RootMappedObject()
            
    }
    
    func endMappedWithElement(#mapper:XMLObjectMapper,elelementName:NSString,currentObject:XMLMappedObject){
        if elelementName.isEqualToString("Banners"){
           println(banners)
        }
        if elelementName.isEqualToString("BetTypeIcons") {
            println(betTypeIcons!)
        }

    }
    
}