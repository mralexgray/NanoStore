//
//  NanoStoreSearchTests.m
//  NanoStore
//
//  Created by Tito Ciuro on 10/4/08.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoStore.h"
#import "NSFNanoSearch_Private.h"
#import "NSFNanoStore_Private.h"
#import "NSFNanoObject_Private.h"
#import "NSFNanoSortDescriptor.h"
#import "NanoCarTestClass.h"
#import "NanoPersonTestClass.h"
#import "NSFNanoGlobals_Private.h"

@interface NanoStoreSearchTests : XCTestCase
{
               double   _systemVersion;
         NSDictionary * _defaultTestInfo;
         NSFNanoStore * nanoStore;
        NSFNanoSearch * search;
     NanoCarTestClass * car;
  NanoPersonTestClass * personA,
                      * personB;
}

@end

@implementation NanoStoreSearchTests

- (void) setUp { [super setUp]; search = nil;  _defaultTestInfo = NSFNanoStore._defaultTestData;

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED // code only compiled when targeting Mac OS X and not iOS.... Obtain the system version

  SInt32 major, minor; Gestalt(gestaltSystemVersionMajor, &major); Gestalt(gestaltSystemVersionMinor, &minor);

  _systemVersion = major + (minor/10.0);

#else                                           // Round to the nearest since it's not always exact

  _systemVersion = floorf([[[UIDevice currentDevice]systemVersion]floatValue] * 10 + 0.5) / 10;

#endif

  NSFSetIsDebugOn (NO);
}

- (void) tearDown { NSFSetIsDebugOn (NO); personA = nil; personB = nil; car = nil; [super tearDown]; }

#pragma mark -

- (void) testSearchStoreNil {

  @try                      { search = [NSFNanoSearch searchWithStore:nil]; }
  @catch (NSException *e)   { XCTAssertTrue (e != nil, @"We should have caught the exception."); }
}

- (void) testSearchStoreSet {

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];

  XCTAssertTrue ([search nanoStore] != nil, @"Expected default Search object to have a NanoStore object assigned.");
}

- (void) testSearchDefaultValues {

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSString *key = [search key];
  NSString *attribute = [search attribute];
  NSString *value = [search value];
  NSFMatchType match = [search match];
  NSArray *attributesReturned = [search attributesToBeReturned];

  BOOL success = (nil == key) && (nil == attribute) && (nil == value) && (match == NSFContains) && ([attributesReturned count] == 0);

  XCTAssertTrue (success == YES, @"Expected default Search object to be properly initialized.");
}

- (void) testSearchKeyAccessor {

  NSString *value = @"ABC";

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setKey:value];

  NSString *retrievedValue = [search key];

  XCTAssertTrue ([retrievedValue isEqualToString:value] == YES, @"Expected accessor to return the proper value.");
}

- (void) testSearchAttributeAccessor {

  NSString *value = @"ABC", *retrievedValue;

  [   search = [NSFNanoSearch    searchWithStore:
   nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil]]
                                    setAttribute:value];

  XCTAssertTrue ([retrievedValue = search.attribute isEqualToString:value], @"Expected accessor to return the proper value.");
}

- (void) testSearchValueAccessor {

  NSString *value = @"ABC";

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setValue:value];

  NSString *retrievedValue = [search value];

  XCTAssertTrue ([retrievedValue isEqualToString:value] == YES, @"Expected accessor to return the proper value.");
}

- (void) testSearchMatchAccessor {

  NSFMatchType value = NSFContains;

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setMatch:value];

  NSFMatchType retrievedValue = [search match];

  XCTAssertTrue (retrievedValue == value == YES, @"Expected accessor to return the proper value.");
}

- (void) testSearchExpressionsAccessor {

  NSFNanoPredicate *firstNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"foo"];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"bar"];
  NSFNanoExpression *expression1 = [NSFNanoExpression expressionWithPredicate:firstNamePred];
  [expression1 addPredicate:valuePred withOperator:NSFAnd];

  NSFNanoPredicate *countryPred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"another foo"];
  NSFNanoPredicate *cityPred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEndsWith value:@"another bar"];
  NSFNanoExpression *expression2 = [NSFNanoExpression expressionWithPredicate:countryPred];
  [expression2 addPredicate:cityPred withOperator:NSFAnd];

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression1, expression2]];

  NSArray *expressions = [search expressions];

  XCTAssertTrue ([expressions count] == 2, @"Expected accessor to return two expressions.");
}

