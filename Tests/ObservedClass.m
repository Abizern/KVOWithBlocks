//
//  ObservedClass.m
//
//  Created by Abizer Nasir on 12/10/2012.
//  Copyright (c) 2012 Jungle Candy Software. All rights reserved.
//

#import "ObservedClass.h"

@implementation ObservedClass

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail
    }

    _number = 0;

    return self;
}

@end
