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
    
    char *buffer = malloc(1024*1024*16);
    
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSNumber *fileSizeValue = nil;
    NSError *fileSizeError = nil;
    [fileURL getResourceValue:&fileSizeValue
                       forKey:NSURLFileSizeKey
                        error:&fileSizeError];
  
    
    
    NSInteger result = fseek(theFile,startByte,SEEK_SET);
    NSInteger result2 = fread(buffer, length, 1, theFile);
    
    NSUInteger difference = fileSizeValue.integerValue - startByte;
    
    if (result2 == 0) {
        return [NSData dataWithBytes:buffer length:difference];
    } else {
        return [NSData dataWithBytes:buffer length:result2 * length];
    }
    
    
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

-(NSString *)xxdMd5:(NSData *)bigData {
    return @"";
}


int main2(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s file\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    FILE *myfile = fopen(argv[1], "rb");
    if (myfile == 0)
    {
        fprintf(stderr, "%s: failed to open file '%s' for reading\n", argv[0], argv[1]);
        exit(EXIT_FAILURE);
    }
    
    unsigned char buffer[SIZE];
    size_t n;
    size_t offset = 0;
    while ((n = fread(buffer, 1, SIZE, myfile)) > 0)
    {
        hexDump(offset, buffer, n);
        if (n < SIZE)
            break;
        offset += n;
    }
    
    fclose(myfile);
    return 0;
}

void hexDump(size_t offset, void *addr, int len)
{
    int i;
    unsigned char bufferLine[17];
    unsigned char *pc = (unsigned char *)addr;
    
    for (i = 0; i < len; i++)
    {
        if ((i % 16) == 0)
        {
            if (i != 0)
                printf(" %s\n", bufferLine);
            // Bogus test for zero bytes!
            //if (pc[i] == 0x00)
            //    exit(0);
            printf("%08zx: ", offset);
            offset += (i % 16 == 0) ? 16 : i % 16;
        }
        
        printf("%02x", pc[i]);
        if ((i % 2) == 1)
            printf(" ");
        
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
        {
            bufferLine[i % 16] = '.';
        }
        else
        {
            bufferLine[i % 16] = pc[i];
        }
        
        bufferLine[(i % 16) + 1] = '\0';
    }
    
    while ((i % 16) != 0)
    {
        printf("  ");
        if (i % 2 == 1)
            putchar(' ');
        i++;
    }
    printf(" %s\n", bufferLine);
    
}

@end
