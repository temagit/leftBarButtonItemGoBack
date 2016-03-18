//
//  QFPlazaComments+CoreData.m
//  PocketKitchen
//
//  Created by Tema on 15/3/27.
//  Copyright (c) 2016年 Tema@gmail.com. All rights reserved.
//

#import "QFPlazaComments+CoreData.h"
#import "GlobalDefine.h"

@implementation QFPlazaComments (CoreData)

+ (instancetype)plazaCommentWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    // 获取请求
    NSString *commentID = data[@"id"];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CD_ENTITY_NAME_PLAZACOMMENTS];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", commentID];
    
    QFPlazaComments *comment= nil;
    
    // 执行数据请求操作
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    // 如果有错误，处理错误
    if (error) {
        [QFErrorHandler handleError:error];
    }
    else if (!matches || matches.count > 1) {
        
        // 这是数据错误
        NSError *wrongDataError = [NSError errorWithDomain:ERROR_DOMAIN_COREDATA
                                                      code:ERROR_CODE_COREDATA_WRONGDATA
                                                  userInfo:@{NSLocalizedDescriptionKey: @"数据查询错误"}];
        [QFErrorHandler handleError:wrongDataError];
    }
    else if (matches.count == 0) {
        
        // 没有查到数据就插入一条数据
        comment = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY_NAME_PLAZACOMMENTS inManagedObjectContext:context];
        [comment setValuesForKeysWithDictionary:data];
    }
    else {
        
        // 有数据就更新数据
        comment = [matches firstObject];
        [comment setValuesForKeysWithDictionary:data];
    }
    
    return comment;
}

@end
