//
//  DTFLogger.h
//
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

// DTFLogger to log notice information
#define DTFNLog(fmt, ...)    [DTFLogger notice:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log error information
#define DTFErrLog(fmt, ...) [DTFLogger error:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log debug information
#define DTFDLog(fmt, ...) [DTFLogger debug:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

// DTFLogger to log warn information
#define DTFWLog(fmt, ...) [DTFLogger warn:[NSString stringWithFormat:fmt, ## __VA_ARGS__] fileinfo:[NSString stringWithFormat:@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__] completion:nil];

#import "DTFLoggerMessage.h"

@interface DTFLogger : NSObject

/**
 * notice::
 * @abstract: Log 'notice' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)notice:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * error::
 * @abstract: Log 'error' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)error:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * debug::
 * @abstract: Log 'debug' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)debug:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion __attribute__((nonnull(1, 2)));

/**
 * warn::
 * @abstract: Log 'warn' severity message into the backing store
 *
 * @param 'message' Message to log into the system
 * @param 'fileinfo' method and file information to provide context
 * @param 'completion' block to call with 'ID' of newly created log message
 *                     block is guaranteed to always be called on the main thread
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
 * purge:
 * @abstract: Deletes all log messages currently stored in the logging system
 *
 * @param 'completion' block called to indicate the deletion has occurred can be `nil`.
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)purge:(void(^)(void))completion;

/**
 * limitMessages::
 * @abstract: Removes the oldest log messages to only leave enough to be the maximumMessage count
 *
 * @param 'maximumMessages' the number of messages that will be allowed to remain inside the log database
 * @param 'completion' block is called to let the caller know the messages have been deleted
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)limitMessages:(NSUInteger)maximumMessages completion:(void(^)(void))completion;

/**
 * deleteLogMessages::
 * @abstract: Deletes the log messages from the logging system based on the provided message ids
 *
 * @param 'messageId' NSArray holding the NSString messageId's of the log messages to delete
 * @param 'completion' block is called to let the caller know the messages have been deleted
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)purgeMessages:(NSArray*)messageIds completion:(void(^)(void))completion __attribute__((nonnull(1)));

/**
 * purgeMessages:
 * @abstract: Delete all log messages from the logging system that were logged before the provided date
 *
 * @param 'beforeDate'
 * @param 'completion' block is called to let the caller know the messages have been deleted
 *                     block is guaranteed to always be called on the main thread
 */
+ (void)purgeMessagesBefore:(NSDate*)beforeDate completion:(void(^)(void))completion __attribute__((nonnull(1)));

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

/**
 * allLogMessages
 * @abstract: Synchronously retrieve all of the log messages currently stored in the logging system
 *
 * @return 'NSArray' Array of `DTFLoggerMessage` objects one per record in the logging system
 */
+ (NSArray*)allLogMessages;

@end
