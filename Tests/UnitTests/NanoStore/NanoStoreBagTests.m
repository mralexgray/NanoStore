//
//  NanoStoreBagTests.m
//  NanoStore
//
//  Created by Tito Ciuro on 10/15/10.
//  Copyright (c) 2013 Webbo, Inc. All rights reserved.
//

#import "NanoStore.h"
#import "NSFNanoBag.h"
#import "NSFNanoGlobals_Private.h"
#import "NSFNanoStore_Private.h"
#import "NanoCarTestClass.h"

@interface NanoStoreBagTests : XCTestCase {

  NSDictionary *_defaultTestInfo;
  NSFNanoBag * bag;
}
@end

@implementation NanoStoreBagTests

- (void) setUp { [super setUp];

  _defaultTestInfo = NSFNanoStore._defaultTestData;
  bag = NSFNanoBag.bag;
  NSFSetIsDebugOn (NO);
}

- (void) tearDown { NSFSetIsDebugOn (NO); [super tearDown]; }

- (void) testBagClassMethod { NSString * key; NSArray * returnedKeys;

  XCTAssertTrue (bag.hasUnsavedChanges, @"");
  XCTAssertTrue (!!(         key = bag.key) && key.length, @"");
  XCTAssertTrue (!!(returnedKeys = bag.dictionaryRepresentation[NSF_Private_NSFNanoBag_NSFObjectKeys]) && !returnedKeys.count, @"Expected the bag to be properly initialized.");
}

- (void) testBagDescription {

  XCTAssertTrue ((bag.description.length > 0), @"Expected to obtain the bag description.");
}

- (void) testBagEqualToSelf {

  XCTAssertTrue (([bag isEqualToNanoBag:bag] == YES), @"Expected to test to be true.");
}

- (void) testBagForUUID {

  NSString *objectKey = bag.nanoObjectKey;
  XCTAssertTrue ((nil != objectKey) && ([objectKey length] > 0), @"Expected the bag to return a valid UUID.");

  bag = NSFNanoBag.new;
  objectKey = bag.nanoObjectKey;
  XCTAssertTrue ((nil != objectKey) && ([objectKey length] > 0), @"Expected the bag to return a valid UUID.");
}

- (void) testBagInitNilObjects {

  bag = nil;
  @try                    { bag = [NSFNanoBag bagWithObjects:nil]; }
  @catch (NSException *e) { XCTAssertTrue (e != nil, @"We should have caught the exception."); }
}

- (void) testBagSettingNameManually {

  XCTAssertTrue (nil == [bag name], @"Expected the name of the bag to be nil.");
  bag.name = @"FooBar";
  XCTAssertTrue ([bag hasUnsavedChanges], @"Expected the bag to have unsaved changes.");
  XCTAssertTrue (nil != [bag name], @"Expected the name of the bag to be hold a value.");
  bag.name = nil;
  XCTAssertTrue (nil == [bag name], @"Expected the name of the bag to be nil.");
}

- (void) testBagWithNameEmptyBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  bag = [NSFNanoBag bagWithName:@"FooBar"];
  XCTAssertTrue (nil != [bag name], @"Expected the name of the bag to not be nil.");

  NSError *error = nil;
  [nanoStore addObjectsFromArray:@[bag] error:&error];
  XCTAssertTrue (nil == error, @"Saving bag A should have succeded.");

  NSFNanoBag *retrievedBag = [nanoStore bagWithName:bag.name];
  XCTAssertTrue ([[retrievedBag name]isEqualToString:bag.name] == YES, @"We should have found the bag by name.");

  [nanoStore closeWithError:nil];
}

- (void) testBagWithNameBagNotEmpty {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];
  bag = [NSFNanoBag bagWithName:@"FooBar" andObjects:objects];
  XCTAssertTrue (nil != [bag name], @"Expected the name of the bag to be nil.");

  NSError *error = nil;
  [nanoStore addObjectsFromArray:@[bag] error:&error];
  XCTAssertTrue (nil == error, @"Saving bag A should have succeded.");

  NSFNanoBag *retrievedBag = [nanoStore bagWithName:bag.name];
  XCTAssertTrue ([[retrievedBag name]isEqualToString:bag.name] == YES, @"We should have found the bag by name.");

  [nanoStore closeWithError:nil];
}

