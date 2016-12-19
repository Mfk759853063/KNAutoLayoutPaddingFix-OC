//
//  ViewController.m
//  AutoLayoutPadingFix
//
//  Created by vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "ViewController.h"
#import "KNAutoLayoutPadingFix.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KNAutoLayoutPadingFix fixViews:@[self.label2] axis:KNAutoLayoutPadingFixAxisHorizontal | KNAutoLayoutPadingFixAxisVertical];
        self.label2HeightConstraint.constant = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KNAutoLayoutPadingFix restoreViews:@[self.label2]];
            self.label2HeightConstraint.constant = 21;
        });
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
