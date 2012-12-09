/*
     NSFNanoSearch_Private.h
     NanoStore
     
     Copyright (c) 2010 Webbo, L.L.C. All rights reserved.
     
     Redistribution and use in source and binary forms, with or without modification, are permitted
     provided that the following conditions are met:
     
     * Redistributions of source code must retain the above copyright notice, this list of conditions
     and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions
     and the following disclaimer in the documentation and/or other materials provided with the distribution.
     * Neither the name of Webbo nor the names of its contributors may be used to endorse or promote
     products derived from this software without specific prior written permission.
     
     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY
     DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
     OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
     SUCH DAMAGE.	*/

#import "NanoStore.h"

/** \cond */

@interface NSFNanoSearch (Private)
- (NSDictionary *)_retrieveDataWithError:(out NSError **)outError;
- (NSArray *)_dataWithKey:(NSString *)aKey attribute:(NSString *)anAttribute value:(NSString *)aValue matching:(NSFMatchType)match;
- (NSArray *)_dataWithKey:(NSString *)aKey attribute:(NSString *)anAttribute value:(NSString *)aValue matching:(NSFMatchType)match returning:(NSFReturnType)returnedObjectType;
- (NSDictionary *)_retrieveDataAdded:(NSFDateMatchType)aDateMatch calendarDate:(NSDate *)aDate error:(out NSError **)outError;
- (NSString *)_preparedSQL;
- (NSString *)_prepareSQLQueryStringWithKey:(NSString *)aKey attribute:(NSString *)anAttribute value:(id)aValue matching:(NSFMatchType)match;
- (NSString *)_prepareSQLQueryStringWithExpressions:(NSArray *)someExpressions;
- (NSArray *)_resultsFromSQLQuery:(NSString *)theSQLStatement;
+ (NSString *)_prepareSQLQueryStringWithKeys:(NSArray *)someKeys;
+ (NSString *)_querySegmentForColumn:(NSString *)aColumn value:(id)aValue matching:(NSFMatchType)match;
+ (NSString *)_querySegmentForAttributeColumnWithValue:(id)anAttributeValue matching:(NSFMatchType)match valueColumnWithValue:(id)aValue;
- (NSDictionary *)_dictionaryForKeyPath:(NSString *)keyPath value:(id)value;
+ (NSString *)_quoteStrings:(NSArray *)strings joiningWithDelimiter:(NSString *)delimiter;
- (id)_sortResultsIfApplicable:(NSDictionary *)results returnType:(NSFReturnType)theReturnType;
@end

/** \endcond */