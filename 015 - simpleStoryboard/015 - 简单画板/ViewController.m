//
//  ViewController.m
//  015 - 简单画板
//
//  Created by 陈显镇 on 16/9/18.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import "ViewController.h"
#import "NJDrawboardView.h"
#import "NJSelectView.h"
#import "NJSelectViewDelegate.h"
@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,NJSelectViewDelegate>
//清屏
- (IBAction)clearScreen:(id)sender;
//撤销
- (IBAction)undo:(id)sender;
//橡皮擦
- (IBAction)eraser:(id)sender;
//改变线宽
- (IBAction)changeLineWidth:(id)sender;
//改变颜色
- (IBAction)changeLineColor:(id)sender;
//选择照片
- (IBAction)selectPhoto:(id)sender;
//保存
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet NJDrawboardView *drawBoard;
@property(nonatomic,weak)UIColor * eraserColor;
@property (weak, nonatomic) IBOutlet UIStackView *colorStackView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIColor *)eraserColor
{
    if(_eraserColor == nil)
    {
        UIColor * eraserColor = [UIColor whiteColor];
        _eraserColor = eraserColor;
    }
    return _eraserColor;
}

- (IBAction)clearScreen:(id)sender {
    UIAlertController * alertCtl = [UIAlertController alertControllerWithTitle:@"是否要清屏？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [self.drawBoard clearScreen];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:okAction];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:^{
        
    }];

   
}

- (IBAction)undo:(id)sender {
    [self.drawBoard undo];
}

- (IBAction)eraser:(UIBarButtonItem *)barBtn {
    if([barBtn.title isEqualToString:@"橡皮擦"])
    {
        UIColor * switchColor = self.drawBoard.lineColor;
        [self.drawBoard eraser:self.eraserColor];
        self.eraserColor = switchColor;
        [barBtn setTitle:@"画笔"];
        self.colorStackView.userInteractionEnabled = NO;
    }
    else if([barBtn.title isEqualToString:@"画笔"]) 
    {
        UIColor * switchColor = self.drawBoard.lineColor;
        [self.drawBoard eraser:self.eraserColor];
        self.eraserColor = switchColor;
        [barBtn setTitle:@"橡皮擦"];
        self.colorStackView.userInteractionEnabled = YES;
    }
   
}

- (IBAction)changeLineWidth:(UISlider *)slider {
    [self.drawBoard changeLineWidth:slider.value];
}
- (IBAction)changeLineColor:(UIButton *)btn {
    [self.drawBoard changeLineColor:btn.backgroundColor];
}
- (IBAction)save:(id)sender {
    //1.开启一个上下文
    UIGraphicsBeginImageContextWithOptions(self.drawBoard.frame.size, NO, 0.0);
    //2.将图片信息渲染到上下文中
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.drawBoard.layer renderInContext:context];
    //3.从上下文中生成一张图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭上下文
    UIGraphicsEndImageContext();
    //
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
}
//保存图片完成后调用的方法
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
}

- (IBAction)selectPhoto:(id)sender {
    UIAlertController * alertCtl = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoWithSource:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoWithSource:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    [alertCtl addAction:cancelAction];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ])
    {
        [alertCtl addAction:cameraAction];
    }
    [alertCtl addAction:photoAction];
    
    [self presentViewController:alertCtl animated:YES completion:^{
        
    }];
    
}
- (void)selectPhotoWithSource:(UIImagePickerControllerSourceType)sourceType
{
    //弹出相册
    UIImagePickerController * pickerImage = [[UIImagePickerController alloc]init];
    //设置照片来源
    pickerImage.sourceType = sourceType;
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
}
//当在相册中选择一张图片时，会调用这个方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
//    NSData * imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:@"/Users/cxz/Desktop/lsx.png" atomically:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    //添加view
    NJSelectView * selectView = [[NJSelectView alloc]init];
    selectView.frame = self.drawBoard.frame;
    selectView.backgroundColor = [UIColor clearColor];
    selectView.image = image;
    selectView.delegate = self;
    [self.view addSubview:selectView];
    
}
#pragma mark - NJSelectView的代理方法
- (void)selectView:(NJSelectView *)selectView WithImage:(UIImage *)image
{
    self.drawBoard.image = image;
}
@end
