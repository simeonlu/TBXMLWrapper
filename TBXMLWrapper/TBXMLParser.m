//
//  TBXMLParser.m
//  TBXMLWrapper
//
//  Created by simeon on 26/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//
//// Inspired by Justin Driscoll's post:
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




#import "TBXMLParser.h"
#import "TBXML.h"

@interface TBXMLParser()
@property(nonatomic) TBXML *tbXML;
@end

@implementation TBXMLParser

-(instancetype)initWithData:(NSData*)data {
    
    self = [super init];
    if (self) {
        NSError*error =nil;
        _tbXML = [[TBXML alloc]initWithXMLData:data error:&error];
        if (error) {
            NSLog(@"TBXML init failed, error message:%@",error.localizedDescription);
            _tbXML = nil;
        }
    }
    
    return self;
}

-(void)parse{
    if (_tbXML==nil) {
        NSLog(@"Failed to ini tbxml, so the parsing can not be completed.");
        return;
    }
    if (_tbXML.rootXMLElement) {
      [self traverseElement:_tbXML.rootXMLElement];
    }else{
        NSLog(@"XML is not aproper xml, it has no root node, can not be parsed.");
    }
    
    
}

-(void)traverseElement:(TBXMLElement*)element{
    
    do {
        NSString*eleName =[TBXML elementName:element];
        NSLog(@"start element:%@",eleName);
        
        TBXMLAttribute * attr = element -> firstAttribute;
        NSMutableDictionary*dict =[NSMutableDictionary dictionary];
        while (attr) {
            
            NSString*attriName = [TBXML attributeName:attr];
            NSString*value = [TBXML attributeValue:attr];
            
            NSLog(@"element:%@ -> attribute:%@ = %@",eleName,attriName,value);
            if (attriName&&value) {
                [dict setObject:value forKey:attriName];
            }

            attr = attr -> next;
        }
        
        if ([_delegate respondsToSelector:@selector(tbXMLParser:didStartElementName:attributes:)]) {
            [_delegate tbXMLParser:self didStartElementName:eleName attributes:dict];
        }
        
        dict = nil;
        
        if (element->firstChild) {
            [self traverseElement:element->firstChild];
        }else {
            NSError*error=nil;
            NSString*value = [TBXML textForElement:element error:&error];
            if (value!=nil) {
                if ([_delegate respondsToSelector:@selector(tbXMLParser:findTextString:)]) {
                    [_delegate tbXMLParser:self findTextString:value];
                }
            }
        }
        NSLog(@"end of node:%@",eleName);
        if ([_delegate respondsToSelector:@selector(tbXMLParser:didEndElementName:)]) {
            [_delegate tbXMLParser:self didEndElementName:eleName];
        }
        
    }while ((element = element -> nextSibling));
}

@end
