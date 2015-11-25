//
//  ViewController.m
//  AppTag
//
//  Created by Vinod Vishwakarma on 25/11/15.
//  Copyright © 2015 Vinod Vishwakarma. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


#import "AMTagListView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController () <UITextFieldDelegate, UIAlertViewDelegate, AMTagListDelegate>

@property (weak, nonatomic) IBOutlet UITextField    *textField;
@property (weak, nonatomic) IBOutlet AMTagListView	*tagListView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
    
    [self.tagListView addTag:@"my tag"];
    [self.tagListView addTag:@"something"];
    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"close"]];
    [self.tagListView addTag:@"long tag is long"];
    [self.tagListView addTag:@"hi there"];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1F8D92)];
    
    self.tagListView.tagListDelegate = self;
    
    
    
    [self.tagListView setTapHandler:^(AMTagView *view) {
        view.tag++;
        NSString *text = [[view.tagText componentsSeparatedByString:@" +"] firstObject];
        [view setTagText:[NSString stringWithFormat:@"%@ +%ld", text, (long)view.tag]];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(removeLast)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addButtonAction:(id)sender {

    [self.tagListView addTag:self.textField.text];
    //    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1F8D92)];
    
    [self.textField setText:@""];
    
}



- (void)removeLast {
    AMTagView *tag = self.tagListView.tags.lastObject;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:[NSString stringWithFormat:@"Delete %@?", [tag tagText]]
                                                   delegate:self
                                          cancelButtonTitle:@"Nope"
                                          otherButtonTitles:@"Sure!", nil];
    [alert show];
}

- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size
{
    // Don't add a 'bad' tag
    return ![text isEqualToString:@"bad"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        AMTagView *tag = self.tagListView.tags.lastObject;
        [self.tagListView removeTag:tag];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tagListView addTag:textField.text];
    //    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1F8D92)];
    
    [self.textField setText:@""];
    return YES;
}

// Close the keyboard when the user taps away froma  textfield
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

@end
