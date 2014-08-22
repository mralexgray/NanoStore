//
//  NanoCarTestClass.m
//  NanoStore
//
//  Created by Tito Ciuro on 5/26/12.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoCarTestClass.h"

#define kName   @"kName"

@implementation NanoCarTestClass

- (id)initNanoObjectFromDictionaryRepresentation:(NSDictionary*)theD forKey:(NSString*)k store:(NSFNanoStore*)n {

  return self = super.init ? _name = theD[kName], _key = k, self : nil;
}

- (NSDictionary *)nanoObjectDictionaryRepresentation { return @{kName: _name}; }

- (NSString *)nanoObjectKey { return self.key; }

- (id)rootObject { return self; }

@end
