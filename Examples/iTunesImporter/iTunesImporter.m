


#import "NanoStore.h"

void importDataUsingNanoStore(NSDictionary *iTunesInfo)
{

  NSString *p = @"~/Desktop/test.nanostoredb".stringByStandardizingPath;
//  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType path:p error:nil];

  NSFSetIsDebugOn(YES);
  [nanoStore setSaveInterval:59];

  NSDictionary     * tracks = iTunesInfo[@"Tracks"];
                     tracks = [tracks dictionaryWithValuesForKeys:[tracks.allKeys subarrayWithRange:NSMakeRange(0,MIN(1000,tracks.allKeys.count))]];
  NSDate * startStoringDate = NSDate.date;
  NSMutableArray     * keys = @[].mutableCopy;//[NSMutableArray arrayWithCapacity:[tracks count]];

  @autoreleasepool {

    __block NSUInteger iterations = 0;
    [tracks enumerateKeysAndObjectsUsingBlock:^(id trackID, id obj, BOOL *stop) {

      NSFNanoObject *object = [NSFNanoObject nanoObjectWithDictionary:obj];
      [keys addObject:object.key];

      // Collect the object
      [nanoStore addObject:object error:nil];
      iterations++;

      // Drain the memory every 'saveInterval' iterations
      // if (!iterations % saveInterval) { [pool drain]; pool = [NSAutoreleasePool new]; }
    }];

    // Don't forget that some objects could be lingering in memory. Force a save.
    [nanoStore saveStoreAndReturnError:nil];

    NSTimeInterval secondsStoring = [NSDate.date timeIntervalSinceDate:startStoringDate];
    NSLog(@"Done importing. Storing the objects took %.3f seconds.", secondsStoring);

    //    books = @[].mutableCopy;
    //    for (Book *book in results) [books addObject:book];
  }

  NSFNanoSearch      * search = [NSFNanoSearch searchWithStore:nanoStore];
  //    NSUInteger numImportedItems = [[search aggregateOperation:NSFCount onAttribute:@"Track ID"]longValue];
  //  id numItems = [search aggregateOperation:NSFCount onAttribute:@"Track ID"];
    search.filterClass = @"NSDictionary";

  NSError *outError       = nil;
  //    search.sort  = @[[NSFNanoSortDescriptor.alloc initWithAttribute:@"title" ascending:NO]]; // sortByKey
  NSMutableArray *results = [search searchObjectsWithReturnType:NSFReturnObjects error:&outError];

//  books = @[].mutableCopy;
//  for (Book *book in results) [books addObject:book];

  NSLog(@"Number of items imported: %@", results); // numImportedItems);

  //    startStoringDate = ;
  [nanoStore removeObjectsWithKeysInArray:keys error:nil];
  //    secondsStoring = ;
  NSLog(@"Done removing. Removing the objects took %.3f seconds.", [NSDate.date timeIntervalSinceDate:NSDate.date]);

  //  }
  //  NSError *e = nil;
  //  [nanoStore saveStoreAndReturnError:&e];
  //  NSLog(@"filePath:%@ error:%@",nanoStore.filePath, e);

  // Close the document store
  [nanoStore closeWithError:nil];
}

int main (int argc, const char * argv[]) {

  @autoreleasepool {

    NSString *iTunesXMLPath = argc > 1 ? @(argv[1]) : @"/Volumes/2T/ServiceData/iTunes/iTunes Music Library.xml";

    // Expand the tilde iTunesXMLPath = [iTunesXMLPath stringByExpandingTildeInPath];

    [NSFileManager.defaultManager fileExistsAtPath:iTunesXMLPath] ? ({     // Read the iTunes XML plist

      NSDictionary *iTunesInfo = [NSDictionary dictionaryWithContentsOfFile:iTunesXMLPath];
      NSLog(@"There are %ld items in the iTunes XML file", [iTunesInfo[@"Tracks"] count]);
      importDataUsingNanoStore(iTunesInfo);
    }) : NSLog(@"The file iTunes XML file doesn't exist at path: %@", iTunesXMLPath);
    
    
    dispatch_main();
  }
}
