//
//  NanoStoreExpressionTests.m
//  NanoStore
//
//  Created by Tito Ciuro on 3/30/08.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoStore.h"
#import "NSFNanoStore_Private.h"

@interface NanoStoreExpressionTests : XCTestCase
{
    NSDictionary *_defaultTestInfo;
}

@end

@implementation NanoStoreExpressionTests

- (void)setUp { [super setUp];
    
    _defaultTestInfo = [NSFNanoStore _defaultTestData];
    
    NSFSetIsDebugOn (NO);
}

- (void)tearDown
{
    
    NSFSetIsDebugOn (NO);
    
    [super tearDown];
}


- (void)testPredicateOnePredicateProperty
{
    NSFNanoPredicate *predicate = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicate];
    XCTAssertTrue (1 == expression.predicates.count, @"Expected to obtain one predicate.");
}

- (void)testPredicateTwoPredicatesProperty
{
    NSFNanoPredicate *predicate = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicate];
    NSFNanoPredicate *predicateTwo = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    [expression addPredicate:predicateTwo withOperator:NSFOr];
    XCTAssertTrue (2 == expression.predicates.count, @"Expected to obtain two predicates.");
}

- (void)testPredicateOneOperatorProperty
{
    NSFNanoPredicate *predicate = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicate];
    XCTAssertTrue (1 == expression.operators.count, @"Expected to obtain one operator.");
}

- (void)testPredicateTwoOperatorsProperty
{
    NSFNanoPredicate *predicate = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicate];
    NSFNanoPredicate *predicateTwo = [NSFNanoPredicate predicateWithColumn:NSFKeyColumn matching:NSFEqualTo value:@"foo"];
    [expression addPredicate:predicateTwo withOperator:NSFOr];
    XCTAssertTrue (2 == expression.operators.count, @"Expected to obtain two operators.");
}

- (void)testPredicateWithNilValue
{
    NSFNanoPredicate *predicate = nil;
    @try {
        predicate = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:nil];
    } @catch (NSException *e) {
        XCTAssertTrue (e != nil, @"We should have caught the exception.");
    }
}

- (void)testExpressionWithNilPredicate
{
    NSFNanoExpression *expression = nil;
    @try {
        expression = [NSFNanoExpression expressionWithPredicate:nil];
    } @catch (NSException *e) {
        XCTAssertTrue (e != nil, @"We should have caught the exception.");
    }
}

- (void)testEmptyExpressions
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"hello", @"name", nil]]] error:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"world", @"name", nil]]] error:nil];

    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray array]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    XCTAssertTrue ([searchResults count] == 2, @"Expected to find two objects.");
    
    searchResults = [search searchObjectsWithReturnType:NSFReturnKeys error:nil];
    XCTAssertTrue ([searchResults count] == 2, @"Expected to find two objects.");
    
    [nanoStore closeWithError:nil];
}

- (void)testOnePredicateOneExpressionEqualTo
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"FirstName"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionBeginsWith
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    BOOL success = [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    XCTAssertTrue (success, @"Expected to store the object.");

    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFBeginsWith value:@"First"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionContains
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFContains value:@"irs"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue (([searchResults count] == 1), @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionEndsWith
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEndsWith value:@"Name"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue (([searchResults count] == 1), @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionInsensitiveEqualTo
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFInsensitiveEqualTo value:@"LASTNamE"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionInsensitiveBeginsWith
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFInsensitiveBeginsWith value:@"FIrsT"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionInsensitiveContains
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFInsensitiveContains value:@"IrsT"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testOnePredicateOneExpressionInsensitiveEndsWith
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateFirstName = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFInsensitiveEndsWith value:@"NaMe"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateFirstName];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testTwoPredicatesOneExpression
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSFNanoPredicate *predicateAttribute = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"FirstName"];
    NSFNanoPredicate *predicateValue = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Tito"];
    NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateAttribute];
    [expression addPredicate:predicateValue withOperator:NSFAnd];
    
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    [search setExpressions:[NSArray arrayWithObject:expression]];
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    
    [nanoStore closeWithError:nil];
    
    XCTAssertTrue ([searchResults count] == 1, @"Expected to find one object.");
}

- (void)testSearchBetweenDatesSQLOne
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSError *error = nil;
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    NSDictionary *result = [search executeSQL:@"SELECT * FROM NSFKeys WHERE NSFKey IN (SELECT t1.NSFKey FROM NSFValues t1 INNER JOIN NSFValues t2 ON t1.NSFKey = t2.NSFKey WHERE t1.NSFAttribute = 'CreatedAt' AND t2.NSFAttribute = 'UpdatedAt' AND t1.NSFValue < t2.NSFValue)" returnType:NSFReturnObjects error:&error];
    XCTAssertNil(error, @"Did not expect an error. Got: %@", error);
    XCTAssertTrue ([result count] == 1, @"Expected to find one object.");
    
    [nanoStore closeWithError:nil];
}

- (void)testSearchBetweenDatesSQLTwo
{
    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
    [nanoStore addObjectsFromArray:[NSArray arrayWithObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]] error:nil];
    
    NSError *error = nil;
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    NSDictionary *result = [search executeSQL:@"SELECT * FROM NSFKeys WHERE NSFKey IN (SELECT o1.NSFKey FROM NSFValues o1 JOIN NSFValues o2 ON o1.NSFKey = o2.NSFKey WHERE o1.NSFAttribute = 'UpdatedAt' AND o2.NSFAttribute = 'CreatedAt' AND o1.NSFValue > o2.NSFValue)" returnType:NSFReturnObjects error:&error];
    XCTAssertNil(error, @"Did not expect an error. Got: %@", error);
    XCTAssertTrue ([result count] == 1, @"Expected to find one object.");
    
    [nanoStore closeWithError:nil];
}

@end