- (void) testBagSearchByName {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  bag.name = @"FooBar";
  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSFNanoBag *retrievedBag = [nanoStore bagWithName:bag.name];
  XCTAssertTrue ([[retrievedBag name]isEqualToString:bag.name] == YES, @"We should have found the bag by name.");

  [nanoStore closeWithError:nil];
}

- (void) testBagInitEmptyListOfObjects {

  bag = [NSFNanoBag bagWithObjects:@[]];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;
  NSString *key = bag.key;
  NSArray *returnedKeys = [bag dictionaryRepresentation][NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && (nil != key) && ([key length] > 0) && (nil != returnedKeys) && ([returnedKeys count] == 0), @"Expected the bag to be properly initialized.");
}

- (void) testBagInitTwoConformingObjects {

  NSArray *objects = @[ [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                        [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithObjects:objects];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;
  NSString *key = bag.key;
  NSArray *returnedKeys = [bag dictionaryRepresentation][NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && (nil != key) && ([key length] > 0) && (nil != returnedKeys) && ([returnedKeys count] == 2), @"Expected the bag to contain two returnedKeys.");
}

- (void) testBagInitPartiallyConformingObjects {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      @"foo"];

  @try {
    [NSFNanoBag bagWithObjects:objects];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testBagEmptyDictionaryRepresentation {

  NSDictionary *info = [bag dictionaryRepresentation];
  NSString *key = info[NSF_Private_NSFNanoBag_NSFKey];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue ((nil != key) && ([key length] > 0) && (nil != returnedKeys) && ([returnedKeys count] == 0) && (nil != info) && ([info count] == 2), @"Expected the bag to provide a properly formatted dictionary.");
}

- (void) testBagWithTwoConformingObjectsDictionaryRepresentation {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithObjects:objects];
  NSDictionary *info = [bag dictionaryRepresentation];
  NSString *key = info[NSF_Private_NSFNanoBag_NSFKey];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue ((nil != key) && ([key length] > 0) && (nil != returnedKeys) && ([returnedKeys count] == 2) && (nil != info) && ([info count] == 2), @"Expected the bag to provide a properly formatted dictionary.");
}

- (void) testBagEmptyCount {

  XCTAssertTrue (0 == bag.count, @"Expected the bag to have zero elements.");
}

- (void) testBagCountTwo {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithObjects:objects];
  XCTAssertTrue (2 == bag.count, @"Expected the bag to have two elements.");
}

- (void) testTwoBagsWithSameName {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoBag *bag1 = [NSFNanoBag bagWithName:@"foo" andObjects:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]]];
  NSFNanoBag *bag2 = [NSFNanoBag bagWithName:@"foo" andObjects:@[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]]];
  [nanoStore addObjectsFromArray:@[bag1, bag2] error:nil];
  NSArray *bags = [nanoStore bagsWithName:@"foo"];
  XCTAssertTrue (2 == bags.count, @"Expected to find two bags.");

  [nanoStore closeWithError:nil];
}

- (void) testBagCountTwoDeleteOne {

  NSFNanoObject *objectOne = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSArray *objects = @[objectOne,
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithObjects:objects];
  XCTAssertTrue (2 == bag.count, @"Expected the bag to have two elements.");
  [bag removeObject:objectOne];
  XCTAssertTrue (1 == bag.count, @"Expected the bag to have one element.");
}

- (void) testBagCountAfterSaveEmpty {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  bag = [NSFNanoBag bagWithName:@"CountTest"];
  [nanoStore addObjectsFromArray:@[bag] error:nil];
  NSFNanoBag *receivedBag = [nanoStore bagWithName:@"CountTest"];
  XCTAssertTrue (0 == receivedBag.count, @"Expected the bag to have zero elements.");

  [nanoStore closeWithError:nil];
}

