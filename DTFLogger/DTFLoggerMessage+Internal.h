//
//  DTFLoggerMessage+Internal.h
//  
//
//  Created by Darren Ferguson on 2/15/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import "DTFLoggerMessage.h"

@class DTFLogMessage;

@interface DTFLoggerMessage (Internal)

/**
 * loggerMessage:
 * @abstract: Helper method to instantiate a DTFLoggerMessage from the internal DTFLogMessage Realm object
 *
 * @param 'logMessage' DTFLogMessage Realm Database Object instantiated from the logging system
 * @return 'DTFLoggerMessage' instance of the DTFLoggerMessage initialized with the info from the DTFLogMessage
 */
+ (instancetype)loggerMessage:(DTFLogMessage*)logMessage;

@end
