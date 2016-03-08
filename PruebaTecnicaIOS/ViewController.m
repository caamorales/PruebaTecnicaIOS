//
//  ViewController.m
//  PruebaTecnicaIOS
//
//  Created by Carlos Machado on 22/1/15.
//  Copyright (c) 2015 SlashMobility. All rights reserved.
//


#import "Model.h"
#import "ViewController.h"
#import "SquareView.h"
#import "SongTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Model sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady:) name:DATA_READY_NOTIFICATION object:nil];
    SquareView *square = [[SquareView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    square.backgroundColor = [UIColor redColor];
    [self.view addSubview:square];
}

- (void)dataReady:(NSNotification *) notification{
    if (notification.userInfo[@"error"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:notification.userInfo[@"error"] delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    }else{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark Table View Delegate and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Model sharedModel].songs.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
   
    if (!cell) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"songCell"];
    }
    
    cell.trackNameLabel.text = [Model sharedModel].songs[indexPath.row].trackName;
    cell.collectionCensoredNameLabel.text = [Model sharedModel].songs[indexPath.row].collectionCensoredName;
    cell.countryLabel.text = [Model sharedModel].songs[indexPath.row].country;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
