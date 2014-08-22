

#import "NanoStore.h"

@interface      User : NSMObject
@property   NSString * name;
@property   NSNumber * age;
@property   NSString * socialNetworkNickname;
@property     NSDate * createdAt;
@property NSFNanoBag * cars,
                     * soldCars;
@end

@implementation User @dynamic name, age, createdAt, cars,  socialNetworkNickname, soldCars; @end

@interface       Car : NSMObject
@property   NSString * name;
@property   NSNumber * x;
@end
@implementation Car @dynamic name, x; @end

@interface NSFNanoObjectTests : XCTestCase {

  NSFNanoStore *nanoStore;
  User *user; Car *car;
}
@end
@implementation NSFNanoObjectTests

- (void) setUp { [super setUp];

  nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
       user = (User*) [User model];
}

- (void) testAttributes {


  XCTAssertTrue([user respondsToSelector:@selector(name)], @"should create getter and setters");
  XCTAssertTrue([user respondsToSelector:@selector(setName:)], @"should create getter and setters");

  NSDate *now = [NSDate date];
  user.name = @"Joe";
  user.age = @30;
  user.createdAt = now;

  User* user2 = (User*) [User modelWithDictionary:user.nanoObjectDictionaryRepresentation];

  XCTAssertTrue([user.name isEqualToString:user2.name], @"expect(user2.age).to.equal(user.age)");
  XCTAssertTrue([user.createdAt isEqual:user2.createdAt], @"");

  // single character attribute
  car = [Car modelWithDictionary:@{@"x": @10}];
  XCTAssertEqual(car.x, @10, @"");
  car.x = @11;
  XCTAssertEqual(car.x, @11, @"");


  user = (User*) [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            user.name = nil;
  XCTAssertNil(user.name, @"should accept nil in getter");
  XCTAssertEqual(user.age,@20, @"");

  user = [User modelWithDictionary:@{@"socialNetworkNickname": @"jonny"}];
  XCTAssertTrue([user.socialNetworkNickname isEqualToString:@"jonny"], @"should use attribute with camel case");
  user.socialNetworkNickname = @"jonn";
  XCTAssertTrue([user.socialNetworkNickname isEqualToString:@"jonn"], @"");
}
/*
- (void) testBags {
        it(@"should create bags getter and setters", ^{
            User* user = [User model];
            user.name = @"Joe";
            expect([user respondsToSelector:@selector(cars)]).to.beTruthy();
            expect([user respondsToSelector:@selector(setCars:)]).to.beTruthy();

            NSFNanoBag* theBag = [NSFNanoBag bagWithName:@"hello"];
            user.cars = theBag;

            expect(user.cars.key).to.equal(theBag.key);
            expect([user nanoObjectDictionaryRepresentation][@"cars"]).to.equal(theBag.key);
        });
        
        it(@"should accept nil in getter", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @20}];
            user.name = nil;
            expect(user.name).to.beNil();
            expect(user.age).to.equal(@20);
        });
        
        it(@"should use bags with camel case", ^{
            User* user = [User modelWithDictionary:@{@"socialNetworkNickname": @"jonny"}];
            NSFNanoBag* theBag = [NSFNanoBag bagWithName:@"hello"];
            user.soldCars = theBag;
            expect(user.soldCars.key).to.equal(theBag.key);

}
- (void) testPersistence {

        it(@"should save attributes and bags", ^{
            User* user = [User modelWithDictionary:@{@"name": @"Joe", @"age": @18, @"createdAt": [NSDate date]}];
            user.cars = [NSFNanoBag bagWithName:@"hello"];
            [nanoStore addObject:user error:nil];
            [nanoStore addObject:user.cars error:nil];
            [nanoStore saveStoreAndReturnError:nil];

            NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
            search.attribute = @"name";
            search.match = NSFEqualTo;
            search.value = @"Joe";

            // Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
            NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
            NSArray* users = [searchResults allValues];
            expect(users).haveCountOf(1);

            User* user2 = [users objectAtIndex:0];
            expect(user2.key).to.equal(user.key);
            expect(user2.name).to.equal(user.name);
            expect(user2.age).to.equal(user.age);
            expect(user2.createdAt).to.equal(user.createdAt);
            expect(user2.cars.key).to.equal(user.cars.key);
            expect([user2 nanoObjectDictionaryRepresentation][@"cars"]).to.equal(user.cars.key);

}
- (void) testKVO: {
        it(@"should notify KVO observer", ^{
            UserObserver* observer = [UserObserver.alloc init];
            User* user = (User*) [User model];
            [user addObserver:observer
                   forKeyPath:@"name"
                      options:NSKeyValueObservingOptionNew
                      context:nil];

            user.name = @"Jone";
            expect(observer.notified).to.beTruthy();
            [user removeObserver:observer forKeyPath:@"name"];
        });
    });


_defaultTestInfo = NSFNanoStore._defaultTestData; NSFSetIsDebugOn (NO); }
*/

- (void) tearDown { [super tearDown]; [nanoStore closeWithError:nil]; }

//_defaultTestInfo = nil; NSFSetIsDebugOn (NO); [super tearDown];

//- (void) testCheckDebugOn  { NSFSetIsDebugOn (YES); XCTAssertTrue (NSFIsDebugOn(), @"Expected isDebugOn to be YES."); }


@end
