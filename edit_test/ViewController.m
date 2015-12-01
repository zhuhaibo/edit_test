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
    AVPlayerLayer *_playerLayer;
    NSTimer *_movieTimer;    //视频循环播放timer
    NSTimer *_audioTimer;    //视频循环播放timer
    __weak IBOutlet UIView *_playerView;
    __weak IBOutlet UIView *_toolView;
    __weak IBOutlet BottomView *_bottomView;
    UIView *_segView;                   //功能提示view
    
    Float64 _movieTime;      //选择的视频时长
    
    __weak IBOutlet UILabel *_filters;
    __weak IBOutlet UILabel *_mv;
    __weak IBOutlet UIButton *_music;
    __weak IBOutlet UIButton *_waterMark;
    
    AVAudioPlayer *_audioPlayer;
    
    UIImageView *_waterCoverImage;  //水印
}
@property (nonatomic, strong) NSMutableArray *musicArr;     //音乐数据
@property (nonatomic, strong) NSMutableArray *watermarkArr; //水印数据

- (IBAction)nextClicked:(id)sender;
- (IBAction)pickupClicked:(id)sender;
@end

@implementation ViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (_movieTimer) {
        [_movieTimer invalidate];
        _movieTimer = nil;
        [_player pause];
        _audioPlayer = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (_movieTimer) {
        [_movieTimer fire];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self toolViewConfig];
    
    _bottomView.itemDidSelected = ^(NSIndexPath *indexPath, BottomType type, BottomModel *some){
        if (!_player) {
            return;
        }
        switch (type) {
            case filterType:
            {
                
            }
                break;
            case mvType:
            {
                
            }
                break;
            case musicType:
            {
                _player.volume = 0;
                [_player seekToTime:kCMTimeZero];
                [self moviePlay];
                //视频编辑
                NSString *songPath = [[NSBundle mainBundle] pathForResource:some.text ofType:@"mp3"];
                
                NSError *err = nil;
                NSURL *url = [[NSURL alloc] initFileURLWithPath:songPath];
                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
                _audioPlayer.numberOfLoops = -1;
                [_audioPlayer play];
                
                //创建音乐渐隐效果
//                _audioTimer = [NSTimer scheduledTimerWithTimeInterval:_movieTime target:self selector:@selector(audioReplay) userInfo:nil repeats:YES];
            }
                break;
            case waterMarkType:
            {
                [_waterCoverImage.layer removeFromSuperlayer];
                _waterCoverImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN.size.width - 80 - 30, 10, 30, 30)];
                [_waterCoverImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", some.img]]];
                [_playerLayer addSublayer:_waterCoverImage.layer];
            }
                break;
                
            default:
                break;
        }
    };
    NSArray *arr = [NSArray new];
    //music
    arr = @[
            @{@"img" : @"img", @"text" : @"周杰伦 - 晴天"},
            @{@"img" : @"img", @"text" : @"周杰伦 - 园游会(Live) - live"},
            @{@"img" : @"img", @"text" : @"宗次郎 - いつも何度でも"},
            @{@"img" : @"img", @"text" : @"Capo Productions - Inspire"},
            @{@"img" : @"img", @"text" : @"Eddie - Late Autumn"},
            @{@"img" : @"img", @"text" : @"Emeli Sandé,The Bryan Ferry Orchestra - Crazy In Love"},
            @{@"img" : @"img", @"text" : @"Jim Brickman - Serenade"},
            @{@"img" : @"img", @"text" : @"Josh Vietti - Canon In D"},
            @{@"img" : @"img", @"text" : @"Leona Lewis - Better In Time - Single Mix"},
            @{@"img" : @"img", @"text" : @"Malcolm Arnold - The River Kwai March／Colonel Bogey March"},
            @{@"img" : @"img", @"text" : @"Various Artists - FORZA DORIA"}
            ];
    self.musicArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        BottomModel *model = [[BottomModel alloc] initWithDic:dic];
        [self.musicArr addObject:model];
    }
    //watermarkArr
    arr = @[
            @{@"img" : @"0", @"text" : @""},
            @{@"img" : @"1", @"text" : @""},
            @{@"img" : @"2", @"text" : @""},
            @{@"img" : @"3", @"text" : @""},
            @{@"img" : @"4", @"text" : @""},
            @{@"img" : @"5", @"text" : @""},
            @{@"img" : @"6", @"text" : @""}
            ];
    self.watermarkArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        BottomModel *model = [[BottomModel alloc] initWithDic:dic];
        [self.watermarkArr addObject:model];
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
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waterClicked:)];
    _waterMark.userInteractionEnabled = YES;
    [_waterMark addGestureRecognizer:tap4];
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

- (void)waterClicked:(UITapGestureRecognizer*)tap {
    [self segViewMove:tap];
    [_bottomView bottomViewTypeChange:waterMarkType];
    _bottomView.dataArray = self.watermarkArr;
}

- (void)segViewMove:(UITapGestureRecognizer*)tap {
    UIView *view = [tap view];
    [UIView animateWithDuration:0.3f animations:^{
        [_segView setCenter:CGPointMake(view.center.x, _segView.center.y)];
    }];
}

- (void)moviePlay {
    [_player play];
    
    if (!_movieTimer) {
        _movieTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0] interval:_movieTime target:self selector:@selector(replay) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_movieTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)audioReplay {
    Float64 time = CMTimeGetSeconds(_player.currentItem.duration);
    if (_audioPlayer.currentTime >= time) {
        [_audioPlayer pause];
    }
}

- (void)replay {
    NSLog(@"[NSDate date] == %@", [NSDate date]);
//    if (_player.rate != 0) {
//        return;
//    }
    [_player seekToTime:kCMTimeZero];
    [_player play];
    
    [_audioPlayer setCurrentTime:0];
    [_audioPlayer play];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:info[@"UIImagePickerControllerReferenceURL"] options:nil];
    _movieTime = asset.duration.value / asset.duration.timescale;
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithAsset:asset automaticallyLoadedAssetKeys:nil];
    if (_player) {
        _player = nil;
    }
    _player = [[AVPlayer alloc] initWithPlayerItem:item];
    _playerLayer = [AVPlayerLayer new];
    _playerLayer.player = _player;
    [_playerLayer setFrame:_playerView.frame];
    [self.view.layer addSublayer:_playerLayer];
    [self moviePlay];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