- (void) testSearchAttributesAccessor {

  NSArray *value = @[@"one", @"two", @"three"];

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attributesToBeReturned = value;

  NSArray *retrievedValue = search.attributesToBeReturned;

  XCTAssertTrue ([retrievedValue isEqualToArray:value] == YES, @"Expected accessor to return the proper value.");
}

- (void) testSearchUsingNanoObjectSubclass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = NanoPersonFirst;
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(person.class);

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  NanoPersonTestClass *retrievedPerson = [[searchResults allValues]lastObject];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one person object.");
  XCTAssertTrue ([retrievedPerson isKindOfClass:NanoPersonTestClass.class
  ], @"Expected to find a NanoPersonTestClass object.");
  XCTAssertTrue (nil != [retrievedPerson key], @"Expected the object to contain a valid key.");
  XCTAssertTrue ([[retrievedPerson key]isEqualToString:[person key]], @"Expected to find the object that was saved originally.");
}

- (void) testSearchReset {

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setKey:@"foo"];
  [search setValue:@"bar"];

  [search reset];

  NSString *key = [search key];
  NSString *attribute = [search attribute];
  NSString *value = [search value];
  NSFMatchType match = [search match];
  NSArray *attributesReturned = search.attributesToBeReturned;

  BOOL success = (nil == key) && (nil == attribute) && (nil == value) && (match == NSFContains) && ([attributesReturned count] == 0);

  XCTAssertTrue (success == YES, @"Expected default Search object to be properly reset.");
}

#pragma mark -

- (void) testSearchByAttributeExists {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];

  NSFNanoBag *bag = [NSFNanoBag bag];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];
  [nanoStore addObjectsFromArray:@[bag] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"Rating";
  [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

#define SHOULD_FIND(X) [[search searchObjectsWithReturnType:NSFReturnObjects error:nil]count] == X, @"Expected to find %i objects.", X

  XCTAssertTrue ([[search searchObjectsWithReturnType:NSFReturnObjects error:nil]count] == 3, @"Expected to find three objects.");
  search.match = NSFEqualTo;
  XCTAssertTrue (SHOULD_FIND(3));

  search.match = NSFBeginsWith;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(0));
  search.match = NSFContains;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(0));
  search.match = NSFEndsWith;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(0));

  search.match = NSFBeginsWith;
  search.value = @"Good";
  XCTAssertTrue (SHOULD_FIND(3));
  search.match = NSFContains;
  search.value = @"Good";
  XCTAssertTrue (SHOULD_FIND(3));
  search.match = NSFEndsWith;
  search.value = @"Good";
  XCTAssertTrue (SHOULD_FIND(3));

  search.match = NSFInsensitiveBeginsWith;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(3));
  search.match = NSFInsensitiveContains;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(3));
  search.match = NSFInsensitiveEndsWith;
  search.value = @"good";
  XCTAssertTrue (SHOULD_FIND(3));

  search.match = NSFGreaterThan;
  search.value = @"g";
  XCTAssertTrue (SHOULD_FIND(0));
  search.match = NSFGreaterThan;
  search.value = @"G";
  XCTAssertTrue (SHOULD_FIND(3));

  search.match = NSFLessThan;
  search.value = @"vd";
  XCTAssertTrue (SHOULD_FIND(3));
  search.match = NSFLessThan;
  search.value = @"Very";
  XCTAssertTrue (SHOULD_FIND(3));

  search.match = NSFGreaterThan;
  search.value = @"vd";
  XCTAssertTrue (SHOULD_FIND(0));
  search.match = NSFGreaterThan;
  search.value = @"Very";
  XCTAssertTrue (SHOULD_FIND(3));
}

- (void) testSearchObjectsReturningKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([searchResults isKindOfClass:NSArray.class
  ], @"Incorrect class returned. Expected NSArray.");
  XCTAssertTrue (searchResults.count == 2, @"Expected to find two objects.");
}

- (void) testSearchObjectsReturningObjects {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([searchResults isKindOfClass:NSDictionary.class
  ], @"Incorrect class returned. Expected NSDictionary.");
  XCTAssertTrue (searchResults.count == 2, @"Expected to find two objects.");
}

