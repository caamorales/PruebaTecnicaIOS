//
//  Square.m
//  PruebaTecnicaIOS
//
//  Created by Camilo Morales on 8/3/16.
//  Copyright © 2016 SlashMobility. All rights reserved.
//

#import "SquareView.h"
#define kFramePadding 1.0

@implementation SquareView{
    CGPoint aPoint;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self setFrame:[self getlocationCorrectionFrame]];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self setFrame:[self getlocationCorrectionFrame]];
    [UIView commitAnimations];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    CGPoint delta = CGPointMake(location.x - aPoint.x, location.y - aPoint.y);
    aPoint = location;
    self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    aPoint = [touch locationInView:self.superview];
}

- (BOOL)shouldMoveToPoint:(CGPoint) location{
    CGFloat padding = self.frame.size.width / 2;
    return (location.x > padding && location.x < self.superview.frame.size.width - padding) && (location.y > padding && location.y < self.superview.frame.size.height - padding);
}

- (CGRect)getlocationCorrectionFrame{
    CGSize superViewSize = self.superview.frame.size;
    CGSize selfSize = self.frame.size;
    CGRect frame = self.frame;
    
    if (self.frame.origin.x < kFramePadding) {
        frame = CGRectMake(kFramePadding, self.frame.origin.y, selfSize.width, selfSize.height);
    }else if(self.frame.origin.x + selfSize.width + kFramePadding > superViewSize.width){
        frame = CGRectMake(superViewSize.width - selfSize.width - kFramePadding, self.frame.origin.y, selfSize.width, selfSize.height);
    }
    
    if (self.frame.origin.y < 5) {
        frame = CGRectMake(frame.origin.x, kFramePadding, selfSize.width, selfSize.height);
    }else if(self.frame.origin.y + selfSize.height +kFramePadding > superViewSize.height){
        frame = CGRectMake(frame.origin.x, superViewSize.height - selfSize.height - kFramePadding, selfSize.width, selfSize.height);
    }
    
    
    return frame;
}


@end
