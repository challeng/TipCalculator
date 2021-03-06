//
//  SettingsViewController.m
//  tipCalculator
//
//  Created by Jim Challenger on 10/9/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipAmount;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    // Load default tip amount
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultTipAmountIndex = [defaults integerForKey:@"defaulTipAmountIndex"];
    self.defaultTipAmount.selectedSegmentIndex = defaultTipAmountIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onValueChanged:(UISegmentedControl *)sender {
    float defaulTipAmountIndex = self.defaultTipAmount.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:defaulTipAmountIndex forKey:@"defaulTipAmountIndex"];
    [defaults synchronize];
}

@end