- (void) testBagCountAfterSaveTwoObjectsDeleteOne {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *objectOne = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSArray *objects = @[objectOne,
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithName:@"CountTest" andObjects:objects];
  [nanoStore addObjectsFromArray:@[bag] error:nil];
  NSFNanoBag *receivedBag = [nanoStore bagWithName:@"CountTest"];
  XCTAssertTrue (2 == receivedBag.count, @"Expected the bag to have two elements.");
  [receivedBag removeObject:objectOne];
  XCTAssertTrue (1 == receivedBag.count, @"Expected the bag to have one element.");

  [nanoStore closeWithError:nil];
}

- (void) testBagCountRemoveAll {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  bag = [NSFNanoBag bagWithObjects:objects];
  XCTAssertTrue (2 == bag.count, @"Expected the bag to have two elements.");
  [bag removeAllObjects];
  XCTAssertTrue (0 == bag.count, @"Expected the bag to have zero elements.");
}


- (void) testBagAddNilObject
{

  @try {
    NSError *outError = nil;
    [bag addObject:nil error:&outError];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testBagAddNonConformingObject
{

  @try {
    [bag addObject:(id)@"foo" error:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testBagAddConformingObject {

  NSError *outError = nil;
  BOOL success = [bag addObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo] error:&outError];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && success && (nil == outError) && (nil != returnedKeys) && ([returnedKeys count] == 1), @"Adding a conforming object to a bag should have succeeded.");
}

- (void) testBagAddNilObjectList {

  NSError *outError = nil;
  BOOL success = [bag addObjectsFromArray:nil error:&outError];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && (NO == success) && (nil != outError) && (nil != returnedKeys) && ([returnedKeys count] == 0), @"Adding a nil object list to a bag should have failed.");
}

- (void) testBagAddWithEmptyObjectList {

  NSError *outError = nil;
  BOOL success = [bag addObjectsFromArray:@[] error:&outError];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && success && (nil == outError) && (nil != returnedKeys) && ([returnedKeys count] == 0), @"Adding an empty object list to a bag should have failed.");
}

- (void) testBagAddTwoConformingObjects {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];

  NSError *outError = nil;
  BOOL success = [bag addObjectsFromArray:objects error:&outError];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && success && (nil == outError) && (nil != returnedKeys) && ([returnedKeys count] == 2), @"Adding a conforming object list to a bag should have succeded.");
}

- (void) testBagAddTwoNSObjectsConformingToProtocol {

  id car1 = [NanoCarTestClass.alloc initNanoObjectFromDictionaryRepresentation:@{@"kName" : @"XJ-7"} forKey:NSFNanoEngine.stringWithUUID store:nil];
  id car2 = [NanoCarTestClass.alloc initNanoObjectFromDictionaryRepresentation:@{@"kName" : @"Jupiter 8"} forKey:NSFNanoEngine.stringWithUUID store:nil];

  NSArray *objects = @[car1, car2];

  NSError *outError = nil;
  BOOL success = [bag addObjectsFromArray:objects error:&outError];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag nanoObjectDictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (success, @"expected bag to have saved");
  XCTAssertTrue (hasUnsavedChanges, @"expected bag to have no unsaved changes");
  XCTAssertNil (outError, @"expect bag to return no error on save");
  XCTAssertTrue ([returnedKeys count]== [objects count], @"expected saved bag to return %lu object keys", [objects count]);
}


- (void) testBagAddPartiallyConformingObjects {

  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo],
                      @"foo"];


  @try {
    [bag addObjectsFromArray:objects error:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}


- (void) testBagRemoveNilObject
{

  [bag addObject:[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo] error:nil];

  @try {
    [bag removeObject:nil];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testBagRemoveNonConformingObject
{

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObject:obj1 error:nil];

  @try {
    [bag removeObject:(id)@"foo"];
  } @catch (NSException *e) {
    XCTAssertTrue (e != nil, @"We should have caught the exception.");
  }
}

- (void) testBagRemoveOneConformingObject
{

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2] error:nil];
  [bag removeObject:obj1];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];
  NSString *returnedKey = [returnedKeys lastObject];

  XCTAssertTrue (hasUnsavedChanges && (nil != returnedKeys) && ([returnedKeys count] == 1) && ([returnedKey isEqualToString:obj2.key]), @"Removing a conforming object from a bag should have succeded.");
}

