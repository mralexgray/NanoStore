/*
     NSFNanoSortDescriptor.m
     NanoStore
     	*/

#import "NSFNanoSortDescriptor.h"
#import "NSFNanoGlobals.h"
#import "NSFOrderedDictionary.h"
#import "NSFNanoObject_Private.h"

@interface NSFNanoSortDescriptor ()

/** \cond */
@property (nonatomic, copy, readwrite) NSString *attribute;
@property (nonatomic, readwrite) BOOL isAscending;
/** \endcond */

@end

@implementation NSFNanoSortDescriptor

+ (NSFNanoSortDescriptor *)sortDescriptorWithAttribute:(NSString *)theAttribute ascending:(BOOL)ascending {

    return [self.alloc initWithAttribute:theAttribute ascending:ascending];
}

- (id)initWithAttribute:(NSString *)theAttribute ascending:(BOOL)ascending {

    if (theAttribute.length == 0)
        [[NSException exceptionWithName:NSFUnexpectedParameterException
                                 reason:[NSString stringWithFormat:@"*** -[%@ %@]: theAttribute is invalid.", self.class
  , NSStringFromSelector(_cmd)]
                               userInfo:nil]raise];
    
    if ((self = [super init])) {
        _attribute = theAttribute;
        _isAscending = ascending;
    }
    
    return self;
}

/** \cond */


/** \endcond */


- (NSString *)description {

    return [self JSONDescription];
}

- (NSFOrderedDictionary *)dictionaryDescription {

    NSFOrderedDictionary *values = NSFOrderedDictionary.new;
    
    values[@"Sort descriptor address"] = [NSString stringWithFormat:@"%p", self];
    values[@"Attribute"] = _attribute;
    values[@"Is ascending?"] = (_isAscending ? @"YES" : @"NO");
    
    return values;
}

- (NSString *)JSONDescription {

    NSFOrderedDictionary *values = [self dictionaryDescription];
    
    NSError *outError = nil;
    NSString *description = [NSFNanoObject _NSObjectToJSONString:values error:&outError];
    
    return description;
}

@end
