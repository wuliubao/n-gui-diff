//
//  itemData.m
//  baseDemo
//
//  Created by aos on 2019/1/3.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "itemData.h"


@implementation ItemData
+(ItemData *) initWithPhoto:(NSString *)photo Name:(NSString *)name Data:(NSString *)data {
    ItemData *itemData = [[ItemData alloc]init];
    itemData.photo = photo;
    itemData.name = name;
    itemData.data = data;
    
    return itemData;
}

@end
