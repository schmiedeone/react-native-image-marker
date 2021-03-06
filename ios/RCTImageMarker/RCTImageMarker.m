//
//  RCTImageMarker.m
//  RCTImageMarker
//
//  Created by Jimmy on 16/7/18.
//  Copyright © 2016年 Jimmy. All rights reserved.
//

#import "RCTImageMarker.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTImageSource.h>
#include <CoreText/CTFont.h>
#include <CoreText/CTStringAttributes.h>
#include "RCTConvert+ImageMarker.h"

typedef enum{
    TopLeft = 0,
    TopCenter = 1,
    TopRight = 2,
    BottomLeft = 3,
    BottomCenter = 4,
    BottomRight = 5,
    Center = 6
} MarkerPosition;

@implementation RCTConvert(MarkerPosition)

RCT_ENUM_CONVERTER(MarkerPosition,
                   (@{
                      @"topLeft" : @(TopLeft),
                      @"topCenter" : @(TopCenter),
                      @"topRight" : @(TopRight),
                      @"bottomLeft": @(BottomLeft),
                      @"bottomCenter": @(BottomCenter),
                      @"bottomRight": @(BottomRight),
                      @"center": @(Center)
                      }), BottomRight, integerValue)

@end

@implementation ImageMarker




@synthesize  bridge = _bridge;



RCT_EXPORT_MODULE();

void saveImageForMarker(NSString * fullPath, UIImage * image, float quality)
{
    NSData* data = UIImageJPEGRepresentation(image, quality / 100.0);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}


NSString * generateCacheFilePathForMarker(NSString * ext, NSString * filename)
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cacheDirectory = [paths firstObject];
    if (NULL != filename && nil != filename && filename.length > 0) {
        if ([filename hasSuffix: ext]) {
            return [cacheDirectory stringByAppendingPathComponent:filename];
        } else {
            NSString* fullName = [NSString stringWithFormat:@"%@%@", filename, ext];
            return [cacheDirectory stringByAppendingPathComponent:fullName];
        }
    } else {
        NSString* name = [[NSUUID UUID] UUIDString];
        NSString* fullName = [NSString stringWithFormat:@"%@%@", name, ext];
        NSString* fullPath = [cacheDirectory stringByAppendingPathComponent:fullName];
        return fullPath;
    }
}

UIImage * markerImgWithText(UIImage *image, NSString* text, CGFloat X, CGFloat Y, UIColor* color, UIFont* font, CGFloat scale, NSShadow* shadow){
    int w = image.size.width;
    int h = image.size.height;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary *attr = @{
                           NSFontAttributeName: font,   //设置字体
                           NSForegroundColorAttributeName : color,      //设置字体颜色
                           NSShadowAttributeName : shadow
                           };
    CGRect position = CGRectMake(X, Y, w, h);
    [text drawInRect:position withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
    
}

/**
 *
 */
UIImage * markeImageWithImage(UIImage *image, UIImage * waterImage, CGFloat X, CGFloat Y, CGFloat scale,  CGFloat markerScale ){
    int w = image.size.width;
    int h = image.size.height;
    
    int ww = waterImage.size.width * markerScale;
    int wh = waterImage.size.height * markerScale;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    CGRect position = CGRectMake(X, Y, ww, wh);
    [waterImage drawInRect:position];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

UIImage * markeImageWithImageByPostion(UIImage *image, UIImage * waterImage, MarkerPosition position, CGFloat scale, CGFloat markerScale) {
    int w = image.size.width;
    int h = image.size.height;
    
    int ww = waterImage.size.width * markerScale;
    int wh = waterImage.size.height * markerScale;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    CGSize size = CGSizeMake(ww, wh);
    
    
    CGRect rect;
    
    switch (position) {
        case TopLeft:
            rect = (CGRect){
                CGPointMake(20, 20),
                size
            };
            break;
        case TopCenter:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, 20),
                size
            };
            break;
        case TopRight:
            rect = (CGRect){
                CGPointMake((w-size.width-20), 20),
                size
            };
            break;
        case BottomLeft:
            rect = (CGRect){
                CGPointMake(20, h-size.height-20),
                size
            };
            break;
        case BottomCenter:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, h-size.height-20),
                size
            };
            break;
        case BottomRight:
            rect = (CGRect){
                CGPointMake(w-(size.width), h-size.height-20),
                size
            };
            break;
        case Center:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, (h-size.height)/2),
                size
            };
            break;
        default:
            rect = (CGRect){
                CGPointMake(20, 20),
                size
            };
            break;
    }
    
    [waterImage drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    
}


