#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "NanoStore.h"
#import <AtoZ/AtoZ.h>

//void importDataUsingNanoStore(NSDictionary *iTunesInfo)
void importDataUsingNanoStore(id iTunesInfo);

int main (int argc, const char * argv[]) {
	@autoreleasepool {

//	   NSAutoreleasePool * pool = [NSAutoreleasePool new];
//    NSString *iTunesXMLPath = @"~/Music/iTunes/iTunes Music Library.xml";
    NSUInteger executionResult = 0;

//    if (argc > 1) {
//        iTunesXMLPath = [NSString stringWithUTF8String:argv[1]];
//    }

    // Expand the tilde
//    iTunesXMLPath = [iTunesXMLPath stringByExpandingTildeInPath];

    // Read the iTunes XML plist
    /*(NSFileManager *fm = [NSFileManager defaultManager];
    if (YES == [fm fileExistsAtPath:iTunesXMLPath]) {
        NSDictionary *iTunesInfo = [NSDictionary dictionaryWithContentsOfFile:iTunesXMLPath];
        NSUInteger numOfTracks = [[iTunesInfo objectForKey:@"Tracks"]count];
        
        NSLog(@"There are %ld items in the iTunes XML file", numOfTracks);
        
        importDataUsingNanoStore(iTunesInfo);
*/
//	NSArray * u =  [NSColor fengshui];
//	if (u)
//	importDataUsingNanoStore(u);
//
//    else {
//        executionResult = 1;
//        NSLog(@"The file iTunes XML file doesn't exist at path: %@", u);//iTunesXMLPath);
//    }

//    [pool drain];

//void importDataUsingNanoStore(id iTunesInfo)

//void importDataUsingNanoStore(NSDictionary *iTunesInfo)
//{
    // Instantiate a NanoStore and open it
//    NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
    NSString *thePath = @"~/Desktop/myDatabase.database";
	NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType path:thePath error:nil];

//÷NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryNSFPersistentStoreType path:" error:nil];
//		NSData *theData = ;

			// NSData から NSColor に戻す
//		NSData *theData = ...;


    // Configure NanoStore
    NSFSetIsDebugOn(YES);
    NSUInteger saveInterval = 10;
    [nanoStore setSaveInterval:saveInterval];

	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[[NSColor fengshui] do:^(id obj) {
		[d setObject:[NSArchiver archivedDataWithRootObject:obj] forKey:[obj nameOfColor]];
	}];

	NSFNanoObject *object = [NSFNanoObject nanoObjectWithDictionary:d.copy];//
//							 [NSDictionary dictionaryWithObjects:[NSColor fengshui] forKeys:keys]];
	// Add the NanoObject to the document store
	[nanoStore addObject:object error:nil];
	// Close the document store
	[nanoStore closeWithError:nil];
		[nanoStore saveStoreAndReturnError:nil];

		return executionResult;
	}
}

//	AZFile *tracks = [
//    NSDictionary *tracks = [iTunesInfo objectForKey:@"Tracks"];
//    NSDate *startStoringDate = [NSDate date];
//    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[tracks count]];
//
//    NSAutoreleasePool *pool = [NSAutoreleasePool new];
//    NSUInteger iterations = 0;
//
//    for (NSString *trackID in tracks) {
//	[[AtoZ appFolder] each:^(NSColor* obj, NSUInteger index, BOOL *stop) {

//	}];

// Instantiate a NanoStore and open it
//	NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
//
//		// Generate an empty NanoObject
//	NSFNanoObject *object = [NSFNanoObject nanoObject];
//
//		// Add some data
//	[object setObject:@"Doe" forKey:@"kLastName"];
//	[object setObject:@"John" forKey:@"kFirstName"];
//	[object setObject:[NSArray arrayWithObjects:@"jdoe@foo.com", @"jdoe@bar.com", nil] forKey:@"kEmails"];
//
//		// Add it to the document store
//	[nanoStore addObject:object error:nil];

		// Close the document store
//	[nanoStore closeWithError:nil];
//
//		// Generate an empty NanoObject
//        NSFNanoObject *object = [NSFNanoObject :[tracks objectForKey:trackID]];
//
//        // Generate an empty NanoObject
//        NSFNanoObject *object = [NSFNanoObject nanoObjectWithDictionary:[tracks objectForKey:trackID]];
//        
//        [keys addObject:object.key];
//        
//        // Collect the object
//        [nanoStore addObject:object error:nil];
//        iterations++;
//        	[@[@"@"] arrayUsingBlock:^id(id obj) {
//				code
//			}]
        // Drain the memory every 'saveInterval' iterations
//        if (0 == iterations%saveInterval) {
//            [pool drain];
//            pool = [NSAutoreleasePool new];
//        }
//    }

    // Don't forget that some objects could be lingering in memory. Force a save.
 
   /*
    NSTimeInterval secondsStoring = [[NSDate date]timeIntervalSinceDate:startStoringDate];
    NSLog(@"Done importing. Storing the objects took %.3f seconds.", secondsStoring);


	NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
	search.attribute = @"trackID";
	search.match = NSFEqualTo;
	search.value = @"Doe";

		// Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
	NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:nanoStore];
    NSUInteger numImportedItems = [[search aggregateOperation:NSFCount onAttribute:@"Track ID"]longValue];
    NSLog(@"Number of items imported: %ld", numImportedItems);
    
    startStoringDate = [NSDate date];
    [nanoStore removeObjectsWithKeysInArray:keys error:nil];
    secondsStoring = [[NSDate date]timeIntervalSinceDate:startStoringDate];
    NSLog(@"Done removing. Removing the objects took %.3f seconds.", secondsStoring);
    
    [pool drain];
    
    // Close the document store
    [nanoStore closeWithError:nil];
*/
//}

