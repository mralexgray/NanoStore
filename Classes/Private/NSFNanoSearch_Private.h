/*
     NSFNanoSearch_Private.h
     NanoStore
     	*/

#import "NanoStore.h"

/** \cond */

@interface NSFNanoSearch (Private)
- (NSDictionary*)_retrieveDataWithError:ERROR_PTR;
- (NSArray*)_dataWithKey:(NSString*)aKey attribute:(NSString*)anAttribute value:(NSString*)aValue matching:(NSFMatchType)match;
- (NSArray*)_dataWithKey:(NSString*)aKey attribute:(NSString*)anAttribute value:(NSString*)aValue matching:(NSFMatchType)match returning:(NSFReturnType)returnedObjectType;
- (NSDictionary*)_retrieveDataAdded:(NSFDateMatchType)aDateMatch calendarDate:(NSDate*)aDate error:ERROR_PTR;
@property (readonly, copy) NSString *_preparedSQL;
- (NSString*)_prepareSQLQueryStringWithKey:(NSString*)aKey attribute:(NSString*)anAttribute value:(id)aValue matching:(NSFMatchType)match;
- (NSString*)_prepareSQLQueryStringWithExpressions:(NSArray*)someExpressions;
- (NSArray*)_resultsFromSQLQuery:(NSString*)theSQLStatement;
+ (NSString*)_prepareSQLQueryStringWithKeys:(NSArray*)someKeys;
+ (NSString*)_querySegmentForColumn:(NSString*)aColumn value:(id)aValue matching:(NSFMatchType)match;
+ (NSString*)_querySegmentForAttributeColumnWithValue:(id)anAttributeValue matching:(NSFMatchType)match valueColumnWithValue:(id)aValue;
- (NSDictionary*)_dictionaryForKeyPath:(NSString*)keyPath value:(id)value;
+ (NSString*)_quoteStrings:(NSArray*)strings joiningWithDelimiter:(NSString*)delimiter;
- (id)_sortResultsIfApplicable:(NSDictionary*)results returnType:(NSFReturnType)theReturnType;
@end

/** \endcond */
