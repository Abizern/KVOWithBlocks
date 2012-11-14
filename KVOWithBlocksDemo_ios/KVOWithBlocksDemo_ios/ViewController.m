//
//  ViewController.m
//  DVOWithBlocksDemo_ios
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//

#import "ViewController.h"
#import "CommonMacros.h"
#import "NSObject+JCSKVOWithBlocks.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSOperationQueue *_queue;
    id _nLabelObserver;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _queue = [NSOperationQueue new];
    self.nlabel.text = @"0";
    self.fibonacciLabel.text = @"";
    self.slider.value = 0.0f;
    self.spinner.hidden = YES;

    /////////////////////////////////////////////////////////////////////////////////////
    // Comment out one or other of the methods below to see the difference between
    // blocking and non-blocking calls
    /////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////////////////
    // Non-blocking observer
    /////////////////////////////////////////////////////////////////////////////////////

    _nLabelObserver = [self jcsAddObserverForKeyPath:@"self.nlabel.text" options:NSKeyValueObservingOptionNew queue:_queue block:^(NSDictionary *change) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self startSpinner];
        });

        NSUInteger n = [self.nlabel.text integerValue];
        NSUInteger fibN = [self fibonacciNumber:n];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopSpinner];
            self.fibonacciLabel.text = [NSString stringWithFormat:@"%d", fibN];
        });
    }];

    /////////////////////////////////////////////////////////////////////////////////////
    // Blocking observer
    /////////////////////////////////////////////////////////////////////////////////////

//    _nLabelObserver = [self jcsAddObserverForKeyPath:@"self.nlabel.text" withBlock:^(NSDictionary *change) {
//        [self startSpinner];
//
//        NSUInteger n = [self.nlabel.text integerValue];
//        NSUInteger fibN = [self fibonacciNumber:n];
//
//        [self stopSpinner];
//        self.fibonacciLabel.text = [NSString stringWithFormat:@"%d", fibN];
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self jcsRemoveObserver:_nLabelObserver];
}

- (IBAction)sliderValueChanged {
    CGFloat sliderValue = self.slider.value;
    NSUInteger n = floorf(sliderValue);
    self.nlabel.text = [NSString stringWithFormat:@"%d", n];
}

#pragma mark - Private methods

// This is an intentionally poor fibonacci series generator
- (NSUInteger)fibonacciNumber:(NSUInteger)n {
    if (n < 2) {
        return n;
    }

    return [self fibonacciNumber:n-2] + [self fibonacciNumber:n-1];
}

- (void)startSpinner {
    self.fibonacciLabel.text = @"";
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)stopSpinner {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}

@end
