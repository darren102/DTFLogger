//
//  DTFLoggerMessage.h
//  
//
//  Created by Darren Ferguson on 2/15/15.
//
//

@import UIKit;

typedef NS_ENUM(NSInteger, DTFLoggerMessageType) {
    DTFLoggerMessageTypeError = 0, // Messages of type 'error'
    DTFLoggerMessageTypeNotice, // Messages of type 'notice'
    DTFLoggerMessageTypeDebug, // Messages of type 'debug'
    DTFLoggerMessageTypeWarn, // Messages of type 'warn'
    DTFLoggerMessageTypeAll
};

@interface DTFLoggerMessage : NSObject

/**
 * Type of message created
 */
@property (nonatomic, readonly, assign) DTFLoggerMessageType type;

/**
 * The date of message creation
 */
@property (nonatomic, readonly, strong) NSDate *creationDate;

/**
 * The actual message to log
 */
@property (nonatomic, readonly, copy) NSString *message;

/**
 * Provides file information on where the message was logged
 */
@property (nonatomic, readonly, copy) NSString *fileinfo;

/**
 * Initialize the DTFLoggerMessage with all pertinent information
 */
- (instancetype)initWithType:(DTFLoggerMessageType)type
                creationDate:(NSDate*)creationDate
                     message:(NSString*)message
                    fileinfo:(NSString*)fileinfo;

/**
 * emailLogMessage:
 * @abstract: Will present an MFMessageViewController to the user pre-populated with the message
 *
 * @param 'presentingViewController' view controller inside the application the library will present from
 */
- (void)emailLogMessage:(UIViewController*)presentingViewController __attribute__((nonnull(1)));

@end
