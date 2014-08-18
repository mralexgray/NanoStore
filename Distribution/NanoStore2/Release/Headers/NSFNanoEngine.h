/*
     NSFNanoBag.h
     NanoStore
     
 */

/*! @file NSFNanoEngine.h
 @brief A wrapper around SQLite, it provides convenience methods as well as "raw" access to the database.
 */

/*!	@class NSFNanoEngine
 * A wrapper around SQLite, it provides convenience methods as well as "raw" access to the database.
 */

#import "sqlite3.h"

#import "NSFNanoGlobals.h"
#import "NSFNanoGlobals.h"

@class NSFNanoResult;

@interface NSFNanoEngine : NSObject

/*! A reference to the SQLite database.  */
@property (nonatomic, assign, readonly) sqlite3 *sqlite;
/*! The file path where the database is located. */
@property (nonatomic, copy, readonly) NSString *path;
/*! The cache mechanism being used. */
@property (nonatomic, assign, readwrite) NSFCacheMethod cacheMethod;

/*!	@name Creating and Initializing NanoEngine
 */

/** Creates and returns an engine object at a given file path.
	@param thePath the file path where the document store will be created. Must not be nil.
	@return An engine object upon success, nil otherwise.
	@note To manipulate the document store, you must first open it.
	@see - (id)initWithPath:(NSString*)thePath;
	@see - (BOOL)openWithCacheMethod:(NSFCacheMethod)theCacheMethod useFastMode:(BOOL)useFastMode;
 */

+ (id)databaseWithPath:(NSString*)thePath;

/** Initializes a newly allocated document store at a given file path.
	@param thePath the file path where the document store will be created. Must not be nil.
	@return An engine object upon success, nil otherwise.
	@note To manipulate the document store, you must first open it.
	@see + (id)databaseWithPath:(NSString*)thePath;
	@see - (BOOL)openWithCacheMethod:(NSFCacheMethod)theCacheMethod useFastMode:(BOOL)useFastMode;
 */

- (id)initWithPath:(NSString*)thePath;

/*!	@name Opening and Closing
 */

/** Opens the engine, making it ready for manipulation.
	@param theCacheMethod allows to specify hwo the data will be read from the database:. This setting incurs a tradeoff between speed and memory usage.
	@param useFastMode if set to YES, the document store is opened with all performance turned on (more risky in case of failure). Setting it to NO is slower, but safer. See the note below for more information.
	@return YES upon success, NO otherwise.
	@note
 * When FastMode is activated NanoStore continues without pausing as soon as it has handed data off to the operating system.
 * If the application running NanoStore crashes, the data will be safe, but the database might become corrupted if the operating system crashes
 * or the computer loses power before that data has been written to the disk surface.
 * On the other hand, some operations are as much as 50 or more times faster with FastMode activated.
 * 
	@par
 * If FastMode is deactivated, NanoStore will pause at critical moments to make sure that data has actually been written to the disk surface
 * before continuing. This ensures that if the operating system crashes or if there is a power failure, the database will be uncorrupted after rebooting.
 * Deactivating FastMode is very safe, but it is also slower.
 */

- (BOOL)openWithCacheMethod:(NSFCacheMethod)theCacheMethod useFastMode:(BOOL)useFastMode;

/** Closes the database.
	@return YES upon success, NO otherwise.
 */

@property (readonly) BOOL close;

/*!	@name Accessors
 */

/** Checks whether the document store is open or closed.
	@see - (void)close;
 */

@property (getter=isDatabaseOpen, readonly) BOOL databaseOpen;

/** Checks whether a transaction is currently active.
	@return YES if a transaction is currently active, NO otherwise.
 */

@property (getter=isTransactionActive, readonly) BOOL transactionActive;

/** Sets the busy timeout.
	@param theTimeout is number of milliseconds that SQLite will wait to retry a busy operation.
	@note The acceptable range is between 100 and 5000 milliseconds. If the value is out of range, the 250 millisecond default timeout will be set instead.
	@see - (unsigned int)busyTimeout;
 */


/** Returns the current busy timeout.
	@see - (void)setBusyTimeout:(unsigned int)theTimeout;
 */

@property (nonatomic) unsigned int busyTimeout;

/** Returns the recommended cache size based on the system resources available.
	@return The recommended cache size in number of pages.
 */

+ (NSUInteger)recommendedCacheSize;

/** Sets the cache size.
	@param numberOfPages is the number of pages.
	@return YES upon success, NO otherwise.
	@see + (NSUInteger)recommendedCacheSize;
	@see - (NSUInteger)cacheSize;
 */

