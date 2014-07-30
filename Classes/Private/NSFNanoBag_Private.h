/*
     NSFNanoBag_Private.h
     NanoStore
     	*/

#import "NSFNanoBag.h"

/** \cond */

@interface NSFNanoBag (Private)
@property (nonatomic, readwrite) BOOL hasUnsavedChanges;

- (void)_setStore:(NSFNanoStore*)aStore;
- (BOOL)_saveInStore:(NSFNanoStore*)someStore error:ERROR_PTR;
- (void)_inflateObjectsWithKeys:(NSArray*)someKeys;
@end

/** \endcond */

