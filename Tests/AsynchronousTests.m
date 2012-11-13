//
//  AsynchronousTests.m
//  KVOWithBlocksDemo_osx
//
//  Created by Abizer Nasir on 12/11/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//
//  Unit Tests for the NSObject+JCSKVOWithBlocks category
//  These unit tests are common between the iOS and OS X demo projects.

static NSString * const kNumberObservationKey = @"_observee.number";

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+JCSKVOWithBlocks.h"

#import "ObservedClass.h"


@interface AsynchronousTests : SenTestCase
@end


@implementation AsynchronousTests {
    ObservedClass *_observee;}

#pragma mark - Set up and tear down

- (void)setUp {
    _observee = [ObservedClass new];
}

- (void)tearDown {
    _observee = nil;
}

#pragma mark - Unit Tests

- (void)testAsyncObservationMethodReturnsAnObject {
    NSMutableArray *changesArray = [NSMutableArray new];
    id observer = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:[NSOperationQueue new] block:^(NSDictionary *change) {
        [changesArray addObject:@"Test ran"];
    }];
    
    STAssertNotNil(observer, @"Registering an observer returns an object");

    [self jcsRemoveObserver:observer];
}

- (void)testChangesObservedOnAsyncQueue {
    NSMutableArray *changesArray = [NSMutableArray new];
    NSOperationQueue *queue = [NSOperationQueue new];

    id observer = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
        [changesArray addObject:[change objectForKey:NSKeyValueChangeNewKey]];
    }];

    _observee.number = 2;
    [queue waitUntilAllOperationsAreFinished];

    STAssertEquals([changesArray count], (NSUInteger)1, nil);
    STAssertEqualObjects([changesArray objectAtIndex:0], @2, @"Objects should be equal");

    [self jcsRemoveObserver:observer];
}

- (void)testInvalidatingTheObjectUsedInTheBlockDoesNotThrow {
    NSMutableArray *changesArray = [NSMutableArray new];
    NSOperationQueue *queue = [NSOperationQueue new];

    id observer = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
        [changesArray addObject:@2];
    }];

    changesArray = nil;

    _observee.number = 2;

    [queue waitUntilAllOperationsAreFinished];

    STAssertEquals([changesArray count], (NSUInteger)0, nil);

    [self jcsRemoveObserver:observer];
}

- (void)testObserverRespondsToMultipleChanges {
    NSMutableArray *changesArray = [NSMutableArray new];
    NSOperationQueue *queue = [NSOperationQueue new];

    id observer = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
        [changesArray addObject:[change objectForKey:NSKeyValueChangeNewKey]];
    }];

    _observee.number = 2;
    _observee.number = 3;

    [queue waitUntilAllOperationsAreFinished];

    STAssertEquals([changesArray count], (NSUInteger)2, @"Changes should be observed");

    [self jcsRemoveObserver:observer];

}

- (void)testMultipleObserversRespondToTheSameChange {
    NSOperationQueue *queue = [NSOperationQueue new];
    __block NSNumber *firstValue;
    __block NSNumber *secondValue;

    id observer = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
        firstValue = [change objectForKey:NSKeyValueChangeNewKey];
    }];

    id anotherObserver = [self jcsAddObserverForKeyPath:kNumberObservationKey options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
        secondValue = @([[change objectForKey:NSKeyValueChangeNewKey] integerValue] * 2);
    }];

    _observee.number = 4;

    [queue waitUntilAllOperationsAreFinished];
    
    STAssertEqualObjects(firstValue, @4, @"The first observer should handle the change");
    STAssertEqualObjects(secondValue, @8, @"The second observer should handle the change");

    [self jcsRemoveObserver:observer];
    [self jcsRemoveObserver:anotherObserver];
}

@end
