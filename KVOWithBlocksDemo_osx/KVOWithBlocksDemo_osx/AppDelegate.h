//
//  AppDelegate.h
//  KVOWithBlocksDemo_osx
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSTextField *nLabel;
@property (weak) IBOutlet NSTextField *fibonacciLabel;
@property (weak) IBOutlet NSProgressIndicator *spinner;

@end
