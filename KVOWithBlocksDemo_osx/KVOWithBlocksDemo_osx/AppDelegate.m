//
//  AppDelegate.m
//  KVOWithBlocksDemo_osx
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+JCSKVOWithBlocks.h"

@implementation AppDelegate {
    NSOperationQueue *_queue;
    id _nLabelObserver;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.slider setIntegerValue:0];
    [self.nLabel setIntegerValue:0];
    [self.fibonacciLabel setStringValue:@""];
    [self.spinner setHidden:YES];
    
    _queue = [NSOperationQueue new];

    /////////////////////////////////////////////////////////////////////////////////////
    // Comment out one or other of the methods below to see the difference between
    // blocking and non-blocking calls
    /////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////////////////
    // Non-blocking observer
    /////////////////////////////////////////////////////////////////////////////////////

//    _nLabelObserver = [self jcsAddObserverForKeyPath:@"self.nLabel.integerValue" options:NSKeyValueObservingOptionNew queue:_queue block:^(NSDictionary *change) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self startSpinner];
//        });
//
//        NSUInteger n = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
//        NSUInteger fibN = [self fibonacciNumber:n];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self stopSpinner];
//            self.fibonacciLabel.integerValue = fibN;
//        });
//        
//    }];

    /////////////////////////////////////////////////////////////////////////////////////
    // Blocking observer
    /////////////////////////////////////////////////////////////////////////////////////

    _nLabelObserver = [self jcsAddObserverForKeyPath:@"self.nLabel.integerValue" withBlock:^(NSDictionary *change) {
        [self startSpinner];

        NSUInteger n = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        NSUInteger fibN = [self fibonacciNumber:n];

        [self stopSpinner];

        self.fibonacciLabel.integerValue = fibN;
    }];

    
}

- (void)dealloc {
    [self jcsRemoveObserver:_nLabelObserver];
}

// This is an intentionally poor fibonacci series generator
- (NSUInteger)fibonacciNumber:(NSUInteger)n {
    if (n < 2) {
        return n;
    }

    return [self fibonacciNumber:n-2] + [self fibonacciNumber:n-1];
}

- (void)startSpinner {
    [self.fibonacciLabel setStringValue:@""];
    [self.spinner setHidden:NO];
    [self.spinner startAnimation:self];
}

- (void)stopSpinner {
    [self.spinner stopAnimation:self];
    [self.spinner setHidden:YES];
}

@end
