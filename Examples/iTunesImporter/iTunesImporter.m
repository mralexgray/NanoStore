


@import AppKit;
#import <NanoStore/NanoStore.h>

NSString* currentITunesLibraryURL() { [NSUserDefaults.standardUserDefaults synchronize];

  return [[NSUserDefaults.standardUserDefaults persistentDomainForName: @"com.apple.iApps"][@"iTunesRecentDatabasePaths"]firstObject];
  //"Couldn't find location of iTunes library; iTunesRecentDatabases pref = %@", dbs.description), nil;
}
NSWindow                * TestBed() { [NSApplication sharedApplication];

  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

  NSRect   scrn = NSScreen.mainScreen.frame;
  NSWindow *win = [NSWindow.alloc initWithContentRect:(NSRect){scrn.size.width/2 - 150,scrn.size.height/2 - 150,300,300}
                                            styleMask:1|2|4|8 backing:0 defer:NO];
  NSOutlineView *v = win.contentView = [NSOutlineView.alloc initWithFrame:[win.contentView bounds]];
  [v setAutoresizingMask:2|16];

  [v.enclosingScrollView setBackgroundColor:NSColor.redColor];
  [v.enclosingScrollView setDrawsBackground:YES];

  return [NSApp activateIgnoringOtherApps:YES], [win makeKeyAndOrderFront:nil], win;
}
void importDataUsingNanoStore(NSDictionary *iTunesInfo) {

  NSString *p = @"~/Desktop/itunesimporter.sqlite".stringByStandardizingPath;
//  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
  NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType path:p error:nil];

  NSFSetIsDebugOn(YES);
  [nanoStore setSaveInterval:59];

  NSDictionary     * tracks = iTunesInfo[@"Tracks"];
//                     tracks = [tracks dictionaryWithValuesForKeys:[tracks.allKeys
//                                                subarrayWithRange:NSMakeRange(0,MIN(1000,tracks.allKeys.count))]];
  NSDate * startStoringDate = NSDate.date;
  NSMutableArray     * keys = @[].mutableCopy;//[NSMutableArray arrayWithCapacity:[tracks count]];
  __block int    iterations = 0;

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
//  }

  NSFNanoSearch      * search = [NSFNanoSearch searchWithStore:nanoStore];
  //    NSUInteger numImportedItems = [[search aggregateOperation:NSFCount onAttribute:@"Track ID"]longValue];
  //  id numItems = [search aggregateOperation:NSFCount onAttribute:@"Track ID"];
//    search.filterClass = @"NSFNanoObject";

  NSError *outError       = nil;
  id results = [search searchObjectsWithReturnType:NSFReturnObjects error:&outError];
  //    search.sort  = @[[NSFNanoSortDescriptor.alloc initWithAttribute:@"title" ascending:NO]]; // sortByKey

//  books = @[].mutableCopy;
//  for (Book *book in results) [books addObject:book];

  NSLog(@"Number of items imported: %@", [[results allObjects]valueForKey:@"originalClassString"]);
  // valueForKeyPath:@"className"]);//@"nanoObjectDictionaryRepresentation"]); // numImportedItems);

  //    startStoringDate = ;
//  [nanoStore removeObjectsWithKeysInArray:keys error:nil];
  //    secondsStoring = ;
//  NSLog(@"Done removing. Removing the objects took %.3f seconds.", [NSDate.date timeIntervalSinceDate:NSDate.date]);

  //  }
  //  NSError *e = nil;
  //  [nanoStore saveStoreAndReturnError:&e];
  //  NSLog(@"filePath:%@ error:%@",nanoStore.filePath, e);

  // Close the document store
  [nanoStore closeWithError:nil];
}



int main (int argc, const char * argv[]) { @autoreleasepool {

    id win = TestBed();    id itunes = [NSDictionary dictionaryWithContentsOfFile:currentITunesLibraryURL()][@"Tracks"];
    NSLog(@"There are %ld items in the iTunes XML file", [itunes count]);

    importDataUsingNanoStore(itunes);


    [NSApp run];
  }
}

/*
NSDictionary *           iTunesDB() {   NSString *iTunesXMLPath = currentITunesLibraryURL(); // argc > 1 ? @(argv[1]) :

  BOOL exists =  [NSFileManager.defaultManager fileExistsAtPath:iTunesXMLPath];
  NSLog(@"Files Exists: %@ at: %@", exists ? @"YES" : @"NO", iTunesXMLPath);
//  return 
// Read the iTunes XML plist
// NSLog(@"The file iTunes XML file doesn't exist at path: %@", iTunesXMLPath), (id)nil;
// NSLog(@"x: %@", [ allKeys]);
}
*/