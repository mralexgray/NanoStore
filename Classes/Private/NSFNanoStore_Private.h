/*
     NSFNanoStore_Private.h
     NanoStore
     	*/

#import "NSFNanoStore.h"
#import "NSFOrderedDictionary.h"

/** \cond */

@interface NSFNanoStore (Private)
- (NSFOrderedDictionary*)dictionaryDescription;
+ (NSFNanoStore*)_createAndOpenDebugDatabase;
- (NSFNanoResult*)_executeSQL:(NSString*)theSQLStatement;
- (NSString*)_nestedDescriptionWithPrefixedSpace:(NSString*)prefixedSpace;
- (BOOL)_initializePreparedStatementsWithError:ERROR_PTR;
- (void)_releasePreparedStatements;
- (void)_setIsOurTransaction:(BOOL)value;
@property (readonly) BOOL _isOurTransaction;
@property (readonly) BOOL _setupCachingSchema;
- (BOOL)_storeDictionary:(NSDictionary*)someInfo forKey:(NSString*)aKey forClassNamed:(NSString*)classType error:ERROR_PTR;
- (BOOL)__storeDictionaries:(NSArray*)someObjects forKeys:(NSArray*)someKeys error:ERROR_PTR;
- (BOOL)_bindValue:(id)aValue forAttribute:(NSString*)anAttribute parameterNumber:(NSInteger)aParamNumber usingSQLite3Statement:(sqlite3_stmt*)aStatement;
- (BOOL)_checkNanoStoreIsReadyAndReturnError:ERROR_PTR;
- (NSFNanoDatatype)_NSFDatatypeOfObject:(id)value;
- (NSString*)_stringFromValue:(id)aValue;
+ (NSString*)_calendarDateToString:(NSDate*)aDate;
- (void)_flattenCollection:(NSDictionary*)info keys:(NSMutableArray **)flattenedKeys values:(NSMutableArray **)flattenedValues;
- (void)_flattenCollection:(id)someObject keyPath:(NSMutableArray **)aKeyPath keys:(NSMutableArray **)someKeys values:(NSMutableArray **)someValues;
- (BOOL)_prepareSQLite3Statement:(sqlite3_stmt **)aStatement theSQLStatement:(NSString*)aSQLQuery;
- (void)_executeSQLite3StepUsingSQLite3Statement:(sqlite3_stmt*)aStatement;
- (BOOL)_addObjectsFromArray:(NSArray*)someObjects forceSave:(BOOL)forceSave error:ERROR_PTR;
+ (NSDictionary*)_defaultTestData;
- (BOOL)_backupFileStoreToDirectoryAtPath:(NSString*)aPath extension:(NSString*)anExtension compact:(BOOL)flag error:ERROR_PTR;
- (BOOL)_backupMemoryStoreToDirectoryAtPath:(NSString*)aPath extension:(NSString*)anExtension compact:(BOOL)flag error:ERROR_PTR;
@end

/** \endcond */
