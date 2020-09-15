//
//  itemData.h
//  baseDemo
//
//  Created by aos on 2019/1/3.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#ifndef itemData_h
#define itemData_h

#import <Foundation/Foundation.h>

@interface ItemData:NSObject

@property NSString *photo;
@property NSString *data;
@property NSString *name;

+(ItemData *) initWithPhoto:(NSString *)photo
                       Name:(NSString *) name
                       Data:(NSString *) data;

@end




#endif /* itemData_h */
