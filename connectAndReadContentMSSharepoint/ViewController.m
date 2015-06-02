//
//  ViewController.m
//  connectAndReadContentMSSharepoint
//
//  Created by Fellipe Souto on 6/2/15.
//  Copyright (c) 2015 Fellipe Souto. All rights reserved.
//

#import "ViewController.h"

#define DEFAULT_URL @"sharepoint url"
#define AUTHENTICATION_URL @"Authentication.asmx"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)loginAuthenticate
{
    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetListCollection xmlns=\"http://schemas.microsoft.com/sharepoint/soap/\" />\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>\n"];
    
    NSLog(@"The request format is %@",soapFormat);
    
    nodeContent = [[NSMutableString alloc]init];
    
    NSURL *locationOfWebService = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_URL, AUTHENTICATION_URL]];
    
    NSLog(@"web url = %@",locationOfWebService);
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapFormat length]];
    
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://schemas.microsoft.com/sharepoint/soap/GetListCollection" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[soapFormat dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
    if (connect)
    {
        webData = [[NSMutableData alloc]init];
    }
    else
    {
        NSLog(@"No Connection established");
    }
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection self];
    [webData self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *user = [NSString stringWithFormat:@"dir\\%@", @"userName"];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:user password:@"password" persistence:NSURLCredentialPersistenceForSession];
            
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"AUTENTICADO COM SUCESSO  -----  %@", string);
}


@end
