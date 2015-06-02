//
//  ViewController.h
//  connectAndReadContentMSSharepoint
//
//  Created by Fellipe Souto on 6/2/15.
//  Copyright (c) 2015 Fellipe Souto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate, NSURLConnectionDelegate>
{
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSString *finaldata;
    NSString *convertToStringData;
    NSMutableString *nodeContent;
}
@end
