//
//  DTFLogger.m
//  
//
//  Created by Darren Ferguson on 2/15/15.
//
//

#import "DTFLogger.h"

// Realm imports
#import <Realm/Realm.h>

// DTFLogger imports
#import "DTFLoggerMessage+Internal.h"
#import "DTFLogMessage.h"

@implementation DTFLogger

+ (void)notice:(NSString*)message fileinfo:(NSString*)fileinfo
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeNotice message:message fileinfo:fileinfo];
}

+ (void)error:(NSString*)message fileinfo:(NSString*)fileinfo
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeError message:message fileinfo:fileinfo];
}

+ (void)debug:(NSString*)message fileinfo:(NSString*)fileinfo
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeDebug message:message fileinfo:fileinfo];
}

+ (void)warn:(NSString*)message fileinfo:(NSString*)fileinfo
{
    NSCParameterAssert(message);
    NSCParameterAssert(fileinfo);
    [self createLog:DTFLoggerMessageTypeWarn message:message fileinfo:fileinfo];
}

+ (void)logMessages:(NSDate*)date type:(DTFLoggerMessageType)type limit:(NSUInteger)limit completion:(void(^)(NSArray*))completion
{
    date = date ?: [[NSDate date] dateByAddingTimeInterval:-86400];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *predicates = [NSMutableArray array];
        [predicates addObject:[NSPredicate predicateWithFormat:@"creationDate >= %@", date]];
        if (type != DTFLoggerMessageTypeAll) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"type = %@", @(type)]];
        }
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        RLMResults *results = [DTFLogMessage objectsWithPredicate:predicate];
        
        NSMutableArray *messages = [NSMutableArray array];
        for (DTFLogMessage *message in results) {
            [messages addObject:[DTFLoggerMessage loggerMessage:message]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([NSArray arrayWithArray:messages]);
        });
    });
}

+ (void)deleteAllLogMessages:(void(^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

+ (void)logMessages:(void(^)(NSArray*))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMResults *results = [DTFLogMessage allObjects];
        NSMutableArray *messages = [NSMutableArray array];
        for (DTFLogMessage *message in results) {
            [messages addObject:[DTFLoggerMessage loggerMessage:message]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([NSArray arrayWithArray:messages]);
        });
    });
}

# pragma mark - Private Class methods (PRIVATE-CLASS)

+ (void)createLog:(DTFLoggerMessageType)type message:(NSString*)message fileinfo:(NSString*)fileinfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            NSString *logId = [[[NSUUID UUID] UUIDString] lowercaseString];
            [DTFLogMessage createInDefaultRealmWithObject:@{ @"id" : logId,
                                                             @"creationDate" : [NSDate date],
                                                             @"message" : message,
                                                             @"fileinfo" : fileinfo,
                                                             @"type" : @(type) }];
        }];
    });
}

@end
