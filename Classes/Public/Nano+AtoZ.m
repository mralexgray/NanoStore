//
//  Nano+AtoZ.m
//  NanoStore
//
//  Created by Alex Gray on 8/18/14.
//
//

#import "NanoStore.h"
#import "NanoStore_Private.h"
#import "NSFNanoSearch_Private.h"
#import "NSFNanoExpression_Private.h"
#import "Nano+AtoZ.h"


@implementation NSFNanoSearch (AtoZ)

+ (instancetype) searchWithStore:(NSFNanoStore*)nanoStore ofClass:(Class)k sortedBy:(id)sorters {

  NSFNanoSearch *search = [self searchWithStore:nanoStore];
  search.filterClass    = NSStringFromClass(k);
  search.sort           = @[[NSFNanoSortDescriptor.alloc initWithAttribute:sorters ascending:NO]];
  return search;
}

- (NSDictionary*) resultDictionary {

  return [self searchObjectsWithReturnType:NSFReturnObjects error:nil];
}

- (NSArray*) resultArray { return self.resultDictionary.allValues; }

@end
