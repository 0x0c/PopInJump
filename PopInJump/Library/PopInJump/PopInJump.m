//
//  PopInJump.m
//  PopInJump
//
//  Created by Akira Matsuda on 10/25/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "PopInJump.h"

@interface PopInJump ()

@property (nonatomic, readonly) JSContext *context;
@property (nonatomic, assign) BOOL debugMode;

@end

@implementation PopInJump

static NSString *const PopInJumpBridgeHandler = @"PopInJumpBridgeHandler";
static NSString *const PopInJumpBridgeStore = @"PopInJumpBridgeStore";

- (instancetype)init
{
	self = [super init];
	if (self) {
		_context = [JSContext new];
	}
	
	return self;
}

+ (void)setDebugMode:(BOOL)debugMode
{
	PopInJump *vm = [PopInJump sharedInstance];
	vm.debugMode = debugMode;
}

+ (instancetype)sharedInstance
{
	static PopInJump *vm;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		vm = [PopInJump new];
		Class c = [PopInJump class];
		NSString *className = NSStringFromClass(c);
		vm.context[className] = [PopInJump class];
		vm.context[className][@"log"] = ^(JSValue* value) {
			NSLog(@"[PopInJump log]: %@", value);
		};
		vm.context.exceptionHandler = ^(JSContext *ctx, JSValue* error) {
			if (vm.debugMode) {
				NSLog(@"[PopInJump JSB Exception]: %@", error);
			}
		};
		
		vm.context[PopInJumpBridgeHandler] = [NSObject class];
		vm.context[PopInJumpBridgeStore] = [NSObject class];
	});
	
	return vm;
}

+ (JSValue *)evaluateScript:(NSString *)script
{
	PopInJump *vm = [PopInJump sharedInstance];
	if (vm.debugMode) {
		NSLog(@"%@", script);
	}
	return [vm.context evaluateScript:script];
}

+ (JSValue *)callFunctionWithKey:(NSString *)key namespace:(NSString *)namespace args:(NSArray *)args
{
	PopInJump *vm = [PopInJump sharedInstance];
	id obj = vm.context[namespace][key];
	JSValue *value = nil;
	if ([obj isMemberOfClass:[JSValue class]]) {
		value = [(JSValue *)obj callWithArguments:nil];
	}
	else {
		value = [vm.context[namespace][key] callWithArguments:args];
	}
	
	return value;
}

+ (JSValue *)callFunctionWithKey:(NSString *)key args:(NSArray *)args
{
	PopInJump *vm = [PopInJump sharedInstance];
	return [vm.context[key] callWithArguments:args];
}

+ (void)addBridgeHandlerWithTarget:(id)target selector:(SEL)selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	PopInJump *vm = [PopInJump sharedInstance];
	vm.context[PopInJumpBridgeHandler][NSStringFromSelector(selector)] = ^(){
		[target performSelector:selector];
	};
#pragma clang diagnostic pop
}

+ (void)addBridgeHandlerWithKey:(NSString *)key hendler:(void (^)(JSValue* value))handler
{
	PopInJump *vm = [PopInJump sharedInstance];
	vm.context[PopInJumpBridgeHandler][key] = handler;
}

+ (void)setBridgeVariableWithKey:(NSString *)key variable:(id)obj
{
	PopInJump *vm = [PopInJump sharedInstance];
	vm.context[PopInJumpBridgeStore][key] = obj;
}

+ (JSValue *)getBridgeVariableWithKey:(NSString *)key
{
	PopInJump *vm = [PopInJump sharedInstance];
	return vm.context[PopInJumpBridgeStore][key];
}

@end
