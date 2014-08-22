/*
     NSFNanoObjectProtocol.h
     NanoStore
     
 */

/*! @file NSFNanoObjectProtocol.h
 @brief A protocol declaring the interface that objects interfacing with NanoStore must implement.
 */

/*!	@protocol NSFNanoObjectProtocol
    @abstract A protocol declaring the interface that objects interfacing with NanoStore must implement.
    @note Check NSFNanoBag or NSFNanoObject to see a concrete example of how NSFNanoObjectProtocol is implemented.
 */

@class NSFNanoStore;  @protocol NSFNanoObjectProtocol @required

/*! Initializes a newly allocated object containing a given key and value associated with a document store.
	@param theDictionary  the information associated with the object.
	@param aKey           the key associated with the information.
	@param theStore       the document store where the object is stored.
	@return               An initialized object upon success, nil otherwise.
	@details <b>Example:</b>  
  @code

 - initNanoObjectFromDictionaryRepresentation:(NSDictionary*)aDictionary forKey:(NSString*)aKey store:(NSFNanoStore*)aStore {

    return self = [self init] ? info = [aDictionary retain], key = [aKey copy], self : nil;
 }
 @endcode
 */

- initNanoObjectFromDictionaryRepresentation:(NSDictionary*)theDictionary forKey:(NSString*)aKey store:(NSFNanoStore*)theStore;

/*! Returns a dictionary that contains the information stored in the object.
	@see \link nanoObjectKey - (NSString*)nanoObjectKey \endlink
 */

@property (readonly) NSDictionary * nanoObjectDictionaryRepresentation;

/*! Returns the key associated with the object.
	@note
 * The class NSFNanoEngine contains a convenience method for this purpose: \ref NSFNanoEngine::stringWithUUID "+(NSString*)stringWithUUID"
 *
	@see \link nanoObjectDictionaryRepresentation - (NSDictionary*)nanoObjectDictionaryRepresentation \endlink
 */

@property (readonly) NSString * nanoObjectKey;

/*! Returns a reference to the object holding the private data or information that will be used for sorting.
 * Most custom objects will return <i>self</i>, as is the case for NSFNanoBag. Since we can sort a bag by <i>name</i>, <i>key</i> or <i>hasUnsavedChanges</i>,
  @note NanoStore requires a hint to find the attribute. This hint is the root object, which KVC uses to perform the sort. Taking NSFNanoBag as an example:
 @code
 @interface NSFNanoBag : NSObject <NSFNanoObjectProtocol, NSCopying> {
    NSFNanoStore            *store;
    NSString                *name, *key;
    BOOL                    hasUnsavedChanges;
  }
  @endcode
  The implementation of <i>rootObject</i> would look like so:
  @code
    - (id)rootObject { return self; }
  @endcode
  Other objects may point directly to the collection that holds the information. NSFNanoObject stores all its data in the <i>info</i> dictionary, so the implementation looks like this:

  @code - (id)rootObject { return info; } @endcode

  Assuming that <i>info</i> contains a key named <i>City</i>, we would specify a NSFNanoSortDescriptor which would sort the cities like so:
  @code
    NSFNanoSortDescriptor *sortedCities = [NSFNanoSortDescriptor.alloc initWithAttribute:@"City" ascending:YES];
  @endcode
  If we had returned <i>self</i> as the root object, the sort descriptor would have to be written like so:
  @code
    NSFNanoSortDescriptor *sortedCities = [NSFNanoSortDescriptor.alloc initWithAttribute:@"info.City" ascending:YES];
  @endcode
 */

@property (readonly) id rootObject;

@end