//
//  DTFLogger.h
//  DTFLogger-Demo
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

// DTFLogger to log notice information
#define DTFNLog(fmt, ...)    NSLog((@"%s [Line %d]\n*** " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__); [DTFLogger notice:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log error information
#define DTFErrLog(fmt, ...) NSLog((@"%s [Line %d]\n*** " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__); [DTFLogger error:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log debug information
#define DTFDLog(fmt, ...) NSLog((@"%s [Line %d]\n*** " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__); [DTFLogger debug:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log warn information
#define DTFWLog(fmt, ...) NSLog((@"%s [Line %d]\n*** " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__); [DTFLogger warn:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

#import "DTFLoggerMessage.h"

@interface DTFLogger : NSObject

/**
 * notice::
 * @abstract: Log 'notice' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 */
+ (void)notice:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * error::
 * @abstract: Log 'error' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 */
+ (void)error:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * debug::
 * @abstract: Log 'debug' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 */
+ (void)debug:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * warn::
 * @abstract: Log 'warn' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 */
+ (void)warn:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * logMessages::::
 * @abstract Retrieves log messages from the logging system and returns them through the completion block
 *
 * @param 'date' if specified will pull all log messages that were created after the date provided
 * @param 'type' returns only messages of the type specified `DTFLoggerMessageTypeAll` to get all types
 * @param 'limit' specify the number of log messages you wish returned `0` will return all records
 * @param 'completion' block called to return the instances of DTFLoggerMessage in an NSArray
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)logMessages:(NSDate*)date
               type:(DTFLoggerMessageType)type
              limit:(NSUInteger)limit
         completion:(void(^)(NSArray*))completion __attribute__((nonnull(4)));

/**
 * deleteAllLogMessages
 * @abstract: Deletes all log messages currently stored in the logging system
 *
 * @param 'completion' block called to indicate the deletion has occurred.
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)deleteAllLogMessages:(void(^)(void))completion;

/**
 * logMessage::
 * @abstract: Provides the ability to retrieve a log message based on the message primary key 
 *
 * @param 'messageId' Message ID for a particular message in the logging system
 * @param 'completion' block called to return the DTFLoggerMessage matching the primary key passed in
 *                     block is guaranteed to always be called on the main thread. Will be called with
 *                     `nil` if there is no message in the logging system matching provided ID
 */
+ (void)logMessage:(NSString*)messageId completion:(void(^)(DTFLoggerMessage*))completion __attribute__((nonnull(1, 2)));

/**
 * logMessages
 * @abstract: Returns all of the log messages currently stored in the logging system
 *
 * @param 'completion' block called to return the instances of DTFLoggerMessage in an NSArray
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)logMessages:(void(^)(NSArray*))completion __attribute__((nonnull(1)));

@end