- (void) testSearchObjectsReturningObjectsWithGivenKey {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.key = obj1.key;

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

- (void) testSearchObjectsReturningKeyWithGivenKey {

  [nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil]
                                                                            openWithError:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj2;
  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                            obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.key = obj2.key;

  NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one object. Found %lu", searchResults.count);
}

- (void) testSearchWithAttributeContainingPeriodAndValue {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSDictionary *countriesInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Llavaneres", @"Spain",
                                 @"San Francisco", @"USA",
                                 @"Very Good", @"Rating",
                                 nil, nil];
  NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"John", @"FirstName",
                        @"Doe", @"LastName",
                        countriesInfo, @"Countries",
                        @((arc4random() % 32767) + 1), @"SomeNumber",
                        @"To be decided", @"Rating",
                        nil, nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:info];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"Countries.Spain";
  search.match = NSFEqualTo;
  search.value = @"Barcelona";

  NSError *searchError = nil;
  id searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:&searchError];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void) testSearchWithAttributeContainingPeriodNoValue {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"Countries.Spain";

  NSError *searchError = nil;
  id searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:&searchError];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([searchResults count] == 2, @"Expected to find two objects.");
}

- (void) testSearchObjectsWithOffsetAndLimit {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  for (int i = 0; i < 10; i++) {
    [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]]] error:nil];
  }

  NSFNanoSortDescriptor *sortByNumber = [NSFNanoSortDescriptor.alloc initWithAttribute:@"SomeNumber" ascending:YES];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.value = @"Barcelona";
  search.match = NSFEqualTo;
  search.limit = 5;
  search.offset = 3;
  search.sort = @[sortByNumber];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 5, @"Expected to find five objects.");
}

- (void) testSearchObjectsWithOffsetAndLimitWithExpressions {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  for (int i = 0; i < 10; i++) {
    [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
  }

  NSFNanoSortDescriptor *sortByValue = [NSFNanoSortDescriptor.alloc initWithAttribute:NSFKey ascending:YES];
  NSFNanoSortDescriptor *sortByROWID = [NSFNanoSortDescriptor.alloc initWithAttribute:NSFRowIDColumnName ascending:YES];

  NSFNanoPredicate *firstNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"FirstName"];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Tito"];
  NSFNanoExpression *expression1 = [NSFNanoExpression expressionWithPredicate:firstNamePred];
  [expression1 addPredicate:valuePred withOperator:NSFAnd];

  NSFNanoPredicate *countryPred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"Countries.Spain"];
  NSFNanoPredicate *cityPred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEndsWith value:@"celona"];
  NSFNanoExpression *expression2 = [NSFNanoExpression expressionWithPredicate:countryPred];
  [expression2 addPredicate:cityPred withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.expressions = @[expression1, expression2];
  search.limit = 5;
  search.offset = 3;
  search.sort = @[sortByValue, sortByROWID];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 5, @"Expected to find five objects.");
}

- (void) testSearchTwoExpressions {

  [nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil]
                                                  removeAllObjectsFromStoreAndReturnError:nil];


  [nanoStore addObject: [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo] error:nil];

  NSFNanoPredicate *firstNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn
                                                                 matching:NSFEqualTo
                                                                    value:@"FirstName"];
  NSFNanoPredicate     *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn
                                                                 matching:NSFEqualTo
                                                                   value:@"Tito"];

  NSFNanoExpression *expression1 = [NSFNanoExpression expressionWithPredicate:firstNamePred];

  [expression1 addPredicate:valuePred withOperator:NSFAnd];

  NSFNanoPredicate *countryPred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"Countries.Spain"];
  NSFNanoPredicate *cityPred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEndsWith value:@"celona"];
  NSFNanoExpression *expression2 = [NSFNanoExpression expressionWithPredicate:countryPred];
  [expression2 addPredicate:cityPred withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression1, expression2]];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

