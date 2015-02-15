//
//  DTFLogMessage.h
//  DTFLogger-Demo
//
//  Created by Darren Ferguson on 2/14/15.
//  Copyright (c) 2015 Darren Ferguson. All rights reserved.
//

#import <Realm/RLMObject.h>

@interface DTFLogMessage : RLMObject

@property NSString *id;
@property NSDate *creationDate;
@property NSString *message;
@property NSString *fileinfo;
@property NSInteger type;

@end

RLM_ARRAY_TYPE(DTFLogMessage)
