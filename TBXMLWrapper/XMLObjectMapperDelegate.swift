//
//  XMLObjectMapperDelegate.swift
//  TBXMLWrapper
//
//  Created by simeon on 25/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//

import Foundation

protocol XMLObjectMapperDelegate{
    func startMappingElement(#mapper:XMLObjectMapper, elementName: NSString, attributes:NSDictionary, currentObject:XMLMappedObject) -> XMLMappedObject
    
    func endMappedWithElement(#mapper:XMLObjectMapper,elelementName:NSString,currentObject:XMLMappedObject)
}

