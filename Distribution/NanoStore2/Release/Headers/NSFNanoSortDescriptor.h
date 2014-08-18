/*
     NSFNanoSortDescriptor.h
     NanoStore
     	*/

#import <Foundation/Foundation.h>

#import "NSFNanoGlobals.h"

/*! @file NSFNanoSortDescriptor.h
 @brief A unit that describes a sort to be used in conjunction with a search operation.	*/

/** @class NSFNanoSortDescriptor
 * A unit that describes a sort to be used in conjunction with a search operation.
 * @details <b>Example:</b>
 @code
 // Instantiate a NanoStore and open it
 NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
 [nanoStore removeAllObjectsFromStoreAndReturnError:nil];
 
 NSFNanoObject *obj1 = [NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObject:@"Madrid" forKey:@"City"]];
 NSFNanoObject *obj2 = [NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObject:@"Barcelona" forKey:@"City"]];
 NSFNanoObject *obj3 = [NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObject:@"San Sebastian" forKey:@"City"]];
 NSFNanoObject *obj4 = [NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObject:@"Zaragoza" forKey:@"City"]];
 NSFNanoObject *obj5 = [NSFNanoObject nanoObjectWithDictionary:[NSDictionary dictionaryWithObject:@"Tarragona" forKey:@"City"]];
 
 [nanoStore addObjectsFromArray:[NSArray arrayWithObjects:obj1, obj2, obj3, obj4, obj5, nil] error:nil];
 
 // Prepare the sort descriptor
 NSFNanoSortDescriptor *sortCities = [[NSFNanoSortDescriptor alloc]initWithAttribute:@"City" ascending:YES];
 
 // Prepare the search
 NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
 search.sort = [NSArray arrayWithObjects: sortCities, nil];
 
 // Perform the search
 NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
 STAssertTrue ([searchResults count] == 5, @"Expected to find five objects.");
 STAssertTrue ([[[[searchResults objectAtIndex:0]info]objectForKey:@"City"]isEqualToString:@"Barcelona"], @"Expected to find Barcelona.");
 
 for (NSFNanoObject *object in searchResults) {
 NSLog(@"%@", [[object info]objectForKey:@"City"]);
 }
 
 // Cleanup
 [sortCities release];
 
 // Close the document store
 [nanoStore closeWithError:nil];
 @endcode	*/

@interface NSFNanoSortDescriptor : NSObject

/** * The property key to use when performing a comparison */
@property (nonatomic, copy, readonly) NSString *attribute;
/** * The property to indicate whether the comparison should be performed in ascending mode */
@property (nonatomic, readonly) BOOL isAscending;

/** @name Creating and Initializing Expressions	*/

/** * Creates and returns an sort descriptor with the specified key and ordering.
 * @param theKey the property key to use when performing a comparison. Must not be nil or empty.
 * @param ascending YES if the sort descriptor specifies sorting in ascending order, otherwise NO.
 * @return A sort descriptor initialized with the specified key and ordering.
 * @warning The parameter theKey must not be nil.
 * @throws NSFUnexpectedParameterException is thrown if the key is nil.
 * @see \link initWithKey:ascending: - (id)initWithKey:(NSString *)theKey ascending:(BOOL)ascending \endlink	*/

+ (NSFNanoSortDescriptor *)sortDescriptorWithAttribute:(NSString *)theAttribute ascending:(BOOL)ascending;

/** * Initializes a newly allocated sort descriptor with the specified key and ordering.
 * @param theKey the property key to use when performing a comparison. Must not be nil or empty.
 * @param ascending YES if the sort descriptor specifies sorting in ascending order, otherwise NO.
 * @return A sort descriptor initialized with the specified key and ordering.
 * @warning The parameter theKey must not be nil.
 * @throws NSFUnexpectedParameterException is thrown if the key is nil.
 * @see \link sortDescriptorWithKey:ascending: - (NSFNanoSortDescriptor *)sortDescriptorWithKey:(NSString *)theKey ascending:(BOOL)ascending \endlink	*/

- (id)initWithAttribute:(NSString *)theAttribute ascending:(BOOL)ascending;

/** @name Miscellaneous	*/

/** * Returns a string representation of the sort.
 * @note Check properties attribute and isAscending to find out the current state of the sort.	*/

@property (readonly, copy) NSString *description;

/** Returns a JSON representation of the sort.
 * @note Check properties attribute and isAscending to find out the current state of the sort.
 */

@property (readonly, copy) NSString *JSONDescription;

@end
