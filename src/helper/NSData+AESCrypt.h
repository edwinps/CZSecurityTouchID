//
//  NSData+AESCrypt.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 26/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESCrypt)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(NSUInteger)lineLength;

- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

@end
