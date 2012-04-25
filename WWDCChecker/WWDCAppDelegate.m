//
//  WWDCAppDelegate.m
//  WWDCChecker
//
//  Created by Kishikawa Katsumi on 12/04/11.
//  Copyright (c) 2012 Kishikawa Katsumi. All rights reserved.
//

#import "WWDCAppDelegate.h"

@implementation WWDCAppDelegate

@synthesize window;
@synthesize textView;
@synthesize webView;
@synthesize timer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    self.webView = [[WebView alloc] init];
    [webView setFrameLoadDelegate:self];
    
    [self onTimer:nil];
}

- (void)onTimer:(NSTimer *)t
{
    if (!timer) {
        self.timer = [NSTimer timerWithTimeInterval:120.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://developer.apple.com/wwdc/"]];
    [request setHTTPShouldHandleCookies:NO];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [[webView mainFrame] loadRequest:request];
}

- (void)log:(NSString *)text
{
    NSRange	wholeRange;
    NSRange	endRange;
    
	[textView selectAll:nil];
    wholeRange = [textView selectedRange];
    endRange = NSMakeRange(wholeRange.length, 0);
    [textView setSelectedRange:endRange];
    [textView insertText:[NSString stringWithFormat:@"[%@] %@", [dateFormatter stringFromDate:[NSDate date]], text]];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame 
{
    if ([title isEqualToString:@"Apple Worldwide Developers Conference 2011"]) {
        [self log:@"WWDC Checked... no changes\n"];
    } else {
        [self notify];
    }
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame 
{
    [self log:error.localizedDescription];
}

- (void)notify {
    [self log:@"WWDC 2012 may have been announced!\n"];
    
    NSString *JSON = @"{\"channel\":\"\", \"data\":{\"alert\":\"WWDC 2012 may have been announced!\", \"sound\":\"notify.wav\"}}";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.parse.com/1/push"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"ICFdOE4GOlu8WN5KlC0ILpASiqIxShrl6zWKQKlu" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:@"ork5uoWbcoYxV8wXz34WLhNfKzmyAGEKTOG4JDKF" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[JSON dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error) {
             [self log:error.localizedDescription];
         }
     }];
}

@end
