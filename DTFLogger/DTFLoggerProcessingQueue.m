//
//  DTFLoggerProcessingQueue.m
//  
//
//  Created by Darren Ferguson on 3/26/15.
//
//

#import "DTFLoggerProcessingQueue.h"
#import <dispatch/dispatch.h>

static dispatch_queue_t _dtfLoggerProcessingQueue;

@implementation DTFLoggerProcessingQueue

+ (dispatch_queue_t)processingQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dtfLoggerProcessingQueue = dispatch_queue_create("io.github.darren102.dtflogger", DISPATCH_QUEUE_SERIAL);
    });
    return _dtfLoggerProcessingQueue;
}

+ (void)cleanUpProcessingQueue
{
    if (_dtfLoggerProcessingQueue) {
        _dtfLoggerProcessingQueue = nil;
    }
}

@end