- (void) testSearchThreeExpressions {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObject:obj1 error:nil];

  NSFNanoPredicate *firstNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"FirstName"];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Tito"];
  NSFNanoExpression *expression1 = [NSFNanoExpression expressionWithPredicate:firstNamePred];
  [expression1 addPredicate:valuePred withOperator:NSFAnd];

  NSFNanoPredicate *countryPred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"Countries.Spain"];
  NSFNanoPredicate *cityPred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEndsWith value:@"celona"];
  NSFNanoExpression *expression2 = [NSFNanoExpression expressionWithPredicate:countryPred];
  [expression2 addPredicate:cityPred withOperator:NSFAnd];

  NSFNanoPredicate *countryPred2 = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"Countries.France.Nice"];
  NSFNanoPredicate *cityPred2 = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Cassoulet"];
  NSFNanoExpression *expression3 = [NSFNanoExpression expressionWithPredicate:countryPred2];
  [expression3 addPredicate:cityPred2 withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression1, expression2, expression3]];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

#pragma mark -

- (void) testSearchObjectsAddedBeforeCalendarDate {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:60 * 60];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsAdded:NSFBeforeDate date:date returnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 2), @"Expected to find two objects.");
}

- (void) testSearchObjectsAddedBeforeCalendarDateFilterByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:60 * 60];

  NSDictionary *searchResults = [search searchObjectsAdded:NSFBeforeDate date:date returnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one car object.");
}

- (void) testSearchObjectsAddedAfterCalendarDate {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:-(60 * 60)];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsAdded:NSFAfterDate date:date returnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 2), @"Expected to find two objects.");
}

- (void) testSearchObjectsAddedAfterCalendarDateFilterByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:-(60 * 60)];

  NSDictionary *searchResults = [search searchObjectsAdded:NSFAfterDate date:date returnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one car object.");
}

- (void) testSearchKeysAddedBeforeCalendarDate {

  [nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil]
                                                  removeAllObjectsFromStoreAndReturnError:nil];

  [nanoStore addObjectsFromArray:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                                   [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]]error:nil];

  NSArray *searchResults = [search = [NSFNanoSearch searchWithStore:nanoStore]
                                                 searchObjectsAdded:NSFBeforeDate
                                                               date:[NSDate.date dateByAddingTimeInterval:60 * 60]
                                                         returnType:NSFReturnKeys error:nil];

  XCTAssertTrue (([[searchResults lastObject]isKindOfClass:NSString.class
  ]), @"Expected the key to be a string.");

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 2, @"Expected to find two objects.");
}

- (void) testSearchKeysAddedBeforeCalendarDateFilterByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:60 * 60];

  NSArray *searchResults = [search searchObjectsAdded:NSFBeforeDate date:date returnType:NSFReturnKeys error:nil];

  XCTAssertTrue (([[searchResults lastObject]isKindOfClass:NSString.class
  ]), @"Expected the key to be a string.");

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one object.");
}

- (void) testSearchKeysAddedAfterCalendarDate {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:-(60 * 60)];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSArray *searchResults = [search searchObjectsAdded:NSFAfterDate date:date returnType:NSFReturnKeys error:nil];

  XCTAssertTrue (([[searchResults lastObject]isKindOfClass:NSString.class
  ]), @"Expected the key to be a string.");

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 2), @"Expected to find two objects.");
}

- (void) testSearchKeysAddedAfterCalendarDateFilterByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:-(60 * 60)];

  NSArray *searchResults = [search searchObjectsAdded:NSFAfterDate date:date returnType:NSFReturnKeys error:nil];

  XCTAssertTrue (([[searchResults lastObject]isKindOfClass:NSString.class
  ]), @"Expected the key to be a string.");

  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one object.");
}

#pragma mark -

