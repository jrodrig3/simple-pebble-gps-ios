//
//  MainViewController.m
//  SimplePebbleGPS
//
//  Created by Jose on 7/25/13.
//  Copyright (c) 2013 Jose Rodriguez. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Main View

- (IBAction)startStopTouched:(id)sender {
    if([startStopButton.titleLabel.text isEqualToString: NSLocalizedString(@"Start", nil)]) {
        [self resetStats];
        [self startGPS];
        [startStopButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
        [pauseButton setHidden: NO];

    } else if([startStopButton.titleLabel.text isEqualToString: NSLocalizedString(@"Stop", nil)]) {
        [self stopGPS];
        [startStopButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [pauseButton setHidden: YES];
    }
}

- (IBAction)pauseTouched:(id)sender {
    if(lastLocation == nil) {
        [self startGPS];
    } else {
        [self stopGPS];
        lastLocation = nil;
    }
}

#pragma mark - Observed actions

- (void)resetStats {
    [self setElapsedTime:0];
    [self setDistanceTraveled:0];
    lastLocation = nil;
}

- (void)addElapsedTime: (double)elapsed {
    elapsedTime += elapsed;
    [self updateTimeLabel];
}

- (void)setElapsedTime: (double)elapsed {
    elapsedTime = elapsed;
    [self updateTimeLabel];
}

- (void)addDistanceTraveled: (float)distance {
    distanceTraveled += distance;
    [self updateDistanceTraveled];
}

- (void)setDistanceTraveled: (float)distance {
    distanceTraveled = distance;
    [self updateDistanceTraveled];
}

- (void)updateLabels {
    [self updateTimeLabel];
    [self updateDistanceTraveled];
    [self updatePace];
}

- (void)updateTimeLabel {
    unsigned int temp = elapsedTime;
    
    timeLabel.text = [NSString stringWithFormat:@"%.2u:%.2u:%.2u", temp / (60 * 60), temp / 60 % 60, temp % 60];
}

- (void)updateDistanceTraveled {
    distanceLabel.text = [NSString stringWithFormat:@"%.2f", [self metersToMiles:distanceTraveled]];
}

- (void)updatePace {
    double tempDistance = [self metersToMiles:distanceTraveled];
    double pace = tempDistance / (elapsedTime / (60 * 60));
    
    paceLabel.text = [NSString stringWithFormat:@"%.2f", pace];
}

#pragma mark - GPS Support

- (double)metersToMiles: (double)meters
{
    return meters * 0.00062137;
}

- (void)startGPS
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    [locationManager startUpdatingLocation];
}

- (void)stopGPS
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0) {        
        if(lastLocation != nil) {
            [self addDistanceTraveled:[location distanceFromLocation:lastLocation]];
            [self addElapsedTime:[eventDate timeIntervalSinceDate:lastLocation.timestamp]];
            [self updatePace];
        }
        lastLocation = location;
    }
}

@end
