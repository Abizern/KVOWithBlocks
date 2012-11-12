//
//  SynchronousTests.m
//  KVOWithBlocksDemo_osx
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//
//  Unit tests for the NSObject+JCSKVOWithBlocks class category
//  These unit tests are common between the iOS and OS X demo projects.
//

static NSString * const kNumberObservationKey = @"_observee.number";

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+JCSKVOWithBlocks.h"

#import "ObservedClass.h"


@interface SynchronousTests : SenTestCase
@property (copy, nonatomic) NSString *observedValueAsString;
@end

@implementation SynchronousTests {
    ObservedClass *_observee;
    id _observer;
}

#pragma mark - Set up and tear down

- (void)setUp {
    self.observedValueAsString = @"";
    _observee = [ObservedClass new];
    _observer = [self jcsAddObserverForKeyPath:kNumberObservationKey withBlock:^(NSDictionary *change){
        self.observedValueAsString = [NSString stringWithFormat:@"%ld", _observee.number];
    }];

}

- (void)tearDown {
    [self jcsRemoveObserver:_observer];
    _observee = nil;
    _observedValueAsString = nil;
}

#pragma mark - Tests

- (void)testObservingKeyPathWithoutABlockThrowsAnException {
    STAssertThrows([self jcsAddObserverForKeyPath:kNumberObservationKey withBlock:nil], @"No point using this method with a nil block");
}

- (void)testBasicObservationMethodReturnsAnOpaqueObject {
    STAssertNotNil(_observer, @"Registering an observer returns an opaque object");
    
}

- (void)testChangesToObservedValueHandled {
    
    _observee.number = 2;
    STAssertEqualObjects(self.observedValueAsString, @"2", @"Change in observed value should be handled");
}

- (void)testObserverCanBeRemoved {
    [self jcsRemoveObserver:_observer];

    _observee.number = 2;

    STAssertEqualObjects(self.observedValueAsString, @"", @"There should be no change as the observer has been removed");
    
}

- (void)testTryingToRemoveAnInvalidObserverThrownAnException {
    id invalidObserver = [NSString new];
    STAssertThrows([self jcsRemoveObserver:invalidObserver], @"The observer has to be an object received from registering an observer");
}

- (void)testRemovingAnObserverTwiceHandledGracefully {
    id observer2 = [self jcsAddObserverForKeyPath:kNumberObservationKey withBlock:^(NSDictionary *change){
        self.observedValueAsString = [NSString stringWithFormat:@"%ld", _observee.number];
    }];

    [self jcsRemoveObserver:observer2];

    STAssertNoThrow([self jcsRemoveObserver:observer2], @"Removing an oberver twice doesn't crash");
}

@end
