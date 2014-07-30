/*
     NSFNanoGlobals_Private.h
     NanoStore
     
 */

#import <Foundation/Foundation.h>
#import "NSFNanoGlobals.h"

/** \cond */

/*
 The following types are supported by Property Lists:
 
 CFArray
 CFDictionary
 CFData
 CFString
 CFDate
 CFNumber
 CFBoolean
 
 Since NanoStore associates an attribute with an atomic value (i.e. non-collection),
 the following data types are recognized:
 
 CFData
 CFString
 CFDate
 CFNumber
 
 Note: there isn't a dedicated data type homologous to CFBoolean in Cocoa. Therefore,
 NSNumber will be used for that purpose.
 
 */

extern NSDictionary * safeJSONDictionaryFromDictionary (NSDictionary *dictionary);
extern NSArray * safeJSONArrayFromArray (NSArray *array);
extern id safeJSONObjectFromObject (id object);

extern NSString * NSFStringFromMatchType (NSFMatchType aMatchType);

extern void _NSFLog (NSString  *format, ...);

extern NSString * const NSFVersionKey;
extern NSString * const NSFDomainKey;

extern NSString * const NSFKeys;
extern NSString * const NSFValues;
extern NSString * const NSFKey;
extern NSString * const NSFValue;
extern NSString * const NSFDatatype;
extern NSString * const NSFCalendarDate;
extern NSString * const NSFObjectClass;
extern NSString * const NSFKeyedArchive;
extern NSString * const NSFAttribute;

#pragma mark -

extern NSString * const NSF_Private_NSFKeys_NSFKey;
extern NSString * const NSF_Private_NSFKeys_NSFKeyedArchive;
extern NSString * const NSF_Private_NSFValues_NSFKey;
extern NSString * const NSF_Private_NSFValues_NSFAttribute;
extern NSString * const NSF_Private_NSFValues_NSFValue;
extern NSString * const NSF_Private_NSFNanoBag_Name;
extern NSString * const NSF_Private_NSFNanoBag_NSFKey;
extern NSString * const NSF_Private_NSFNanoBag_NSFObjectKeys;
extern NSString * const NSF_Private_ToDeleteTableKey;

extern NSInteger const NSF_Private_InvalidParameterDataCodeKey;
extern NSInteger const NSF_Private_MacOSXErrorCodeKey;

#pragma mark -

extern NSString * const NSFP_TableIdentifier;
extern NSString * const NSFP_ColumnIdentifier;
extern NSString * const NSFP_DatatypeIdentifier;

extern NSString * const NSFRowIDColumnName;         // SQLite's standard UID property

/** \endcond */