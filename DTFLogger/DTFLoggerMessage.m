//
//  DTFLoggerMessage.m
//
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

@import MessageUI;

#import <objc/runtime.h>
#import "DTFLoggerMessage.h"
#import "DTFLogMessage.h"

@interface DTFLoggerMessage()<MFMailComposeViewControllerDelegate>

@property (nonatomic, readwrite, assign) DTFLoggerMessageType type;
@property (nonatomic, readwrite, strong) NSDate *creationDate;
@property (nonatomic, readwrite, copy) NSString *message;
@property (nonatomic, readwrite, copy) NSString *fileinfo;

@end

@implementation DTFLoggerMessage {
    UIViewController *_presentingViewController;
}

- (instancetype)initWithType:(DTFLoggerMessageType)type
                creationDate:(NSDate*)creationDate
                     message:(NSString*)message
                    fileinfo:(NSString*)fileinfo
{
    if ((self = [super init])) {
        _type = type;
        _creationDate = creationDate;
        _message = message;
        _fileinfo = fileinfo;
    }
    return self;
}

+ (instancetype)loggerMessage:(DTFLogMessage*)logMessage
{
    return [[self alloc] initWithType:logMessage.type
                         creationDate:logMessage.creationDate
                              message:logMessage.message
                             fileinfo:logMessage.fileinfo];
}

# pragma mark - Public instance methods (PUBLIC)

- (void)emailLogMessage:(UIViewController*)presentingViewController
{
    if ([MFMailComposeViewController canSendMail]) {
        _presentingViewController = presentingViewController;
        
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:[self emailSubject]];
        [controller setMessageBody:[self emailBody] isHTML:NO];
        
        if (controller) {
            [_presentingViewController presentViewController:controller animated:YES completion:nil];
        }
    } else {
        NSString *title = NSLocalizedString(@"Email Not Configured", nil);
        NSString *message = NSLocalizedString(@"Device is not configured for email", nil);

        UIAlertController *controller = [UIAlertController
                                         alertControllerWithTitle:title
                                         message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         [self->_presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                         self->_presentingViewController = nil;
                                                     }]];
        if (controller) {
            [_presentingViewController presentViewController:controller animated:YES completion:nil];
        }
    }
}

# pragma mark - MFMailComposeViewControllerDelegate instance methods (MFMAILCOMPOSEVIEWCONTROLLERDELEGATE)

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        /**
         * Use the new UIAlertController if we have it available otherwise fall back to UIAlertView
         */
        UIAlertController *controller = [UIAlertController
                                         alertControllerWithTitle:NSLocalizedString(@"Email Failure", nil)
                                         message:NSLocalizedString(@"Internal error while sending email", nil)
                                         preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         [self->_presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                         self->_presentingViewController = nil;
                                                     }]];
        [_presentingViewController presentViewController:controller animated:YES completion:nil];
    } else {
        [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
        _presentingViewController = nil;
    }
}

# pragma mark - Private instance methods (PRIVATE)

- (NSString*)emailSubject
{
    return [NSString stringWithFormat:@"%@ Log Message", [self logMessageType]];
}

- (NSString*)emailBody
{
    return [NSString stringWithFormat:@"Created: %@\nFileInfo: %@\n\nMessage: %@\n",
            self.creationDate, self.fileinfo, self.message];
}

- (NSString*)logMessageType
{
    switch (self.type) {
        case DTFLoggerMessageTypeDebug:
            return NSLocalizedString(@"Debug", nil);
        case DTFLoggerMessageTypeError:
            return NSLocalizedString(@"Error", nil);
        case DTFLoggerMessageTypeNotice:
            return NSLocalizedString(@"Notice", nil);
        case DTFLoggerMessageTypeWarn:
            return NSLocalizedString(@"Warning", nil);
        default:
            return NSLocalizedString(@"Unknown", nil);
    }
}

@end
