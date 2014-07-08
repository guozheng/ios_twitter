//
//  GGZLoginViewController.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/6/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZLoginViewController.h"
#import "TwitterClient.h"

@interface GGZLoginViewController ()
- (IBAction)onLoginButton:(id)sender;

@end

@implementation GGZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [[TwitterClient instance] login];
}
@end
