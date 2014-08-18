//
//  NanoStoreResultTests.m
//  NanoStore
//
//  Created by Tito Ciuro on 11/11/10.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoStore.h"
#import "NanoStore_Private.h"
#import "NSFNanoStore_Private.h"


@interface NanoStoreResultTests : XCTestCase
{
    NSDictionary *_defaultTestInfo;
}
@end

@implementation NanoStoreResultTests

- (void)setUp { [super setUp];
    
    _defaultTestInfo = [NSFNanoStore _defaultTestData];
    
    NSFSetIsDebugOn (NO);
}

- (void)tearDown
{
    
    NSFSetIsDebugOn (NO);
    
    [super tearDown];
}


- (void)testResultNumberValueReturned
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    
    [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]]] error:nil];
    [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]]] error:nil];
    
    NSFNanoResult *result = [nanoStore _executeSQL:@"SELECT NSFValue from NSFValues WHERE NSFAttribute = 'SomeNumber'"];
    BOOL success = (nil == [result error]);
    
    XCTAssertTrue (success == YES, @"Expected to find values without an error.");
}

@end
