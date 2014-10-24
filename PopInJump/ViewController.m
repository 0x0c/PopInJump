//
//  ViewController.m
//  PopInJump
//
//  Created by Akira Matsuda on 10/25/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "ViewController.h"
#import "PopInJump.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)viewControllerMethod
{
	NSLog(@"viewControllerMethod");
}

- (IBAction)eval:(id)sender
{
	[PopInJump setDebugMode:YES];
	[PopInJump addBridgeHandlerWithTarget:self selector:@selector(viewControllerMethod)];
	[PopInJump addBridgeHandlerWithKey:@"viewControllerHandler" hendler:^(JSValue *value) {
		NSLog(@"viewControllerHandler");
	}];
	
	self.title = @"PopInJump title";
	[PopInJump setBridgeVariableWithKey:@"viewControllerTitle" variable:self.title];
	[PopInJump evaluateScript:@"\
	 PopInJumpBridgeHandler.viewControllerHandler();\
	 PopInJumpBridgeHandler.viewControllerMethod();\
	 PopInJump.rog();// exception will be thrown\
	 PopInJump.log(PopInJumpBridgeStore.viewControllerTitle);\
	 "];
}

- (IBAction)updateTitle:(id)sender
{
	[PopInJump evaluateScript:@"PopInJumpBridgeStore.viewControllerTitle = 'new title';"];
	self.title = [[PopInJump getBridgeVariableWithKey:@"viewControllerTitle"] toString];
}

@end