UIImage * markerImgWithTextByPostion    (UIImage *image, NSString* text, MarkerPosition position, UIColor* color, UIFont* font, CGFloat scale, NSShadow* shadow){
    int w = image.size.width;
    int h = image.size.height;
    
    NSDictionary *attr = @{
                           NSFontAttributeName: font,   //设置字体
                           NSForegroundColorAttributeName : color,      //设置字体颜色
                           NSShadowAttributeName : shadow
                           };
    
    CGSize size = [text sizeWithAttributes:attr];
    
    //    CGSize size = CGSizeMake(fontSize, height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    CGRect rect;
    switch (position) {
        case TopLeft:
            rect = (CGRect){
                CGPointMake(20, 20),
                size
            };
            break;
        case TopCenter:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, 20),
                size
            };
            break;
        case TopRight:
            rect = (CGRect){
                CGPointMake((w-size.width-20), 20),
                size
            };
            break;
        case BottomLeft:
            rect = (CGRect){
                CGPointMake(20, h-size.height-20),
                size
            };
            break;
        case BottomCenter:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, h-size.height-20),
                size
            };
            break;
        case BottomRight:
            rect = (CGRect){
                CGPointMake(w-(size.width), h-size.height-20),
                size
            };
            break;
        case Center:
            rect = (CGRect){
                CGPointMake((w-(size.width))/2, (h-size.height)/2),
                size
            };
            break;
        default:
            rect = (CGRect){
                CGPointMake(20, 20),
                size
            };
            break;
    }
    [text drawInRect:rect withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
    
}

- (UIColor *)getColor:(NSString *)hexColor {
    NSString *string = [hexColor substringFromIndex:1];//去掉#号
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    /* 调用下面的方法处理字符串 */
    red = [self stringToInt:[string substringWithRange:range]];
    
    range.location = 2;
    green = [self stringToInt:[string substringWithRange:range]];
    range.location = 4;
    blue = [self stringToInt:[string substringWithRange:range]];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
- (int)stringToInt:(NSString *)string {
    
    unichar hex_char1 = [string characterAtIndex:0]; /* 两位16进制数中的第一位(高位*16) */
    int int_ch1;
    if (hex_char1 >= '0' && hex_char1 <= '9')
        int_ch1 = (hex_char1 - 48) * 16;   /* 0 的Ascll - 48 */
    else if (hex_char1 >= 'A' && hex_char1 <='F')
        int_ch1 = (hex_char1 - 55) * 16; /* A 的Ascll - 65 */
    else
        int_ch1 = (hex_char1 - 87) * 16; /* a 的Ascll - 97 */
    unichar hex_char2 = [string characterAtIndex:1]; /* 两位16进制数中的第二位(低位) */
    int int_ch2;
    if (hex_char2 >= '0' && hex_char2 <='9')
        int_ch2 = (hex_char2 - 48); /* 0 的Ascll - 48 */
    else if (hex_char1 >= 'A' && hex_char1 <= 'F')
        int_ch2 = hex_char2 - 55; /* A 的Ascll - 65 */
    else
        int_ch2 = hex_char2 - 87; /* a 的Ascll - 97 */
    return int_ch1+int_ch2;
}

-(NSShadow*)getShadowStyle:(NSDictionary *) shadowStyle
{
    if (shadowStyle != nil) {
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowBlurRadius = [RCTConvert CGFloat: shadowStyle[@"radius"]];
        shadow.shadowOffset = CGSizeMake([RCTConvert CGFloat: shadowStyle[@"dx"]], [RCTConvert CGFloat: shadowStyle[@"dy"]]);
        UIColor* color = [self getColor:shadowStyle[@"color"]];
        shadow.shadowColor = color != nil? color : [UIColor grayColor];
        return shadow;
    } else {
        return nil;
    }
}

RCT_EXPORT_METHOD(addText: (nonnull NSDictionary *)src
                  text:(nonnull NSString*)text
                  X:(CGFloat)X
                  Y:(CGFloat)Y
                  color:(NSString*)color
                  fontName:(NSString*)fontName
                  fontSize:(CGFloat)fontSize
                  shadowStyle:(nullable NSDictionary *)shadowStyle
                  scale:(CGFloat)scale
                  quality:(NSInteger) quality
                  filename: (NSString *)filename
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* fullPath = generateCacheFilePathForMarker(@".jpg", filename);
    //这里之前是loadImageOrDataWithTag
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:src] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            image = [[UIImage alloc] initWithContentsOfFile:src[@"uri"]];
            if (image == nil) {
                NSLog(@"Can't retrieve the file from the path");
                
                reject(@"error", @"Can't retrieve the file from the path.", error);
                return;
            }
        }
        
        // Do mark
        UIFont* font = [UIFont fontWithName:fontName size:fontSize];
        UIColor* uiColor = [self getColor:color];
        NSShadow* shadow = [self getShadowStyle: shadowStyle];
       
        
        UIImage * scaledImage = markerImgWithText(image, text, X, Y , uiColor, font, scale, shadow);
        if (scaledImage == nil) {
            NSLog(@"Can't mark the image");
            reject(@"error",@"Can't mark the image.", error);
            return;
        }
        NSLog(@" file from the path");
        
        saveImageForMarker(fullPath, scaledImage, quality);
        resolve(fullPath);
    }];
}

