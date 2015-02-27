//
//  ViewController.m
//  DTFLogger-Demo
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import "ViewController.h"

// DTFLogger imports
#import "DTFLoggerMessage.h"
#import "DTFLogger.h"

@interface ViewController()

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (IBAction)logMessage:(id)sender
{
    DTFDLog(@"Message: %@", self.textField.text);
}

- (IBAction)retrieveMessages:(id)sender
{
    [DTFLogger logMessages:^(NSArray *messages) {
        if ([messages count] > 0) {
            for (DTFLoggerMessage *message in messages) {
                NSLog(@"Message Text: %@", message.message);
            }
        } else {
            NSLog(@"Currently the log is empty");
        }
    }];
}

- (IBAction)deleteAllMessages:(id)sender
{
    [DTFLogger purge:^{
        NSLog(@"All messages deleted from the log");
    }];
}

@end
