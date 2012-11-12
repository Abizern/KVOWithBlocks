//
//  AsynchronousTests.m
//  KVOWithBlocksDemo_osx
//
//  Created by Abizer Nasir on 12/11/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//
//  Unit Tests for the NSObject+JCSKVOWithBlocks category
//  These unit tests are common between the iOS and OS X demo projects.

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+JCSKVOWithBlocks.h"

#import "ObservedClass.h"


@interface AsynchronousTests : SenTestCase
@property (copy, nonatomic) NSString *observedValueAsString;
@end


@implementation AsynchronousTests {
    ObservedClass *_observee;
    id _observer;
}

@end