- (void) testSearchExecuteNilSQL {

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];

  @try {
    [search executeSQL:nil returnType:NSFReturnObjects error:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testSearchExecuteEmptySQL {

  nanoStore = [NSFNanoStore createStoreWithType:NSFMemoryStoreType path:nil];
  search = [NSFNanoSearch searchWithStore:nanoStore];

  @try {
    [search executeSQL:@"" returnType:NSFReturnObjects error:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testSearchExecuteSQLWithWrongColumnTypes {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSDictionary *results = [search executeSQL:@"SELECT Blah, Foo, Bar FROM NSFKeys" returnType:NSFReturnObjects error:nil];

  XCTAssertTrue ([results count] == 2, @"Expected to find two objects.");
}

- (void) testSearchExecuteSQL {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSDictionary *result = [search executeSQL:@"SELECT * FROM NSFKEYS" returnType:NSFReturnObjects error:nil];

  XCTAssertTrue ([result count] == 2, @"Expected to find two objects.");
}

- (void) testSearchExecuteSQLCountKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSFNanoResult *result = [search executeSQL:@"SELECT COUNT(*) FROM NSFKEYS"];
  XCTAssertTrue ([result error] == nil, @"We didn't expect an error.");

  XCTAssertTrue (([result numberOfRows] == 1) && ([[result firstValue]isEqualToString:@"2"]), @"Expected to find one object containing the value '2'.");
}

- (void) testSearchExecuteBadSQLCountKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  NSFNanoResult *result = [nanoStore _executeSQL:@"SELECT COUNT FROM NSFKEYS"];

  BOOL containsErrorInfo = ([result error] != nil);

  XCTAssertTrue (containsErrorInfo == YES, @"Expected to find error information.");
}

- (void) testSearchExecuteSQLReturningKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSArray *result = [search executeSQL:@"SELECT * FROM NSFKEYS" returnType:NSFReturnKeys error:nil];

  XCTAssertTrue ([result isKindOfClass:NSArray.class
  ], @"Incorrect class returned. Expected NSArray.");
  XCTAssertTrue ([result count] == 2, @"Expected to find two objects.");
}

- (void) testSearchExecuteSQLReturningObjects {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSDictionary *result = [search executeSQL:@"SELECT * FROM NSFKEYS" returnType:NSFReturnObjects error:nil];

  XCTAssertTrue ([result isKindOfClass:NSDictionary.class
  ], @"Incorrect class returned. Expected NSArray.");
  XCTAssertTrue ([result count] == 2, @"Expected to find two objects.");
}

- (void) testSearchReturningObjectsOfClassNSFNanoObject {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  id theObject = searchResults[obj1.key];
  //    BOOL isClassCorrect = [isKindOfClass:[]];
  [nanoStore closeWithError:nil];
  XCTAssertTrue (searchResults.count == 2, @"Expected 2 results.");
  XCTAssertTrue([theObject isKindOfClass:NSFNanoObject.class], @"Got a %@. Expected to find two objects of type NSFNanoObject. ", NSStringFromClass([theObject class]));
}

- (void) testSearchReturningObjectsWithCalendarDateOfClassNSFNanoObject {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObjectsFromArray:@[obj1, obj2] error:nil];

  NSDate *date = [[NSDate date]dateByAddingTimeInterval:5];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsAdded:NSFBeforeDate date:date returnType:NSFReturnObjects error:nil];
  BOOL isClassCorrect = [searchResults[obj1.key]isKindOfClass:NSFNanoObject.class
  ];
  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 2) && isClassCorrect, @"Expected to find two objects of type NSFNanoObject.");
}

- (void) testSearchFilteringResultsByClassReturnObjects {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  BOOL isClassCorrect = [searchResults[car.key]isKindOfClass:NanoCarTestClass.class];
  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1) && isClassCorrect, @"Expected to find one object of type NanoCarTestClass.");
}

- (void) testSearchFilteringResultsByClassReturnKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"kName";
  search.match = NSFEqualTo;
  search.value = @"Mercedes";
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];
  BOOL isClassCorrect = [[searchResults lastObject]isEqualToString:car.key];
  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1) && isClassCorrect, @"Expected to find one object of type NanoCarTestClass.");
}

- (void) testSearchWithExpressionAndFilteringObjectResultsByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  NSFNanoPredicate *predicateAttr = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"kName"];
  NSFNanoPredicate *predicateVal  = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Mercedes"];
  NSFNanoExpression *expression   = [NSFNanoExpression expressionWithPredicate:predicateAttr];
  [expression addPredicate:predicateVal withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression]];
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object");

  BOOL isClassCorrect = [searchResults[car.key] isKindOfClass:NanoCarTestClass.class
  ];
  [nanoStore closeWithError:nil];
  XCTAssertTrue (isClassCorrect, @"Expected to find type NanoCarTestClass.");
}

