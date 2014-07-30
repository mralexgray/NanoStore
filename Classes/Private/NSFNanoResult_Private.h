/*
     NSFNanoResult_Private.h
     NanoStore
     	*/

#import "NSFNanoResult.h"

/** \cond */

@interface NSFNanoResult (Private)
+ (NSFNanoResult*)_resultWithDictionary:(NSDictionary*)results;
+ (NSFNanoResult*)_resultWithError:(NSError*)error;

- (id)_initWithDictionary:(NSDictionary*)results;
- (id)_initWithError:(NSError*)error;

- (void)_setError:(NSError*)error;
- (void)_reset;
- (void)_calculateNumberOfRows;
@end

/** \endcond */
