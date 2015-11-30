//
//  ViewController.m
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BottomView.h"
#import "BottomModel.h" 

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imgController;
    AVPlayer *_player;  //预览播放器
    __weak IBOutlet UIView *_playerView;
    __weak IBOutlet UIView *_toolView;
    __weak IBOutlet BottomView *_bottomView;
    UIView *_segView;                   //功能提示view
    
    __weak IBOutlet UILabel *_filters;
    __weak IBOutlet UILabel *_mv;
    __weak IBOutlet UIButton *_music;
}
@property (nonatomic, strong) NSMutableArray *musicArr;
- (IBAction)nextClicked:(id)sender;
- (IBAction)pickupClicked:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self toolViewConfig];
    
    _bottomView.itemDidSelected = ^(NSIndexPath *indexPath, id some){
        //视频编辑
        
    };
    
    NSArray *arr = [NSArray new];
    arr = @[
            @{@"img" : @"img", @"text" : @"1"},
            @{@"img" : @"img", @"text" : @"2"},
            @{@"img" : @"img", @"text" : @"3"},
            @{@"img" : @"img", @"text" : @"4"},
            @{@"img" : @"img", @"text" : @"5"},
            @{@"img" : @"img", @"text" : @"6"},
            @{@"img" : @"img", @"text" : @"7"},
            @{@"img" : @"img", @"text" : @"8"},
            @{@"img" : @"img", @"text" : @"9"},
            @{@"img" : @"img", @"text" : @"10"}
            ];
    self.musicArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        BottomModel *model = [[BottomModel alloc] initWithDic:dic];
        [self.musicArr addObject:model];
    }
}

- (void)toolViewConfig {
    _segView = [UIView new];
    [_segView setFrame:CGRectMake(0, 0, _filters.bounds.size.width, 4)];
    [_segView setCenter:CGPointMake(_filters.center.x, CGRectGetHeight(_toolView.bounds) - 2)];
    [_segView setBackgroundColor:[UIColor blackColor]];
    [_toolView addSubview:_segView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClicked:)];
    _filters.userInteractionEnabled = YES;
    [_filters addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mvClicked:)];
    _mv.userInteractionEnabled = YES;
    [_mv addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(musicClicked:)];
    _music.userInteractionEnabled = YES;
    [_music addGestureRecognizer:tap3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)nextClicked:(id)sender {
    
}

- (IBAction)pickupClicked:(id)sender {
    _imgController = [UIImagePickerController new];
    _imgController.delegate = self;
    _imgController.mediaTypes = @[(NSString*)(kUTTypeMovie)];
    [self presentViewController:_imgController animated:YES completion:nil];
}

- (void)playerCtrl:(UITapGestureRecognizer*)tap {
    if (_player.currentItem == nil) {
        return;
    }
    UIImageView *imgv = (UIImageView*)[tap view];
    if (_player.rate == 0) {    //stoped
        [_player play];
        imgv.hidden = YES;
    }else {
        [_player pause];
        imgv.hidden = NO;
    }
}

- (void)filterClicked:(UITapGestureRecognizer*)tap {
    [self segViewMove:tap];
    [_bottomView bottomViewTypeChange:filterType];
}

- (void)mvClicked:(UITapGestureRecognizer*)tap {
    [self segViewMove:tap];
    [_bottomView bottomViewTypeChange:mvType];
}

- (void)musicClicked:(UITapGestureRecognizer*)tap {
    [self segViewMove:tap];
    [_bottomView bottomViewTypeChange:musicType];
    _bottomView.dataArray = self.musicArr;
}

- (void)segViewMove:(UITapGestureRecognizer*)tap {
    UIView *view = [tap view];
    [UIView animateWithDuration:0.3f animations:^{
        [_segView setCenter:CGPointMake(view.center.x, _segView.center.y)];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:info[@"UIImagePickerControllerReferenceURL"] options:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithAsset:asset automaticallyLoadedAssetKeys:nil];
    _player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer new];
    layer.player = _player;
    [layer setFrame:CGRectMake(100, 100, 100, 100)];
    [layer setFrame:_playerView.frame];
    [self.view.layer addSublayer:layer];
    [_player play];
    
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:_playerView.frame];
//    imgV.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1f];
//    imgV.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerCtrl:)];
//    [imgV addGestureRecognizer:tap];
//    [self.view addSubview:imgV];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