- (BOOL)setCacheSize:(NSUInteger)numberOfPages;

/** Returns the cache size.
	@return The current cache size.
	@see + (NSUInteger)recommendedCacheSize;
	@see - (BOOL)setCacheSize:(NSUInteger)numberOfPages;
 */

- (NSUInteger)cacheSize;

/** Returns the system's page size
 */

+ (NSInteger)systemPageSize;

/** Sets the page size.
	@param numberOfBytes is the size of the page.
	@return YES upon success, NO otherwise.
	@see + (NSInteger)systemPageSize;
	@see - (NSUInteger)pageSize;
 */

- (BOOL)setPageSize:(NSUInteger)numberOfBytes;

/** Returns the page size.
	@return The current page size.
	@see + (NSInteger)systemPageSize;
	@see - (BOOL)setPageSize:(NSUInteger)numberOfBytes;
 */

- (NSUInteger)pageSize;

/** Sets the text encoding type.
	@param theEncodingType is the encoding type. Can be NSFEncodingUTF8 or NSFEncodingUTF16.
	@return YES upon success, NO otherwise.
	@see - (NSFEncodingType)encoding;
 */

- (BOOL)setEncodingType:(NSFEncodingType)theEncodingType;

/** Returns the encoding type.
	@return The current encoding type.
	@see - (BOOL)setEncodingType:(NSFEncodingType)theEncodingType;
 */

@property (readonly) NSFEncodingType encoding;

/** Returns the encoding type from its string equivalent.
	@return The encoding type if successful, NSFEncodingUnknown otherwise.
	@see + (NSString*)NSFEncodingTypeToNSString:(NSFEncodingType)value;
 */

+ (NSFEncodingType)NSStringToNSFEncodingType:(NSString*)value;

/** Returns the string equivalent of an encoding type.
	@return The string equivalent if successful, nil otherwise.
	@see + (NSFEncodingType)NSStringToNSFEncodingType:(NSString*)value;
 */

+ (NSString*)NSFEncodingTypeToNSString:(NSFEncodingType)value;

/** Sets the synchronous mode.
	@param theSynchronousMode is the synchronous mode. Can be SynchronousModeOff, SynchronousModeNormal or SynchronousModeFull.
	@see - (NSFSynchronousMode)synchronousMode;
 */


/** Returns the synchronous mode.
	@return The current synchronous mode.
	@see - (void)setSynchronousMode:(NSFSynchronousMode)theSynchronousMode;
 */

@property  NSFSynchronousMode synchronousMode;

/** Sets the temporary storage mode.
	@param theTempStoreMode is the temporary storage mode. Can be TempStoreModeDefault, TempStoreModeFile or TempStoreModeMemory.
	@see - (NSFTempStoreMode)tempStoreMode;
 */


/** Returns the temporary storage mode.
	@return The current temporary storage mode.
	@see - (void)setTempStoreMode:(NSFTempStoreMode)theTempStoreMode;
 */

@property  NSFTempStoreMode tempStoreMode;

/*! Journal mode.
 * These values represent the options used by SQLite to the the journal mode for databases associated with the current database connection.
 
 @par
 The <b>DELETE</b> journaling mode is the normal behavior. In the <b>DELETE</b> mode, the rollback journal is deleted at the conclusion
     of each transaction. Indeed, the delete operation is the action that causes the transaction to commit. (See the document titled
     Atomic Commit In SQLite for additional detail.)
 
 @par
 The <b>TRUNCATE</b> journaling mode commits transactions by truncating the rollback journal to zero-length instead of deleting it.
     On many systems, truncating a file is much faster than deleting the file since the containing directory does not need to be changed.
 
 @par
 The <b>PERSIST</b> journaling mode prevents the rollback journal from being deleted at the end of each transaction. Instead, the header
     of the journal is overwritten with zeros. This will prevent other database connections from rolling the journal back. The <b>PERSIST</b>
     journaling mode is useful as an optimization on platforms where deleting or truncating a file is much more expensive than overwriting
     the first block of a file with zeros.
 
 @par
    The <b>MEMORY</b> journaling mode stores the rollback journal in volatile RAM. This saves disk I/O but at the expense of database safety
     and integrity. If the application using SQLite crashes in the middle of a transaction when the <b>MEMORY</b> journaling mode is set, then
     the database file will very likely go corrupt.
 
 @par
    The <b>WAL</b> journaling mode uses a write-ahead log instead of a rollback journal to implement transactions. The <b>WAL</b> journaling mode is
     persistent; after being set it stays in effect across multiple database connections and after closing and reopening the database. A database
     in <b>WAL</b> journaling mode can only be accessed by SQLite version 3.7.0 or later.
 
 @par
    The <b>OFF</b> journaling mode disables the rollback journal completely. No rollback journal is ever created and hence there is never a
     rollback journal to delete. The <b>OFF</b> journaling mode disables the atomic commit and rollback capabilities of SQLite. The <b>ROLLBACK</b> command
     no longer works; it behaves in an undefined way. Applications must avoid using the <b>ROLLBACK</b> command when the journal mode is <b>OFF</b>.
     If the application crashes in the middle of a transaction when the <b>OFF</b> journaling mode is set, then the database file will very likely go corrupt.
 
 @note
    The journal_mode for an in-memory database is either <b>MEMORY</b> or <b>OFF</b> and can not be changed to a different value. An attempt to change
     the journal_mode of an in-memory database to any setting other than <b>MEMORY</b> or <b>OFF</b> is ignored. Note also that the journal_mode cannot be changed
     while a transaction is active.
 
 @see NSFNanoEngine
 */

