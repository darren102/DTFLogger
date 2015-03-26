//
//  DTFLogger.m
//
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import "DTFLogger.h"

// Realm imports
#import <Realm/Realm.h>

// DTFLogger imports
#import "DTFLoggerMessage+Internal.h"
#import "DTFLoggerProcessingQueue.h"
#import "DTFLogMessage.h"

/**
 * Filename used for the DTFLogger custom realm log
 */
static NSString *const kDTFLoggerCustomRealmFile = @"DTFLogger.realm";

@implementation DTFLogger

+ (void)notice:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeNotice message:message fileinfo:fileinfo completion:completion];
}

+ (void)error:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeError message:message fileinfo:fileinfo completion:completion];
}

+ (void)debug:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeDebug message:message fileinfo:fileinfo completion:completion];
}

+ (void)warn:(NSString*)message fileinfo:(NSString*)fileinfo completion:(void(^)(NSString*))completion
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeWarn message:message fileinfo:fileinfo completion:completion];
}

+ (void)logMessages:(NSDate*)date
               type:(DTFLoggerMessageType)type
              limit:(NSUInteger)limit
         completion:(void(^)(NSArray*))completion
{
    NSCParameterAssert(completion);
    
    date = date ?: [[NSDate date] dateByAddingTimeInterval:-86400];
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        NSMutableArray *predicates = [NSMutableArray array];
        [predicates addObject:[NSPredicate predicateWithFormat:@"creationDate >= %@", date]];
        if (type != DTFLoggerMessageTypeAll) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"type = %@", @(type)]];
        }
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        RLMResults *results = [DTFLogMessage objectsInRealm:[self realm] withPredicate:predicate];
        
        NSMutableArray *messages = [NSMutableArray array];
        for (DTFLogMessage *message in results) {
            [messages addObject:[DTFLoggerMessage loggerMessage:message]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([NSArray arrayWithArray:messages]);
        });
    });
}

+ (void)purge:(void(^)(void))completion
{
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        RLMRealm *realm = [self realm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

+ (void)purgeMessages:(NSArray*)messageIds completion:(void(^)(void))completion
{
    NSCParameterAssert(messageIds);
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        RLMRealm *realm = [self realm];
        RLMResults *results = [DTFLogMessage objectsInRealm:realm
                                              withPredicate:[NSPredicate predicateWithFormat:@"id IN %@", messageIds]];
        if ([results count] > 0) {
            [realm beginWriteTransaction];
            [realm deleteObjects:results];
            [realm commitWriteTransaction];
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

+ (void)purgeMessagesBefore:(NSDate*)beforeDate completion:(void(^)(void))completion
{
    NSCParameterAssert(beforeDate);
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        RLMRealm *realm = [self realm];
        RLMResults *results = [DTFLogMessage objectsInRealm:realm
                                              withPredicate:[NSPredicate predicateWithFormat:@"creationDate < %@", beforeDate]];
        
        if ([results count] > 0) {
            [realm beginWriteTransaction];
            [realm deleteObjects:results];
            [realm commitWriteTransaction];
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}


+ (void)logMessage:(NSString*)messageId completion:(void(^)(DTFLoggerMessage*))completion
{
    NSCParameterAssert(completion);
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        DTFLoggerMessage *loggerMessage = nil;
        DTFLogMessage *message = [DTFLogMessage objectInRealm:[self realm] forPrimaryKey:messageId];
        if (message) {
            loggerMessage = [DTFLoggerMessage loggerMessage:message];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(loggerMessage);
        });
    });
}

+ (void)logMessages:(void(^)(NSArray*))completion
{
    NSCParameterAssert(completion);
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        RLMResults *results = [DTFLogMessage allObjectsInRealm:[self realm]];
        NSMutableArray *messages = [NSMutableArray array];
        for (DTFLogMessage *message in results) {
            [messages addObject:[DTFLoggerMessage loggerMessage:message]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([NSArray arrayWithArray:messages]);
        });
    });
}

+ (NSArray*)allLogMessages
{
    RLMResults *results = [DTFLogMessage allObjectsInRealm:[self realm]];
    NSMutableArray *messages = [NSMutableArray array];
    for (DTFLogMessage *message in results) {
        [messages addObject:[DTFLoggerMessage loggerMessage:message]];
    }
    return [NSArray arrayWithArray:messages];
}

# pragma mark - Private Class methods (PRIVATE-CLASS)

+ (void)createLog:(DTFLoggerMessageType)type
          message:(NSString*)message
         fileinfo:(NSString*)fileinfo
       completion:(void(^)(NSString*))completion
{
    dispatch_async([DTFLoggerProcessingQueue processingQueue], ^{
        RLMRealm *realm = [self realm];
        [realm transactionWithBlock:^{
            NSString *logId = [[[NSUUID UUID] UUIDString] lowercaseString];
            DTFLogMessage *logMessage = [DTFLogMessage createInRealm:realm
                                                          withObject:@{ @"id" : logId,
                                                                        @"creationDate" : [NSDate date],
                                                                        @"message" : message,
                                                                        @"fileinfo" : fileinfo,
                                                                        @"type" : @(type) }];
            if (logMessage && completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(logMessage.id);
                });
            }
        }];
    });
}

+ (RLMRealm*)realm
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *customRealmPath = [documentDirectory stringByAppendingPathComponent:kDTFLoggerCustomRealmFile];
    return [RLMRealm realmWithPath:customRealmPath];
}

@end
