//
//  DTFLoggerMessage.m
//  
//
//  Created by Darren Ferguson on 2/15/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

@import MessageUI;

#import <objc/runtime.h>
#import "DTFLoggerMessage.h"
#import "DTFLogMessage.h"

/**
 * Key used in the alert view when falling back to iOS7 compatibility
 */
static void *kDTFAlertViewDelegateCodeKey = &kDTFAlertViewDelegateCodeKey;

@interface DTFLoggerMessage()<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

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
        
        if (NSStringFromClass([UIAlertController class]) != nil) {
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
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:title
                                      message:message
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
            objc_setAssociatedObject(alertView, kDTFAlertViewDelegateCodeKey, ^(NSInteger buttonIndex) {
                [self->_presentingViewController dismissViewControllerAnimated:YES completion:nil];
                self->_presentingViewController = nil;
            }, OBJC_ASSOCIATION_COPY);
            [alertView show];
            
        }
    }
}

# pragma mark - MFMailComposeViewControllerDelegate instance methods (MFMAILCOMPOSEVIEWCONTROLLERDELEGATE)

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        if (NSStringFromClass([UIAlertController class]) != nil) {
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
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"Email Failure", nil)
                                      message:NSLocalizedString(@"Internal error while sending email", nil)
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
            objc_setAssociatedObject(alertView, kDTFAlertViewDelegateCodeKey, ^(NSInteger buttonIndex) {
                [self->_presentingViewController dismissViewControllerAnimated:YES completion:nil];
                self->_presentingViewController = nil;
            }, OBJC_ASSOCIATION_COPY);
            [alertView show];
        }
    } else {
        [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
        _presentingViewController = nil;
    }
}

# pragma mark - UIAlertViewDelegate instance methods (UIALERTVIEWDELEGATE)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSInteger) = objc_getAssociatedObject(alertView, kDTFAlertViewDelegateCodeKey);
    if (block) {
        block(buttonIndex);
    }
}

# pragma mark - Private instance methods (PRIVATE)

- (NSString*)emailSubject
{
    return @"";
}

- (NSString*)emailBody
{
    return [NSString stringWithFormat:@"Created: %@\nFileInfo: %@\n\nMessage: %@\n",
            self.creationDate, self.fileinfo, self.message];
}

@end
