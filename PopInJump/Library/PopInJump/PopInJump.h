//
//  PopInJump.h
//  PopInJump
//
//  Created by Akira Matsuda on 10/25/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface PopInJump : NSObject

+ (void)setDebugMode:(BOOL)debugMode;
+ (JSValue *)evaluateScript:(NSString *)script;
+ (JSValue *)callFunctionWithKey:(NSString *)key namespace:(NSString *)namespace args:(NSArray *)args;
+ (JSValue *)callFunctionWithKey:(NSString *)key args:(NSArray *)args;
+ (void)addBridgeHandlerWithTarget:(id)target selector:(SEL)selector;
+ (void)addBridgeHandlerWithKey:(NSString *)key hendler:(void (^)(JSValue* value))handler;
+ (void)setBridgeVariableWithKey:(NSString *)key variable:(id)obj;
+ (JSValue *)getBridgeVariableWithKey:(NSString *)key;

@end
