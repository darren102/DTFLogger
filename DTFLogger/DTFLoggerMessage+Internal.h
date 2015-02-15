//
//  DTFLoggerMessage+Internal.h
//  
//
//  Created by Darren Ferguson on 2/15/15.
//
//

#import "DTFLoggerMessage.h"

@class DTFLogMessage;

@interface DTFLoggerMessage (Internal)

/**
 *
 */
+ (instancetype)loggerMessage:(DTFLogMessage*)logMessage;

@end
