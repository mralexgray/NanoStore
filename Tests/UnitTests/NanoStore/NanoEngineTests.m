//
//  NanoEngineTests.h
//  NanoStore
//
//  Created by Tito Ciuro on 9/11/10.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoStore.h"
#import "NSFNanoStore_Private.h"

@interface NanoEngineTests : XCTestCase
{
    NSDictionary *_defaultTestInfo;
}

@end

@implementation NanoEngineTests

- (void)setUp { [super setUp];
    
    _defaultTestInfo = [NSFNanoStore _defaultTestData];
    
    NSFSetIsDebugOn (NO);
}

- (void)tearDown
{
    
    NSFSetIsDebugOn (NO);
    
    [super tearDown];
}


- (void)testMaxROWUID
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    
    NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
    NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
    [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];
    
    NSFNanoEngine *engine = [nanoStore nanoStoreEngine];
    long long maxRowUID = [engine maxRowUIDForTable:@"NSFKeys"];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue (maxRowUID == 2, @"Expected to find the max RowUID for the given table.");
}

@end
