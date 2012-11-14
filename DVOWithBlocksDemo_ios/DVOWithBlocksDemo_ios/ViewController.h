//
//  ViewController.h
//  DVOWithBlocksDemo_ios
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nlabel;
@property (weak, nonatomic) IBOutlet UILabel *fibonacciLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)sliderValueChanged;

@end
