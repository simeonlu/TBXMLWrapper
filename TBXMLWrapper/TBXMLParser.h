//
//  TBXMLParser.h
//  TBXMLWrapper
//
//  Created by simeon on 26/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
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



#import <Foundation/Foundation.h>

@class TBXMLParser;

@protocol TBXMLParserDelegate <NSObject>


-(void)tbXMLParser:(TBXMLParser*)parser didStartElementName:(NSString*)elementName attributes:(NSDictionary*) attributes;

-(void)tbXMLParser:(TBXMLParser *)parser didEndElementName:(NSString *)elementName ;

-(void)tbXMLParser:(TBXMLParser *)parser findTextString:(NSString*)text;

@end

@interface TBXMLParser : NSObject

@property(nonatomic,weak) id<TBXMLParserDelegate> delegate;

-(instancetype)initWithData:(NSData*)data;

-(void)parse;

@end