- (void) restBagRemoveWithEmptyListOfObjects
{

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2] error:nil];
  [bag removeObject:obj1];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];
  NSString *returnedKey = [returnedKeys lastObject];

  XCTAssertTrue (hasUnsavedChanges && (nil != returnedKeys) && ([returnedKeys count] == 1) && ([returnedKey isEqualToString:obj2.key]), @"Removing a conforming object from a bag should have succeded.");
}

- (void) testBagRemoveTwoConformingObjects
{

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSArray *objects = @[obj1, obj2];
  [bag addObjectsFromArray:objects error:nil];
  [bag removeObjectsInArray:objects];
  BOOL hasUnsavedChanges = bag.hasUnsavedChanges;

  NSDictionary *info = [bag dictionaryRepresentation];
  NSArray *returnedKeys = info[NSF_Private_NSFNanoBag_NSFObjectKeys];

  XCTAssertTrue (hasUnsavedChanges && (nil != returnedKeys) && ([returnedKeys count] == 0), @"Removing conforming objects from a bag should have succeded.");
}


- (void) testBagSaveEmptyBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];
  NSArray *bags = [nanoStore bags];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([bags count] == 1, @"Saving an empty bag should have succeded.");
}

- (void) testBagSaveBagWithThreeObjectsAssociatedToStore {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bags];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([[[bags lastObject]savedObjects]count] == 3, @"Saving a bag should have succeded.");
}

- (void) testBagSaveBagWithThreeObjectsNotAssociatedToStore {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bags];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([[[bags lastObject]savedObjects]count] == 3, @"Saving a bag should have succeded.");
}

- (void) testBagSaveBagRemovingObjects {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bags];
  NSFNanoBag *savedBag = [bags lastObject];
  [savedBag removeObjectsWithKeysInArray:@[obj1.key, obj2.key]];

  XCTAssertTrue (([bags count] == 1) && ([[savedBag savedObjects]count] == 1) && ([[savedBag unsavedObjects]count] == 0) && ([[savedBag removedObjects]count] == 2), @"Removing objects from a bag should have succeded.");

  NSError *outError = nil;
  [savedBag saveAndReturnError:&outError];
  XCTAssertTrue (nil == outError, @"Saving the bag failed. Reason: %@.", [outError localizedDescription]);

  savedBag = [[nanoStore bags]lastObject];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([[savedBag savedObjects]count] == 1) && ([[savedBag unsavedObjects]count] == 0) && ([[savedBag removedObjects]count] == 0), @"Removing objects from a bag should have succeded.");
}

- (void) testBagSaveBagEditingObjects {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObject:bag error:nil];

  NSArray *bags = [nanoStore bags];
  NSFNanoBag *savedBag = [bags lastObject];

  NSError *outError = nil;
  NSFNanoObject *editedObject = [[[savedBag savedObjects]allValues]lastObject];
  NSString *editedKey = editedObject.key;
  NSUInteger originalCount = editedObject.info.count;
  [editedObject setObject:@"fooValue" forKey:@"fooKey"];
  [savedBag addObject:editedObject error:&outError];
  XCTAssertTrue (([[savedBag savedObjects]count] == 2) && ([[savedBag unsavedObjects]count] == 1) && ([[savedBag removedObjects]count] == 0), @"Editing objects from a bag should have succeded.");

  [savedBag saveAndReturnError:&outError];
  XCTAssertTrue (nil == outError, @"Saving the bag failed. Reason: %@.", [outError localizedDescription]);

  savedBag = [[nanoStore bags]lastObject];
  [nanoStore closeWithError:nil];

  XCTAssertTrue (([[savedBag savedObjects]count] == 3), @"Expected savedObjects to have 3 elements.");
  XCTAssertTrue (([[savedBag unsavedObjects]count] == 0), @"Expected unsavedObjects to have 0 elements.");
  XCTAssertTrue (([[savedBag removedObjects]count] == 0), @"Expected removedObjects to have 0 elements.");
  XCTAssertTrue (([[[savedBag savedObjects][editedKey]info]count] == originalCount + 1), @"Editing objects from a bag should have succeded.");
}

