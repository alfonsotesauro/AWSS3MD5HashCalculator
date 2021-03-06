//
//  AWS3MD5Hash.h
//  Amazon S3 Hash Test
//
//  Created by Alfonso Maria Tesauro on 08/04/2019.
//  Copyright © 2019 Alfonso Maria Tesauro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWS3MD5Hash : NSObject
- (NSData *)dataFromFile:(FILE *)theFile startingOnByte:(UInt64)startByte length:(UInt64)length filePath:(NSString *)path;
void hexDump(size_t, void *, int);
int main2(int argc, char *argv[]);
- (NSData *)dataFromHexString:(NSString *)sourceString;

@end

NS_ASSUME_NONNULL_END
