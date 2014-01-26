//
//  NSObject+JCSKVOWithBlocks.h
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

/** A category on NSObject that allows you observe a keypath passing in a block to
 execute when the keypath changes instead of using a callback method.

 Why? Blocks are funky. They let you define an action at the same time as you are
 setting up a observation. In most cases this leads to clearer code than using a
 callback.
 
 An NSOperationQueue can be passed for the block to run on asynchronously if required.
 
 */

#import <Foundation/Foundation.h>

typedef void (^jcsObservationBlock)(NSDictionary *change);

@interface NSObject (JCSKVOWithBlocks)

/** Register to observe a keypath
 
 @return An opaque object reference that is later used to unregister for the observation.
 @param keyPath The key path, relative to the receiver, of the property to observe. This must not be `nil`.
 @param options A combination of `NSKeyValueObservingOptions` values that specifies what's included in observation notifications. See `NSKeyValueObservingOptions` in the NSKeyValueObserving Protocol reference
 @param queue An `NSOperationQueue` queue to run the handler block on. This can be `nil`, in which case the handler will run on the calling thread.
 @param block A block that takes the change dictionary as a parameter and returns nothing.
 
 This is typedef'd as:

    typedef void (^jcsObservationBlock)(NSDictionary *change);
 
 */
- (id)jcsAddObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue *)queue block:(jcsObservationBlock)block;

/** Register to observe changes to a keypath with NSKeyValueObeservingOptionsNew and a block that runs on tha calling thread.
 
 This is equivalent to calling `jcsAddObserverForKeyPath:options:queue:block:` with a nil queue and NSKeyValueObservingOptionsNew as the options paramater
 
 @return An opaque object reference that is later used to unregister for the observation.
 @param keyPath The key path, relative to the receiver, of the property to observe. This must not be `nil`.
 @param block A block that takes the change dictionary as a parameter and returns nothing.

 This is typedef'd as:

 typedef void (^jcsObservationBlock)(NSDictionary *change);

 */
- (id)jcsAddObserverForKeyPath:(NSString *)keyPath withBlock:(jcsObservationBlock)block;

/** Unregister an observer
 
 A good place to do this is in the `dealloc` method
 
 @return None
 @param observer The opaque object reference that was returned when registering for observations
 
 */
- (void)jcsRemoveObserver:(id)observer;

@end