- (void) testBagDeleteBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  NSError *outError = nil;
  [nanoStore addObjectsFromArray:@[bag] error:&outError];
  XCTAssertTrue (nil == outError, @"Could not save the bag. Reason: %@", [outError localizedDescription]);

  NSArray *savedBags = [nanoStore bags];
  NSString *keyToBeRemoved = [[savedBags lastObject]key];
  XCTAssertTrue (nil != keyToBeRemoved, @"The key of the bag to be removed cannot be nil.");

  [nanoStore removeObjectsWithKeysInArray:@[keyToBeRemoved] error:nil];

  NSArray *removedBags = [nanoStore bags];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([savedBags count] == 1) && [removedBags count] == 0, @"Removing a bag should have succeded.");
}

- (void) testBagReloadBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bags];
  NSFNanoBag *savedBagA = [bags lastObject];

  // Edit an object, replace it in savedBagA
  NSError *outError = nil;
  NSFNanoObject *editedObject = [[[savedBagA savedObjects]allValues]lastObject];
  [editedObject setObject:@"fooValue" forKey:@"fooKey"];
  [savedBagA addObject:editedObject error:&outError];
  XCTAssertTrue (([[savedBagA savedObjects]count] == 2) && ([[savedBagA unsavedObjects]count] == 1) && ([[savedBagA removedObjects]count] == 0), @"Editing objects from a bag should have succeded.");

  // Remove an object from savedBagA and save it
  [savedBagA removeObjectWithKey:obj1.key];
  BOOL success = [savedBagA saveAndReturnError:&outError];
  XCTAssertTrue (success && (nil == outError), @"Saving the bag should have succeded.");
  XCTAssertTrue (([[savedBagA savedObjects]count] == 2) && ([[savedBagA unsavedObjects]count] == 0) && ([[savedBagA removedObjects]count] == 0), @"Removing an object from a bag should have succeded.");

  bags = [nanoStore bags];
  NSFNanoBag *savedBagB = [bags lastObject];

  editedObject = [[[savedBagB savedObjects]allValues]lastObject];
  [editedObject setObject:@"fooValue" forKey:@"fooKey"];
  [savedBagB addObject:editedObject error:&outError];
  success = [savedBagB reloadBagWithError:&outError];
  XCTAssertTrue (success, @"The bad reload should have succeeded.");

  success = YES;
  NSArray *sortedArrayA = [[[savedBagA savedObjects]allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  NSArray *sortedArrayB = [[[savedBagB savedObjects]allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  if (NO == [sortedArrayA isEqualToArray:sortedArrayB]) {
    success = NO;
  }

  XCTAssertTrue ((NO == success), @"The bag comparison should have failed.");
  XCTAssertTrue (([[savedBagB savedObjects]count] == 1) && ([[savedBagB unsavedObjects]count] == 1) && ([[savedBagB removedObjects]count] == 0), @"Reloading the bag should have preserved the change.");

  [nanoStore closeWithError:nil];
}

- (void) testBagUndoUnsavedBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  NSError *outError = nil;
  [bag undoChangesWithError:&outError];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([[bag savedObjects]count] == 0) && ([[bag unsavedObjects]count] == 0) && ([[bag removedObjects]count] == 0), @"Undoing the changes of an unsaved bag should have succeded.");
}

- (void) testBagUndoSavedBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bags];
  NSFNanoBag *savedBag = [bags lastObject];

  NSError *outError = nil;
  NSFNanoObject *editedObject = [[[savedBag savedObjects]allValues]lastObject];
  [editedObject setObject:@"fooValue" forKey:@"fooKey"];
  [savedBag addObject:editedObject error:&outError];
  XCTAssertTrue (([[savedBag savedObjects]count] == 2) && ([[savedBag unsavedObjects]count] == 1) && ([[savedBag removedObjects]count] == 0), @"Editing objects from a bag should have succeded.");

  [savedBag undoChangesWithError:&outError];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([[savedBag savedObjects]count] == 3) && ([[savedBag unsavedObjects]count] == 0) && ([[savedBag removedObjects]count] == 0), @"Undoing the changes of a saved bag should have succeded.");
}