- (NSFJournalModeMode)journalModeAndReturnError:ERROR_PTR;

/** Returns the journal mode.
	@return The current journal mode.
	@see - (NSFJournalModeMode)journalModeAndReturnError:ERROR_PTR;
 */
- (BOOL)setJournalMode:(NSFJournalModeMode)theMode;

/** Returns a new array containing the datatypes recognized by NanoStore.
	@return A new array containing the datatypes recognized by NanoStore.
 */

+ (NSSet*)sharedNanoStoreEngineDatatypes;

/** Returns the NanoStore engine version.
	@return The NanoStore engine version.
 */

+ (NSString*)nanoStoreEngineVersion;

/** Returns the SQLite version.
	@return The SQLite version.
 */

+ (NSString*)sqliteVersion;

/*!	@name Transactions
 */

/** Starts a transaction.
	@return YES upon success, NO otherwise.
	@see - (BOOL)beginTransaction;
	@see - (BOOL)beginDeferredTransaction;
	@see - (BOOL)commitTransaction;
	@see - (BOOL)rollbackTransaction;
	@see - (BOOL)isTransactionActive;
 */

@property (readonly) BOOL beginTransaction;

/** Starts a deferred transaction.
	@return YES upon success, NO otherwise.
	@see - (BOOL)beginTransaction;
	@see - (BOOL)commitTransaction;
	@see - (BOOL)rollbackTransaction;
	@see - (BOOL)isTransactionActive;
 */

@property (readonly) BOOL beginDeferredTransaction;

/** Commits a transaction.
	@return YES upon success, NO otherwise.
	@see - (BOOL)beginTransaction;
	@see - (BOOL)beginDeferredTransaction;
	@see - (BOOL)rollbackTransaction;
	@see - (BOOL)isTransactionActive;
 */

@property (readonly) BOOL commitTransaction;

/** Rolls back a transaction.
	@return YES upon success, NO otherwise.
	@see - (BOOL)beginTransaction;
	@see - (BOOL)beginDeferredTransaction;
	@see - (BOOL)commitTransaction;
	@see - (BOOL)isTransactionActive;
 */

@property (readonly) BOOL rollbackTransaction;

/*!	@name Everything About Tables
 */

/** Creates a table.
	@param theTable the name of the table. Must not be nil.
	@param theColumns the names of the columns. Must not be nil.
	@param theDatatypes the datatypes of the columns. Must not be nil.
	@see - (BOOL)dropTable:(NSString*)theTable;
	@return YES upon success, NO otherwise.
	@note
 * Allowed datatypes: NSFNanoTypeRowUID, NSFNanoTypeString, NSFNanoTypeData, NSFNanoTypeDate and NSFNanoTypeNumber.
	@throws NSFUnexpectedParameterException is thrown if any of the parameters are nil.
	@throws NSFUnexpectedParameterException is thrown if the number of columns and datatypes are not equal.
 */

- (BOOL)createTable:(NSString*)theTable withColumns:(NSArray*)theColumns datatypes:(NSArray*)theDatatypes;

/** Returns a new array containing the tables found in the main document store.
	@return A new array containing the tables in the main document store, or an empty array if none is found.
	@see - (NSDictionary*)allTables;
	@see - (NSArray*)temporaryTables;
 */

@property (readonly, copy) NSArray *tables;

