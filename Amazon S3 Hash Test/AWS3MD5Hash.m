//
//  AWS3MD5Hash.m
//  Amazon S3 Hash Test
//
//  Created by Alfonso Maria Tesauro on 08/04/2019.
//  Copyright © 2019 Alfonso Maria Tesauro. All rights reserved.
//

#import "AWS3MD5Hash.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/xattr.h>
#include <sys/stat.h>
#define SIZE 256


@implementation AWS3MD5Hash


- (NSData *)dataFromFile:(FILE *)theFile startingOnByte:(UInt64)startByte length:(UInt64)length filePath:(NSString *)path {
    
    char *buffer = malloc(1024*1024*32);
    
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSNumber *fileSizeValue = nil;
    NSError *fileSizeError = nil;
    [fileURL getResourceValue:&fileSizeValue
                       forKey:NSURLFileSizeKey
                        error:&fileSizeError];
  
    NSInteger result = fseek(theFile,startByte,SEEK_SET);
    
    if (result != 0) {
        
        free(buffer);
        return nil;
    }
    
    NSInteger result2 = fread(buffer, length, 1, theFile);
    
    NSUInteger difference = fileSizeValue.integerValue - startByte;
    
    NSData *returnData;
    
    if (result2 == 0) {
        returnData = [NSData dataWithBytes:buffer length:difference];
    } else {
        returnData = [NSData dataWithBytes:buffer length:result2 * length];
    }
    free(buffer);
    
    return returnData;
    
}



- (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    NSInteger i = 0;
    NSInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

@end
