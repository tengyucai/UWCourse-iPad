//
//  WebViewVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC () <UIWebViewDelegate>

@end

@implementation WebViewVC {
    
    UIWebView *webView;
}

-(void)loadView{
    [super loadView];
    
    NSInteger surnameIndex = 0;
    NSInteger firstnameIndex = 0;
    for (NSInteger i = 0; i < [self.instructorString length] ; i++){
        char c = [self.instructorString characterAtIndex:i];
        if (c == ','){
            surnameIndex = i;
            firstnameIndex = i+1;
            break;
        }
    }
    
    NSString *surname = [self.instructorString substringToIndex:surnameIndex];
    NSString *firstname = [self.instructorString substringFromIndex:firstnameIndex];
    
    NSLog(@"%@",self.instructorString);
    NSLog(@"%@",surname);
    NSLog(@"%@",firstname);
    
    self.title = [NSString stringWithFormat:@"%@ %@", firstname, surname];
    
    
    
    _initialUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ratemyprofessors.com/search.jsp?query1=%@+waterloo&queryoption1=TEACHER&search_submit1=Search&prerelease=true",surname]];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    webView.scalesPageToFit=YES;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:_initialUrl]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    [activity startAnimating];
    
}

#pragma mark - Navigation

-(void)updateControls{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    backButton.enabled = webView.canGoBack;
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}


-(void)backAction{
    [webView goBack];
}

-(void)forwardAction{
    [webView goForward];
}

-(void)reloadAction{
    [webView reload];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    [activity startAnimating];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self updateControls];
    
}

#pragma mark - Action

- (void)doneAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
