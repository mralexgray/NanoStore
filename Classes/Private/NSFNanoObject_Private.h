/*
     NSFNanoObject_Private.h
     NanoStore
     	*/

#import "NSFNanoObject.h"

/** \cond */

@interface NSFNanoObject ()
@property (nonatomic, weak, readwrite) NSFNanoStore *store;
@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, readwrite) BOOL hasUnsavedChanges;

- (void)_setOriginalClassString:(NSString*)theClassString;
+ (NSString*)_NSObjectToJSONString:(id)object error:(NSError **)error;
+ (NSDictionary*)_safeDictionaryFromDictionary:(NSDictionary*)dictionary;
+ (NSArray*)_safeArrayFromArray:(NSArray*)array;
+ (id)_safeObjectFromObject:(id)object;
@end

/** \endcond */
