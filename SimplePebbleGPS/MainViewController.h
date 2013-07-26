//
//  MainViewController.h
//  SimplePebbleGPS
//
//  Created by Jose on 7/25/13.
//  Copyright (c) 2013 Jose Rodriguez. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
    double elapsedTime;
    double distanceTraveled;
    
    __weak IBOutlet UIButton *startStopButton;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet UILabel *paceLabel;
    __weak IBOutlet UIButton *pauseButton;
}

- (IBAction)showInfo:(id)sender;
- (IBAction)startStopTouched:(id)sender;
- (IBAction)pauseTouched:(id)sender;

@end
