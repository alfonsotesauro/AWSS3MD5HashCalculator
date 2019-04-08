//
//  AWS3MD5Hash.m
//  Amazon S3 Hash Test
//
//  Created by Alfonso Maria Tesauro on 08/04/2019.
//  Copyright © 2019 Alfonso Maria Tesauro. All rights reserved.
//

#import "AWS3MD5Hash.h"

@implementation AWS3MD5Hash


- (NSData *)dataFromFile:(FILE *)theFile startingOnByte:(UInt64)startByte length:(UInt64)length {
    
    char buffer[1024*16];
    
    NSInteger result = fseek(theFile,startByte,SEEK_SET);
    NSInteger result2 = fread(buffer, length, 1, theFile);
    
    return [NSData dataWithBytes:buffer length:result2];
    
}





@end
