//
//  NSString+AESCrypt.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 26/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AESCrypt)
- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;
@end