- (void) testSearchWithExpressionAndFilteringKeyResultsByClass {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Mercedes";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[car, person] error:nil];

  NSFNanoPredicate *predicateAttr = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"kName"];
  NSFNanoPredicate *predicateVal  = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Mercedes"];
  NSFNanoExpression *expression   = [NSFNanoExpression expressionWithPredicate:predicateAttr];
  [expression addPredicate:predicateVal withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression]];
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object");

  BOOL isClassCorrect = [[searchResults lastObject]isEqualToString:car.key];
  [nanoStore closeWithError:nil];
  XCTAssertTrue (isClassCorrect, @"Expected to find type NanoCarTestClass.");
}

#pragma mark -

- (void) testSearchObjectKnownInThisProcess {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObject:obj1 error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");

  id objectReturned = searchResults[[[searchResults allKeys]lastObject]];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([objectReturned isKindOfClass:NSFNanoObject.class
  ] == YES) && (nil == [objectReturned originalClassString]), @"Expected to retrieve a pure NanoObject.");
}

- (void) testSearchObjectNotKnownInThisProcess {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObject:obj1 error:nil];

  // Hack to change the class name in the store placing a bogus one...
  NSString *bogusClassName = @"foobar";
  NSString *obj1Key = obj1.key;
  NSString *theSQLStatement = [NSString stringWithFormat:@"UPDATE NSFKeys SET NSFObjectClass ='%@' WHERE NSFKey='%@'", bogusClassName, obj1Key];
  [nanoStore _executeSQL:theSQLStatement];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");

  id objectReturned = searchResults[[[searchResults allKeys]lastObject]];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([objectReturned isKindOfClass:NSFNanoObject.class
  ] == YES) && ([[objectReturned originalClassString]isEqualToString:bogusClassName]), @"Expected to retrieve a NanoObject which an original class name of type 'foobar'.");
}

- (void) testSearchObjectNotKnownInThisProcessEditAndSave {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObject:obj1 error:nil];

  // Hack to change the class name in the store placing a bogus one...
  NSString *bogusClassName1 = @"foobar";
  NSString *obj1Key = obj1.key;
  NSString *theSQLStatement = [NSString stringWithFormat:@"UPDATE NSFKeys SET NSFObjectClass ='%@' WHERE NSFKey='%@'", bogusClassName1, obj1Key];
  [nanoStore _executeSQL:theSQLStatement];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");

  // Make sure we have a NanoObject of class foobar
  NSFNanoObject *objectReturned = searchResults[[[searchResults allKeys]lastObject]];
  XCTAssertTrue (([objectReturned isKindOfClass:NSFNanoObject.class
  ] == YES) && ([[objectReturned originalClassString]isEqualToString:bogusClassName1]), @"Expected to retrieve a NanoObject which an original class name of type 'foobar'.");

  // Now, let's manipulate the original class name to make sure it gets honored and saved properly
  NSString *bogusClassName2 = @"superduper";
  [objectReturned removeAllObjects];
  [objectReturned setObject:@"fooValue" forKey:@"fooKey"];
  [objectReturned _setOriginalClassString:bogusClassName2];
  [nanoStore addObject:objectReturned error:nil];

  searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");

  // Make sure the saving process honored the foobar class and didn't overwrite it with NSFNanoObject
  objectReturned = searchResults[[[searchResults allKeys]lastObject]];
  XCTAssertTrue (([objectReturned isKindOfClass:NSFNanoObject.class
  ] == YES) && ([[objectReturned originalClassString]isEqualToString:bogusClassName2]), @"Expected to retrieve a NanoObject which an original class name of type 'superduper'.");

  [nanoStore closeWithError:nil];
}

#pragma mark -

