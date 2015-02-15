//
//  DTFLoggerMessage+Internal.h
//  DTFLogger-Demo
//
//  Created by Darren Ferguson on 2/15/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import "DTFLoggerMessage.h"

@class DTFLogMessage;

@interface DTFLoggerMessage (Internal)

/**
 *
 */
+ (instancetype)loggerMessage:(DTFLogMessage*)logMessage;

@end