RCT_EXPORT_METHOD(addTextByPostion: (nonnull NSDictionary *)src
                  text:(nonnull NSString*)text
                  position:(MarkerPosition)position
                  color:(NSString*)color
                  fontName:(NSString*)fontName
                  fontSize:(CGFloat)fontSize
                  shadowStyle:(NSDictionary *)shadowStyle
                  scale:(CGFloat)scale
                  quality:(NSInteger) quality
                  filename: (NSString *)filename
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* fullPath = generateCacheFilePathForMarker(@".jpg", filename);
    //这里之前是loadImageOrDataWithTag
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:src] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            NSString* path = src[@"uri"];
            if ([path hasPrefix:@"data:"] || [path hasPrefix:@"file:"]) {
                NSURL *imageUrl = [[NSURL alloc] initWithString:path];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            } else {
                image = [[UIImage alloc] initWithContentsOfFile:path];
            }
            if (image == nil) {
                reject(@"error", @"Can't retrieve the file from the path.", error);
                return;
            }
        }
        
        // Do mark
        UIFont* font = [UIFont fontWithName:fontName size:fontSize];
        UIColor* uiColor = [self getColor:color];
        NSShadow* shadow = [self getShadowStyle: shadowStyle];
        UIImage * scaledImage = markerImgWithTextByPostion(image, text, position, uiColor, font, scale, shadow);
        if (scaledImage == nil) {
            NSLog(@"Can't mark the image");
            reject(@"error",@"Can't mark the image.", error);
            return;
        }
        NSLog(@" file from the path");
        
        saveImageForMarker(fullPath, scaledImage, quality);
        resolve(fullPath);
    }];
}


RCT_EXPORT_METHOD(markWithImage: (nonnull NSDictionary *)src
                  markImagePath: (nonnull NSDictionary *)markerSrc
                  X:(CGFloat)X
                  Y:(CGFloat)Y
                  scale:(CGFloat)scale
                  markerScale: (CGFloat) markerScale
                  quality:(NSInteger) quality
                  filename: (NSString *)filename
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* fullPath = generateCacheFilePathForMarker(@".jpg", filename);
    //这里之前是loadImageOrDataWithTag
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:src] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            NSString* path = src[@"uri"];
            image = [[UIImage alloc] initWithContentsOfFile:path];
            if (image == nil) {
                NSLog(@"Can't retrieve the file from the path");
                
                reject(@"error", @"Can't retrieve the file from the path.", error);
                return;
            }
        }
        
        [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:markerSrc] callback:^(NSError *markerError, UIImage *marker) {
            if (markerError || marker == nil) {
                NSString* path = markerSrc[@"uri"];
                marker = [[UIImage alloc] initWithContentsOfFile:path];
                if (marker == nil) {
                    NSLog(@"Can't retrieve the file from the path");
                    
                    reject(@"error", @"Can't retrieve the file from the path.", markerError);
                    return;
                }
            }
            // Do mark
            UIImage * scaledImage = markeImageWithImage(image, marker, X, Y, scale, markerScale);
            if (scaledImage == nil) {
                NSLog(@"Can't mark the image");
                reject(@"error",@"Can't mark the image.", error);
                return;
            }
            NSLog(@" file from the path");
            
            saveImageForMarker(fullPath, scaledImage, quality);
            resolve(fullPath);
        }];
    }];
}

RCT_EXPORT_METHOD(markWithImageByPosition: (nonnull NSDictionary *)src
                  markImagePath: (nonnull NSDictionary *)markerSrc
                  position:(MarkerPosition)position
                  scale:(CGFloat)scale
                  markerScale:(CGFloat)markerScale
                  quality: (NSInteger) quality
                  filename: (NSString *)filename
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* fullPath = generateCacheFilePathForMarker(@".jpg", filename);
    //这里之前是loadImageOrDataWithTag
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:src] callback:^(NSError *error, UIImage *image) {
        if (error || image == nil) {
            NSString* path = src[@"uri"];
            image = [[UIImage alloc] initWithContentsOfFile:path];
            if (image == nil) {
                NSLog(@"Can't retrieve the file from the path");
                
                reject(@"error", @"Can't retrieve the file from the path.", error);
                return;
            }
        }
        
        //        RCTImageSource *imageSource = [RCTConvert RCTImageSource:markerPath];
        
        [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:markerSrc] callback:^(NSError *markerError, UIImage *marker) {
            if (markerError || marker == nil) {
                NSString* path = markerSrc[@"uri"];
                marker = [[UIImage alloc] initWithContentsOfFile:path];
                if (marker == nil) {
                    NSLog(@"Can't retrieve the file from the path");
                    
                    reject(@"error", @"Can't retrieve the file from the path.", markerError);
                    return;
                }
            }
            // Do mark
            UIImage * scaledImage = markeImageWithImageByPostion(image, marker, position, scale, markerScale);
            if (scaledImage == nil) {
                NSLog(@"Can't mark the image");
                reject(@"error",@"Can't mark the image.", error);
                return;
            }
            NSLog(@" file from the path");
            
            saveImageForMarker(fullPath, scaledImage, quality);
            resolve(fullPath);
        }];
    }];
}





@end
