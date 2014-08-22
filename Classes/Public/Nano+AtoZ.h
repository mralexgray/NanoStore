//
//  Nano+AtoZ.h
//  NanoStore
//
//  Created by Alex Gray on 8/18/14.
//
//

#import <Foundation/Foundation.h>
#import "NSFNanoSearch.h"

@interface NSFNanoSearch (AtoZ) 

+ (instancetype) searchWithStore:(NSFNanoStore*)nanoStore ofClass:(Class)k sortedBy:(id)sorters;


@property (readonly) NSDictionary *resultDictionary;
@property (readonly) NSArray *resultArray;

@end