- (void) testAggregateFunctions {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];

  NSFNanoBag *bag = [NSFNanoBag bag];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];
  [nanoStore addObjectsFromArray:@[bag] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  XCTAssertTrue ([[search aggregateOperation:NSFAverage onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFAverage to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFCount onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFCount to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFMax onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFMax to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFMin onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFMin to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFTotal onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFTotal to return a valid number.");
}

- (void) testAggregateFunctionsWithFilters {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:[NSFNanoStore _defaultTestData]];

  NSFNanoBag *bag = [NSFNanoBag bag];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];
  [nanoStore addObjectsFromArray:@[bag] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"LastName";
  search.match = NSFEqualTo;
  search.value = @"Ciuro";

  XCTAssertTrue ([[search aggregateOperation:NSFAverage onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFAverage to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFCount onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFCount to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFMax onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFMax to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFMin onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFMin to return a valid number.");
  XCTAssertTrue ([[search aggregateOperation:NSFTotal onAttribute:@"SomeNumber"]floatValue] != 0, @"Expected NSFTotal to return a valid number.");
}

#pragma mark -

- (void) testExplainSQLNil {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  @try {
    [search explainSQL:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testExplainSQLEmpty {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];

  @try {
    [search explainSQL:@""];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testExplainSQLBogus {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSFNanoResult *results = [search explainSQL:@"foo bar"];
  XCTAssertTrue (([results error] != nil) && ([results numberOfRows] == 0), @"Expected an error and no rows back.");
}

- (void) testExplainSQL {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSFNanoResult *results = [search explainSQL:@"SELECT * FROM NSFKeys WHERE NSFKey = 'ABC'"];
  XCTAssertTrue (([results error] == nil) && ([results numberOfRows] > 0), @"Expected some rows back.");
}

- (void) testSearchTestFTS3 {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  NSFNanoResult *results = [search executeSQL:@"CREATE VIRTUAL TABLE simple USING fts3(tokenize=simple);"];

  BOOL isLioniOS5OrLater = ((_systemVersion >= 10.7f) || (_systemVersion >= 5.1f));

  XCTAssertTrue (isLioniOS5OrLater && ([results error] == nil), @"Wasn't expecting an error.");
}

- (void) testSearchObjectsQuotes {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Leo'd";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[person] error:nil];

  NSArray* allPeople = [nanoStore objectsOfClassNamed:NSStringFromClass(NanoPersonTestClass.class)];
  XCTAssertTrue(([allPeople count] == 1), @"Should have one person");

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = NanoPersonFirst;
  search.match = NSFEqualTo;
  search.value = person.name;

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];
  [nanoStore closeWithError:nil];

  XCTAssertTrue ((searchResults.count == 1), @"Expected to find one person object, found %lu",searchResults.count);
}

- (void) testSearchObjectsQuotesUsingExpression {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NanoPersonTestClass *person = NanoPersonTestClass.new;
  person.name = @"Leo'd";
  person.last = @"Doe";

  [nanoStore addObjectsFromArray:@[person] error:nil];

  NSFNanoObject *obj = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [nanoStore addObject:obj error:nil];

  NSFNanoPredicate *firstNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:NanoPersonFirst];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:person.name];
  NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:firstNamePred];
  [expression addPredicate:valuePred withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression]];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

#pragma mark -

- (void) testSearchWithNullValue {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  NSDictionary *info = @{@"name" : @"foo", @"last" : NSNull.null};
  NSFNanoObject *personBObj = [NSFNanoObject nanoObjectWithDictionary:info];
  [nanoStore addObjectsFromArray:@[personA, personBObj] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.match = NSFEqualTo;
  search.value = NSNull.null;

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
  XCTAssertTrue ([personBObj objectForKey:@"last"] == NSNull.null, @"Expected to find the NSNull object.");
}

- (void) testSearchWithAttributeHasNullValue {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  NSDictionary *info = @{@"name" : @"foo", @"last" : NSNull.null};
  NSFNanoObject *personBObj = [NSFNanoObject nanoObjectWithDictionary:info];
  [nanoStore addObjectsFromArray:@[personA, personBObj] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute = @"last";
  search.match = NSFEqualTo;
  search.value = NSNull.null;

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
  XCTAssertTrue ([personBObj objectForKey:@"last"] == NSNull.null, @"Expected to find the NSNull object.");
}

- (void) testSearchWithAttributeDoesNotHaveNullValue {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  NSDictionary *info = @{NanoPersonFirst : @"foo", NanoPersonLast : NSNull.null};
  NSFNanoObject *personBObj = [NSFNanoObject nanoObjectWithDictionary:info];

  [nanoStore addObjectsFromArray:@[personA, personBObj] error:nil];

  search            = [NSFNanoSearch searchWithStore:nanoStore];
  search.attribute  = NanoPersonLast;
  search.match      = NSFNotEqualTo;
  search.value      = NSNull.null;

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  NanoPersonTestClass *retrievedObject = searchResults.allValues.lastObject;

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
  XCTAssertTrue ([retrievedObject isKindOfClass:NanoPersonTestClass.class], @"Expected to find a NanoPersonTestClass object.");
  XCTAssertTrue ([retrievedObject.last isEqualToString:@"Doe"], @"Expected to find the non-NSNull object.");
}

- (void) testSearchWithNullValuePredicate {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  NSDictionary *info = @{@"name" : @"foo", @"last" : NSNull.null};
  NSFNanoObject *personBObj = [NSFNanoObject nanoObjectWithDictionary:info];
  [nanoStore addObjectsFromArray:@[personA, personBObj] error:nil];

  NSFNanoPredicate *lastNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"last"];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:NSNull.null];
  NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:lastNamePred];
  [expression addPredicate:valuePred withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression]];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
  XCTAssertTrue ([personBObj objectForKey:@"last"] == NSNull.null, @"Expected to find the NSNull object.");
}

- (void) testSearchDoesNotHaveNullValuePredicate {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  NSDictionary *info = @{NanoPersonFirst : @"foo", NanoPersonLast : NSNull.null};
  NSFNanoObject *personBObj = [NSFNanoObject nanoObjectWithDictionary:info];
  [nanoStore addObjectsFromArray:@[personA, personBObj] error:nil];

  NSFNanoPredicate *lastNamePred = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:NanoPersonLast];
  NSFNanoPredicate *valuePred = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFNotEqualTo value:NSNull.null];
  NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:lastNamePred];
  [expression addPredicate:valuePred withOperator:NSFAnd];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  [search setExpressions:@[expression]];

  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];

  [nanoStore closeWithError:nil];

  NanoPersonTestClass *retrievedObject = [[searchResults allValues]lastObject];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
  XCTAssertTrue ([retrievedObject isKindOfClass:NanoPersonTestClass.class
  ], @"Expected to find a NanoPersonTestClass object.");
  XCTAssertTrue ([[retrievedObject last]isEqualToString:@"Doe"], @"Expected to find the non-NSNull object.");
}

