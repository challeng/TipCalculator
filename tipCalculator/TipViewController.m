//
//  ViewController.m
//  tipCalculator
//
//  Created by Jim Challenger on 10/9/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (strong, nonatomic) IBOutlet UIView *tipView;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    
    [self updateValues];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.totalLabel.alpha = 0.0;
    self.tipLabel.alpha = 0.0;
    self.billTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.billTextField becomeFirstResponder];
    
    // Load default tip amount
    NSInteger defaultTipAmountIndex = [defaults integerForKey:@"defaulTipAmountIndex"];
    self.tipControl.selectedSegmentIndex = defaultTipAmountIndex;
    
    // Check if <10min to keep bill amount
    NSTimeInterval lastTimeUsed = [defaults doubleForKey:@"lastTimeUsed"];
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval timeBetween = now - lastTimeUsed;
    // 10 minutes has passed
    if (timeBetween > 10 * 60) {
        self.billTextField.text = @"";
    }
    else {
        float recentBillAmount = [defaults floatForKey:@"currentBillAmount"];
        self.billTextField.text = [NSString stringWithFormat:@"%0.2f", recentBillAmount];
    }
    
    [self updateValues];
    [self animateCalculations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setMostRecentTimeUsed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
}

- (IBAction)onValueChange:(UISegmentedControl *)sender {
    [self updateValues];
    [self animateCalculations];
}
- (IBAction)onBillAmountChanged:(UITextField *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float currentBillAmount = [self.billTextField.text floatValue];
    [defaults setFloat:currentBillAmount forKey:@"currentBillAmount"];
    [defaults synchronize];
    
    [self updateValues];
    [self animateCalculations];
}

- (void)updateValues {
    // Get the bill amount
    float billAmount = [self.billTextField.text floatValue];
    
    // Compute the tip and total
    NSArray *tipValues = @[@(0.15), @(0.2), @(0.25)];
    float tipAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * billAmount;
    float totalAmount = billAmount + tipAmount;
    
    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    
    // Update the ui
    self.tipLabel.text = [NSString localizedStringWithFormat:@"%@%0.2f", currencySymbol, tipAmount];
    self.totalLabel.text = [NSString localizedStringWithFormat:@"%@%0.2f", currencySymbol, totalAmount];
}

- (void)animateCalculations {
    [self animateTipVisible];
    [self animateTotalVisible];
}

- (void)animateTotalVisible {
    self.totalLabel.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.totalLabel.alpha = 1.0;
    }];
}

- (void)animateTipVisible {
    self.tipLabel.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.tipLabel.alpha = 1.0;
    }];
}

- (void) setMostRecentTimeUsed {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:now forKey:@"lastTimeUsed"];
    [defaults synchronize];
}

@end
