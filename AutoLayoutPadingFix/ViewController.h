//
//  ViewController.h
//  AutoLayoutPadingFix
//
//  Created by vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2HeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

