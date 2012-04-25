//
//  WWDCAppDelegate.h
//  WWDCChecker
//
//  Created by Kishikawa Katsumi on 12/04/11.
//  Copyright (c) 2012 Kishikawa Katsumi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WWDCAppDelegate : NSObject <NSApplicationDelegate> {
    NSDateFormatter *dateFormatter;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *textView;
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, strong) NSTimer *timer;

@end
