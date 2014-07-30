/*
     NSFNanoExpression.m
     NanoStore
     	*/

#import "NSFNanoExpression.h"
#import "NanoStore_Private.h"
#import "NSFOrderedDictionary.h"

@implementation NSFNanoExpression
{
    /** \cond */
    NSMutableArray *_predicates;
    NSMutableArray *_operators;
    /** \endcond */
}

+ (NSFNanoExpression*)expressionWithPredicate:(NSFNanoPredicate*)aPredicate
{
    return [[self alloc]initWithPredicate:aPredicate];
}

- (id)initWithPredicate:(NSFNanoPredicate*)aPredicate
{
    if (nil == aPredicate) {
        [[NSException exceptionWithName:NSFUnexpectedParameterException
                                 reason:[NSString stringWithFormat:@"*** -[%@ %@]: the predicate is nil.", [self class], NSStringFromSelector(_cmd)]
                               userInfo:nil]raise];
    }
    
    if ((self = [super init])) {
        _predicates = [NSMutableArray new];
        [_predicates addObject:aPredicate];
        _operators = [NSMutableArray new];
        [_operators addObject:@(NSFAnd)];
    }
    
    return self;
}

/** \cond */


/** \endcond */


- (void)addPredicate:(NSFNanoPredicate*)aPredicate withOperator:(NSFOperator)someOperator
{
    if (nil == aPredicate)
        [[NSException exceptionWithName:NSFUnexpectedParameterException
                                 reason:[NSString stringWithFormat:@"*** -[%@ %@]: the predicate is nil.", [self class], NSStringFromSelector(_cmd)]
                               userInfo:nil]raise];
    
    [_predicates addObject:aPredicate];
    [_operators addObject:[NSNumber numberWithInt:someOperator]];
}

- (NSString*)description
{
    NSArray *values = [self arrayDescription];
    
    return [values componentsJoinedByString:@""];
}

- (NSArray*)arrayDescription
{
    NSUInteger i, count = [_predicates count];
    NSMutableArray *values = [NSMutableArray new];
    
    // We always have one predicate, so make sure add it
    [values addObject:[_predicates[0]description]];
    
    for (i = 1; i < count; i++) {
        NSString *compound = [[NSString alloc]initWithFormat:@" %@ %@", ([_operators[i]intValue] == NSFAnd) ? @"AND" : @"OR", [_predicates[i]description]];
        [values addObject:compound];
    }
    
    return values;
}

- (NSString*)JSONDescription
{
    NSArray *values = [self arrayDescription];
    
    NSError *outError = nil;
    NSString *description = [NSFNanoObject _NSObjectToJSONString:values error:&outError];
    
    return description;
}

@end