/** Returns a new array containing the tables found in the main and attached document stores.
	@return A new array containing the tables in the main and attached document stores, or an empty array if none is found.
	@note
 * The dictionary key is the document store name and its value, an array of the tables associated with that document store.
	@see - (NSArray*)tables;
	@see - (NSArray*)temporaryTables;
 */

@property (readonly, copy) NSDictionary *allTables;

/** Returns a new array containing the columns for a given table.
	@param theTable is the name of the table.
	@return A new array containing the columns for a given table, or an empty array if none is found.
 */

- (NSArray*)columnsForTable:(NSString*)theTable;

/** Returns a new array containing the temporary tables found in the main document store.
	@return A new array containing the temporary tables in the main document store, or an empty array if none is found.
	@see - (NSArray*)tables;
	@see - (NSDictionary*)allTables;
 */

@property (readonly, copy) NSArray *temporaryTables;

/** Returns a new array containing the datatypes for a given table.
	@param theTable is the name of the table.
	@return A new array containing the datatypes for a given table, or an empty array if none is found.
 */

- (NSArray*)datatypesForTable:(NSString*)theTable;

/** Removes the table from the document store.
	@param theTable is the name of the table.
	@return YES upon success, NO otherwise.
	@see - (BOOL)createTable:(NSString*)theTable withColumns:(NSArray*)theColumns datatypes:(NSArray*)theDatatypes;
 */

- (BOOL)dropTable:(NSString*)theTable;

/*!	@name Everything about Indexes
 */

/** Creates an index.
	@param theColumn is the name of the column.
	@param theTable is the name of the table.
	@param isUnique whether the index should be unique or allow duplicates.
	@return YES upon success, NO otherwise.
	@see - (void)dropIndex:(NSString*)indexName;
 */

- (BOOL)createIndexForColumn:(NSString*)theColumn table:(NSString*)theTable isUnique:(BOOL)isUnique;

/** Returns a new array containing the indexes found in the main document store.
	@return A new array containing the indexes in the main document store, or an empty array if none is found.
 */

@property (readonly, copy) NSArray *indexes;

/** Returns a new array containing the indexes found for a given table.
	@return A new array containing the indexes for a given table, or an empty array if none is found.
 */

- (NSArray*)indexedColumnsForTable:(NSString*)theTable;

/** Removes an index.
	@param theIndex is the name of the index to be removed.
	@see - (BOOL)createIndexForColumn:(NSString*)theColumn table:(NSString*)theTable isUnique:(BOOL)isUnique;
 */

- (void)dropIndex:(NSString*)theIndex;

/*!	@name Database Maintenance
 */

/** Compacts the database, attempting to reclaim unused space.
	@return YES upon success, NO otherwise.
	@note If a transaction is open, the operation will not proceed and NO will be returned instead.
 */

@property (readonly) BOOL compact;

/** Performs an integrity check on the database.
	@return YES upon success, NO otherwise.
	@note If a transaction is open, the operation will not proceed and NO will be returned instead.
 */

@property (readonly) BOOL integrityCheck;

/*!	@name Searching and Retrieving
 */

/** Executes a SQL statement.
	@param theSQLStatement is the SQL statement to be executed. Must not be nil or an empty string.
	@return Returns a NSFNanoResult.
	@throws NSFUnexpectedParameterException is thrown if the statement is nil or an empty string.
	@attention Check NSFNanoResult's error property to find out if there was a problem executing the statement.
	@note The result set will always contain string values. If you need to obtain NanoObjects instead, use the NSFNanoSearch class.
	@see NSFNanoSearch
 */

- (NSFNanoResult*)executeSQL:(NSString*)theSQLStatement;

/** Returns the largest ROWUID for a given table.
	@param theTable is the table from which to obtain the largest ROWUID. Must not be nil.
	@return The largest ROWUID in use.
	@throws NSFUnexpectedParameterException is thrown if the table is nil.
 */

- (long long)maxRowUIDForTable:(NSString*)theTable;

/*!	@name Miscellaneous
 */

/** Returns a string containing the base 64 representation of a data element.
	@return A string encoded in base 64 format.
 */

+ (NSString*)encodeDataToBase64:(NSData*)theData;

/** Returns a data element containing from a base 64 formatted string.
	@return A data element.
 */

+ (NSData*)decodeDataFromBase64:(NSString*)theEncodedData;

/** Returns a UUID string
	@return A string containing a representation of a UUID.
 */

+ (NSString*)stringWithUUID;

/** Returns a string representation of the engine.
 */

@property (readonly, copy) NSString *description;

/** Returns a JSON representation of the engine.
 */

@property (readonly, copy) NSString *JSONDescription;

@end