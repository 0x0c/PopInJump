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

- (void)pop
{
	NSLog(@"ぽっ");
}

- (IBAction)eval:(id)sender
{
	[PopInJump setDebugMode:YES];
	[PopInJump addBridgeHandlerWithTarget:self selector:@selector(pop)];
	[PopInJump addBridgeHandlerWithKey:@"in" hendler:^(JSValue *value) {
		NSLog(@"ぴん");
	}];
	[PopInJump addBridgeHandlerWithKey:@"jump" hendler:^(JSValue *value) {
		NSLog(@"ジャンプ♪");
	}];
	
	self.title = @"こころぴょんぴょん";
	[PopInJump setBridgeVariableWithKey:@"viewControllerTitle" variable:self.title];
	[PopInJump evaluateScript:@"\
	 PopInJump.log('せーのっ！で');\
	 PopInJumpBridgeHandler.pop();\
	 PopInJumpBridgeHandler.in();\
	 PopInJumpBridgeHandler.jump();\
	 PopInJump.rog();// exception will be thrown\
	 PopInJump.log(PopInJumpBridgeStore.viewControllerTitle);\
	 "];
}

- (IBAction)updateTitle:(id)sender
{
	[PopInJump evaluateScript:@"PopInJumpBridgeStore.viewControllerTitle = 'ごちうさは終わったんだよ';"];
	self.title = [[PopInJump getBridgeVariableWithKey:@"viewControllerTitle"] toString];
}

@end
