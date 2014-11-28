//
//  XMLMappedObject.swift
//  TBXMLWrapper
//
//  Created by simeon on 25/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//
//
// Inspired by Justin Driscoll's post:
// http://themainthread.com/blog/2014/04/mapping-xml-to-objects-with-nsxmlparser.html
//
//// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.




import Foundation


protocol XMLMappedObject:DebugPrintable{
    func mapperFoundString (#mapper:XMLObjectMapper, foundString: NSString, elementName: NSString)
    func foundAttributes(attributes:NSDictionary, elementName:NSString)
}

protocol XMLObjectMapperDelegate :class {
    
    func startMappingElement(#mapper:XMLObjectMapper, elementName: NSString, attributes:NSDictionary,
         currentObject:XMLMappedObject?) -> XMLMappedObject?
    
    func endMappedWithElement(#mapper:XMLObjectMapper,elelementName:NSString,currentObject:XMLMappedObject)
}


class RootMappedObject:XMLMappedObject {

    func mapperFoundString(#mapper: XMLObjectMapper, foundString: NSString, elementName: NSString) {
        
    }
    
    func foundAttributes(attributes: NSDictionary, elementName: NSString) {
     
    }
    
    
    var debugDescription: String {
        get {
           return "Root mapped object"
        }
    }
    
}

class XMLObjectMapper :NSObject, TBXMLParserDelegate {
    
    private var parser:TBXMLParser?
    private var text: NSString?
    
    private lazy var elements = [NSString]()
    private lazy var objects = [XMLMappedObject]()
    
    
    
    weak var delegate :XMLObjectMapperDelegate?
    
    init?(data:NSData, delegate:XMLObjectMapperDelegate){
        self.delegate = delegate
        self.parser = TBXMLParser(data: data)
        super.init()
        parser?.delegate = self;
        
    }
    
    func mapElementsToObjects(){
        if let p = parser {
            p.parse();
        }else {
            NSLog("parser init failed, can not parse and map");
        }
    }
    
    func inElements(#elementsToCheck:NSArray) -> Bool {
    
        var index = 0
        for item in elementsToCheck{
            if let i = find( elements,item as NSString){
                if i < index { return false;}
                index = i
            }else {
                return false;
            }
        }
        return true;
    }
   
   // MARK: - XML PARSER DELEGATE METHODS
    
    func tbXMLParser(parser: TBXMLParser!, didStartElementName elementName: String!, attributes: [NSObject : AnyObject]!) {
        self.elements.append(elementName);
        if let _delegate = self.delegate {
           
            let mappedObj = _delegate.startMappingElement(mapper: self, elementName: elementName, attributes: attributes, currentObject: self.objects.last )
           // Array
            if let obj = mappedObj {
                objects.append(obj);
            }
        }
        
    }
    
    func tbXMLParser(parser: TBXMLParser!, didEndElementName elementName: String!) {
    
        assert(elements.last!.isEqualToString(elementName), "Attempt to end tag other than the current head")
        elements.removeLast();
        let lastMappedObj = objects.last!
        if let value = text {
            lastMappedObj.mapperFoundString(mapper: self, foundString: value, elementName: elementName);
        }
        
        self.text = nil;
        objects.removeLast();
        
        if let _delegate = self.delegate {
            _delegate.endMappedWithElement(mapper: self, elelementName: elementName, currentObject: lastMappedObj);
        }
    }
    
    func tbXMLParser(parser: TBXMLParser!, findTextString text: String!) {
        self.text = text;        
    }
    
    
}