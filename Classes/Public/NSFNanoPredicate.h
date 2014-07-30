/*
     NSFNanoPredicate.h
     NanoStore
     
 */

/*! @file NSFNanoPredicate.h
 @brief A predicate is an element of an expression used to perform complex queries.
 */

/*!	@class NSFNanoPredicate
 * A predicate is an element of an expression used to perform complex queries.
 *
	@note
 * A predicate must be added to a NSFNanoExpression.
 *
	@details <b>Example:</b>
 @code
 // Instantiate a NanoStore and open it
 NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
 
 // Add some data to the document store
 NSDictionary *info = ...;
 NSFNanoObject *object = [NSFNanoObject nanoObjectWithDictionary:info];
 [nanoStore addObject:object error:nil];
 
 // Prepare the expression
 NSFNanoPredicate *attribute = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:@"FirstName"];
 NSFNanoPredicate *value = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:NSFEqualTo value:@"Hobbes"];
 NSFNanoExpression *expression = [NSFNanoExpression expressionWithPredicate:predicateAttribute];
 [expression addPredicate:predicateValue withOperator:NSFAnd];
 
 // Setup the search with the document store and a given expression
 NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
 [search setExpressions:[NSArray arrayWithObject:expression]];
 
 // Obtain the matching objects
 NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
 
 // Close the document store
 [nanoStore closeWithError:nil];
 @endcode
 *
	@see \link NSFNanoExpression::expressionWithPredicate: + (NSFNanoExpression*)expressionWithPredicate:(NSFNanoPredicate*)thePredicate \endlink
	@see \link NSFNanoExpression::initWithPredicate: - (id)initWithPredicate:(NSFNanoPredicate*)thePredicate \endlink
	@see \link NSFNanoExpression::addPredicate:withOperator: - (void)addPredicate:(NSFNanoPredicate*)thePredicate withOperator:(NSFOperator)theOperator \endlink
 */

#import <Foundation/Foundation.h>

#import "NSFNanoGlobals.h"

@interface NSFNanoPredicate : NSObject

/*! The type of column being referenced. */
@property (nonatomic, assign, readonly) NSFTableColumnType column;
/*! The comparison operator to be used. */
@property (nonatomic, assign, readonly) NSFMatchType match;
/*! The value to be used for comparison.  */
@property (nonatomic, readonly) id value;

/*!	@name Creating and Initializing a Predicate
 */

//@{

/*! Creates and returns a predicate.
	@param theType is the column type. Can be \link Globals::NSFKeyColumn NSFKeyColumn \endlink, \link Globals::NSFAttributeColumn NSFAttributeColumn \endlink or \link Globals::NSFValueColumn NSFValueColumn \endlink.
	@param theMatch is the match operator.
	@param theValue can be an NSString or [NSNull null]
	@return A predicate which can be used in an NSFNanoExpression.
	@see \link initWithColumn:matching:value: - (id)initWithColumn:(NSFTableColumnType)theType matching:(NSFMatchType)theMatch value:(NSString*)theValue \endlink
 */

+ (NSFNanoPredicate*)predicateWithColumn:(NSFTableColumnType)theType matching:(NSFMatchType)theMatch value:(id)theValue;

/*! Initializes a newly allocated predicate.
	@param theType is the column type. Can be \link Globals::NSFKeyColumn NSFKeyColumn \endlink, \link Globals::NSFAttributeColumn NSFAttributeColumn \endlink or \link Globals::NSFValueColumn NSFValueColumn \endlink.
	@param theMatch is the match operator.
	@param theValue can be an NSString or [NSNull null]
	@return A predicate which can be used in an NSFNanoExpression.
	@see \link predicateWithColumn:matching:value: + (NSFNanoPredicate*)predicateWithColumn:(NSFTableColumnType)theType matching:(NSFMatchType)theMatch value:(NSString*)theValue \endlink
 */

- (id)initWithColumn:(NSFTableColumnType)theType matching:(NSFMatchType)theMatch value:(id)theValue;

//@}

/*!	@name Miscellaneous
 */

//@{

/*! Returns a string representation of the predicate.
	@note Check properties column, match and value to find out the current state of the predicate.
 */

- (NSString*)description;

/*! Returns a JSON representation of the predicate.
	@note Check properties column, match and value to find out the current state of the predicate.
 */

- (NSString*)JSONDescription;

//@}

@end