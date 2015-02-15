//
//  DTFLogMessage.h
//  
//
//  Created by Darren Ferguson on 2/15/15.
//
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