- (void) testBagSearchBagsWithKeys {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  NSError *outError = nil;
  [nanoStore removeAllObjectsFromStoreAndReturnError:&outError];

  NSFNanoBag *bag1 = [NSFNanoBag bag];
  NSArray *objects = @[[NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo]];
  [bag1 addObjectsFromArray:objects error:nil];

  NSFNanoBag *bag2 = [NSFNanoBag bag];
  [bag2 addObjectsFromArray:objects error:nil];

  [nanoStore addObjectsFromArray:@[bag1, bag2] error:nil];

  NSArray *savedBags = [nanoStore bags];
  XCTAssertTrue ([savedBags count] == 2, @"Expected to find two bags.");

  savedBags = [nanoStore bagsWithKeysInArray:@[bag1.key, bag2.key]];

  [nanoStore closeWithError:nil];

  XCTAssertTrue ([savedBags count] == 2, @"Expected to find bags by their key.");
}

- (void) testBagSearchBagsContainingObjectsWithKey {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

  NSError *outError = nil;
  [nanoStore removeAllObjectsFromStoreAndReturnError:&outError];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSArray *bags = [nanoStore bagsContainingObjectWithKey:obj3.key];

  [nanoStore closeWithError:nil];

  XCTAssertTrue (([bags count] == 1) && ([[[bags lastObject]key]isEqualToString:[bag key]]), @"Searching a bag containing a specific key should have succeded.");
}

- (void) testBagCopyBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];
  [nanoStore addObject:bag error:nil];

  NSFNanoBag *copiedBag = [bag copy];

  XCTAssertTrue (([bag isEqualToNanoBag:copiedBag]), @"Equality test should have succeeded.");
}

- (void) testBagIsEqualToNanoBag {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObject:bag error:nil];

  NSArray *bags = [nanoStore bags];
  NSFNanoBag *savedBagA = [bags lastObject];
  bags = [nanoStore bags];
  NSFNanoBag *savedBagB = [bags lastObject];

  XCTAssertTrue (([savedBagA isEqualToNanoBag:savedBagB]), @"Equality test should have succeeded.");

  NSError *outError = nil;
  NSFNanoObject *editedObject = [NSFNanoObject nanoObjectWithDictionary:@{@"fooKey": @"fooObject"}];
  [savedBagB addObject:editedObject error:&outError];

  XCTAssertTrue ((NO == [savedBagA isEqualToNanoBag:savedBagB]), @"Equality test should have failed.");

  [nanoStore closeWithError:nil];
}


- (void) testBagDeflate {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSFNanoBag *resultBag = [[nanoStore bags]lastObject];

  [resultBag deflateBag];

  NSDictionary *savedObjects = resultBag.savedObjects;
  BOOL deflated = YES;
  for (NSString *objectKey in savedObjects) {
    if (NSNull.null != savedObjects[objectKey]) {
      deflated = NO;
      break;
    }
  }

  [nanoStore closeWithError:nil];

  XCTAssertTrue (deflated, @"Expected the bag to be deflated.");
}

- (void) testBagInflate {

  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  [nanoStore removeAllObjectsFromStoreAndReturnError:nil];

  NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:_defaultTestInfo];
  [bag addObjectsFromArray:@[obj1, obj2, obj3] error:nil];

  [nanoStore addObjectsFromArray:@[bag] error:nil];

  NSFNanoBag *resultBag = [[nanoStore bags]lastObject];

  [resultBag deflateBag];
  [resultBag inflateBag];

  NSDictionary *savedObjects = resultBag.savedObjects;
  BOOL inflated = YES;
  for (NSString *objectKey in savedObjects) {
    if (NSNull.null == savedObjects[objectKey]) {
      inflated = NO;
      break;
    }
  }

  [nanoStore closeWithError:nil];

  XCTAssertTrue (inflated, @"Expected the bag to be inflated.");
}

@end
