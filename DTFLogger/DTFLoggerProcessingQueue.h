//
//  DTFLoggerProcessingQueue.h
//  
//
//  Created by Darren Ferguson on 3/26/15.
//
//

#import <Foundation/Foundation.h>

@interface DTFLoggerProcessingQueue : NSObject

/**
 * Singleton to retrieve background processing queue
 */
+ (dispatch_queue_t)processingQueue;

/**
 * Clean up background processing queue
 */
+ (void)cleanUpProcessingQueue;

@end
