//
//  NSObject+JCSKVOWithBlocks.m
//  
//
//  Copyright (c) 2012 Abizer Nasir, Jungle Candy Software
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef DEBUG
    #ifndef NS_BLOCK_ASSERTIONS
        #define NS_BLOCK_ASSERTIONS
    #endif
#endif

#import "NSObject+JCSKVOWithBlocks.h"
#import <objc/runtime.h>

// The context for a KVO observations
static void* kJCSKVOWithBlocksObservationContext = &kJCSKVOWithBlocksObservationContext;

// The key under which the array of observers is stored in associated objects
static void* kJCSKVOWithBlocksObserverAssociatedObjectKey = &kJCSKVOWithBlocksObserverAssociatedObjectKey;


#pragma mark JCSKVOObserver

// This is the class that does the actual observing.

@interface JCSKVOObserver : NSObject

@property (nonatomic, readonly) NSString *observedKeyPath;
- (id)initWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions) options queue:(NSOperationQueue *)queue block:(jcsObservationBlock)block;

@end


@implementation JCSKVOObserver {
    NSKeyValueObservingOptions _options;
    NSOperationQueue *_queue;
    jcsObservationBlock _block;
}

- (id)initWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions) options queue:(NSOperationQueue *)queue block:(jcsObservationBlock)block {
    // It doesn't make sense to pass nil instead of a block for this category
    NSParameterAssert(block);

    self = [super init];
	if( self )
	{
		_observedKeyPath = [keyPath copy];
		_options = options;
		_queue = queue;
		_block = [block copy];
	}

    return self;
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != kJCSKVOWithBlocksObservationContext) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

    if (!_queue) {
        return _block(change);
    }

    return [_queue addOperationWithBlock:^{
        _block(change);
    }];
}

@end

#pragma mark - NSObject Category

@implementation NSObject (JCSKVOWithBlocks)

#pragma mark - Registering for observations

- (id)jcsAddObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue *)queue block:(jcsObservationBlock)block {
    id observer = [[JCSKVOObserver alloc] initWithKeyPath:keyPath options:options queue:queue block:block];

    [self addObserver:observer forKeyPath:keyPath options:options context: kJCSKVOWithBlocksObservationContext];

    dispatch_sync([self jcsKVOWithBlocksQueue], ^{
        NSMutableArray *observers = objc_getAssociatedObject(self, kJCSKVOWithBlocksObserverAssociatedObjectKey);

        if (!observers) {
            observers = [NSMutableArray new];
            objc_setAssociatedObject(self, kJCSKVOWithBlocksObserverAssociatedObjectKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        [observers addObject:observer];
    });

    return observer;
}

- (id)jcsAddObserverForKeyPath:(NSString *)keyPath withBlock:(jcsObservationBlock)block {
    return [self jcsAddObserverForKeyPath:keyPath options:NSKeyValueObservingOptionNew queue:nil block:block];
}

#pragma mark - Unregistering for observations

- (void)jcsRemoveObserver:(id)observer {
    if (!observer) {
        // It should always be safe to try and remove a nil observer
        return;
    }
    NSAssert([observer isMemberOfClass:[JCSKVOObserver class]], @"The observer has to be an instance of JCSKVOObserver");
    
    dispatch_sync([self jcsKVOWithBlocksQueue], ^{
        NSMutableArray *observers = objc_getAssociatedObject(self, kJCSKVOWithBlocksObserverAssociatedObjectKey);

        if (!observers || ![observers containsObject:observer]) {
            return;
        }

        [self removeObserver:observer forKeyPath:[observer observedKeyPath]];
        [observers removeObjectIdenticalTo:observer];
    });
}

#pragma mark - Private methods

- (dispatch_queue_t)jcsKVOWithBlocksQueue {
    static dispatch_queue_t queue = NULL;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.junglecandy.jcskvowithblocksqueue", 0);
    });

    return queue;
}

@end