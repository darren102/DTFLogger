//
//  DTFLogMessage.m
//  DTFLogger-Demo
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import "DTFLogMessage.h"

@implementation DTFLogMessage

+ (NSString*)primaryKey
{
    return @"id";
}

+ (NSArray*)requiredProperties
{
    return @[@"id",
             @"creationDate",
             @"message",
             @"fileinfo"];
}

@end
