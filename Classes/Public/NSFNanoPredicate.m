/*
     NSFNanoExpression.m
     NanoStore
     
 */

#import "NSFNanoExpression.h"
#import "NanoStore_Private.h"
#import "NSFOrderedDictionary.h"

@interface NSFNanoPredicate ()

    /** \cond */
    @property (nonatomic, assign, readwrite) NSFTableColumnType column;
    @property (nonatomic, assign, readwrite) NSFMatchType match;
    @property (nonatomic, readwrite) id value;
    /** \endcond */

@end

@implementation NSFNanoPredicate

#pragma mark - Initialization / Cleanup

+ (NSFNanoPredicate*)predicateWithColumn:(NSFTableColumnType)type matching:(NSFMatchType)matching value:(id)aValue {

    return [self.alloc initWithColumn:type matching:matching value:aValue];
}

- (id)initWithColumn:(NSFTableColumnType)type matching:(NSFMatchType)matching value:(id)aValue {

    NSAssert(nil != aValue, @"*** -[%@ %@]: value is nil.", self.class
  , NSStringFromSelector(_cmd));
    NSAssert([aValue isKindOfClass:NSString.class
  ] || [aValue isKindOfClass:NSNull.class
  ], @"*** -[%@ %@]: value must be of type NSString or NSNull.", self.class
  , NSStringFromSelector(_cmd));

    if ((self = [super init])) {
        _column = type;
        _match = matching;
        _value = aValue;
    }
    
    return self;
}

- (NSString*)description {

    return [[self arrayDescription]lastObject];
}

- (NSArray*)arrayDescription {

    NSMutableArray *values = NSMutableArray.new;
    
    NSString *columnValue = nil;
    NSMutableString *mutatedString = nil;
    NSInteger mutatedStringLength = 0;
    
    switch (_column) {
        case NSFKeyColumn:
            columnValue = NSFKey;
            break;
        case NSFAttributeColumn:
            columnValue = NSFAttribute;
            break;
        default:
            columnValue = NSFValue;
            break;
    }
    
    // Make sure we escape quotes if present and the value is a string
    if ([_value isKindOfClass:NSString.class
  ]) {
        _value = [_value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    } else {
        _value = NSFStringFromNanoDataType(NSFNanoTypeNULL);
        columnValue = NSFDatatype;
    }
    
    switch (_match) {
        case NSFEqualTo:
            [values addObject:[NSString stringWithFormat:@"%@ = '%@'", columnValue, _value]];
            break;
        case NSFBeginsWith:
            mutatedString = [NSMutableString stringWithString:_value];
            mutatedStringLength = [_value length];
            [mutatedString replaceCharactersInRange:NSMakeRange(mutatedStringLength - 1, 1) withString:[NSString stringWithFormat:@"%c", [mutatedString characterAtIndex:mutatedStringLength - 1]+1]];
            [values addObject:[NSString stringWithFormat:@"(%@ >= '%@' AND %@ < '%@')", columnValue, _value, columnValue, mutatedString]];
            break;
        case NSFContains:
            [values addObject:[NSString stringWithFormat:@"%@ GLOB '*%@*'", columnValue, _value]];
            break;
        case NSFEndsWith:
            [values addObject:[NSString stringWithFormat:@"%@ GLOB '*%@'", columnValue, _value]];
            break;
        case NSFInsensitiveEqualTo:
            [values addObject:[NSString stringWithFormat:@"upper(%@) = '%@'", columnValue, [_value uppercaseString]]];
            break;
        case NSFInsensitiveBeginsWith:
            mutatedString = [NSMutableString stringWithString:_value];
            mutatedStringLength = [_value length];
            [mutatedString replaceCharactersInRange:NSMakeRange(mutatedStringLength - 1, 1) withString:[NSString stringWithFormat:@"%c", [mutatedString characterAtIndex:mutatedStringLength - 1]+1]];
            [values addObject:[NSString stringWithFormat:@"(upper(%@) >= '%@' AND upper(%@) < '%@')", columnValue, [_value uppercaseString], columnValue, [mutatedString uppercaseString]]];
            break;
        case NSFInsensitiveContains:
            [values addObject:[NSString stringWithFormat:@"%@ LIKE '%@%@%@'", columnValue, @"%", _value, @"%"]];
            break;
        case NSFInsensitiveEndsWith:
            [values addObject:[NSString stringWithFormat:@"%@ LIKE '%@%@'", columnValue, @"%", _value]];
            break;
        case NSFGreaterThan:
            [values addObject:[NSString stringWithFormat:@"%@ > '%@'", columnValue, _value]];
            break;
        case NSFLessThan:
            [values addObject:[NSString stringWithFormat:@"%@ < '%@'", columnValue, _value]];
            break;
        case NSFNotEqualTo:
            [values addObject:[NSString stringWithFormat:@"%@ <> '%@'", columnValue, _value]];
            break;
    }
    
    return values;
}

- (NSString*)JSONDescription {

    NSArray *values = [self arrayDescription];
    
    NSError *outError = nil;
    NSString *description = [NSFNanoObject _NSObjectToJSONString:values error:&outError];
    
    return description;
}

/** \cond */


/** \endcond */

@end