- (void) testSearchFilterClassWithLimitReturnObjects {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new, personB = NanoPersonTestClass.new;

  personA.name = @"Leo'd";
  personA.last = @"Doe";

  personB.name = @"Titus";
  personB.last = @"Magnus";

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  [nanoStore addObjectsFromArray:@[personA, personB] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.filterClass = NSStringFromClass(NanoPersonTestClass.class);
  search.limit = 2;

  NSError *error = nil;
  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];

  XCTAssertTrue (searchResults.count == 2, @"Expected to find two objects.");
}

- (void) testSearchFilterClassWithNoLimitReturnObjects {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new, personB = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  personB.name = @"Titus";
  personB.last = @"Magnus";

  car = NanoCarTestClass.new;
  car.name     = @"Mercedes";
  car.key      = NSFNanoEngine.stringWithUUID;

  [nanoStore addObjectsFromArray:@[personA, personB, car] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSError *error = nil;
  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

- (void) testSearchFilterClassWithLimitReturnKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new, personB = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  personB.name = @"Titus";
  personB.last = @"Magnus";

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  [nanoStore addObjectsFromArray:@[personA, personB] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.filterClass = NSStringFromClass(NanoPersonTestClass.class);
  search.limit = 2;

  NSError *error = nil;
  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:&error];

  XCTAssertTrue (searchResults.count == 2, @"Expected to find two objects.");
}

- (void) testSearchFilterClassNoLimitReturnKeys {

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  personA = NanoPersonTestClass.new;
  personA.name = @"Leo'd";
  personA.last = @"Doe";

  personB = NanoPersonTestClass.new;
  personB.name = @"Titus";
  personB.last = @"Magnus";

  car = NanoCarTestClass.new;
  car.name = @"Mercedes";
  car.key = NSFNanoEngine.stringWithUUID;

  [nanoStore addObjectsFromArray:@[personA, personB, car] error:nil];

  search = [NSFNanoSearch searchWithStore:nanoStore];
  search.filterClass = NSStringFromClass(NanoCarTestClass.class);

  NSError *error = nil;
  NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:&error];

  XCTAssertTrue (searchResults.count == 1, @"Expected to find one object.");
}

@end