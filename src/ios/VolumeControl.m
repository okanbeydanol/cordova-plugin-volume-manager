#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

@interface VolumeControl : CDVPlugin {
  BOOL hasVolumeChangeSubscribers;
  NSString* callbackId; // Add this line
}

- (void)subscribeToVolumeChanges:(CDVInvokedUrlCommand*)command;
- (void)toggleMute:(CDVInvokedUrlCommand*)command;
- (void)isMuted:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;
- (void)getVolume:(CDVInvokedUrlCommand*)command;

@end

@implementation VolumeControl {
    MPVolumeView *volumeView;
    UISlider *volumeSlider;
    float previousVolume;
}

- (void)pluginInitialize {
    volumeView = [[MPVolumeView alloc] init];
    volumeView.hidden = YES;
    [self.webView addSubview:volumeView];
    previousVolume = -1.0;
    hasVolumeChangeSubscribers = NO;

    // Find the volume slider
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeSlider = (UISlider *)view;
            break;
        }
    }

    // Add observer for volume slider changes
    [volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)volumeSliderValueChanged:(UISlider *)slider {
    float volume = slider.value;
    DLog(@"Volume slider changed: %f", volume);

    if (hasVolumeChangeSubscribers) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:volume];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

- (void)subscribeToVolumeChanges:(CDVInvokedUrlCommand*)command {
    DLog(@"Subscribed to volume changes");
    hasVolumeChangeSubscribers = YES;
    callbackId = command.callbackId; // Store the callback ID

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)toggleMute:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"toggleMute");
    

    if (volumeSlider != nil) {
        if (previousVolume < 0) {
            previousVolume = volumeSlider.value;
            [volumeSlider setValue:0.0 animated:NO];
        } else {
            [volumeSlider setValue:previousVolume animated:NO];
            previousVolume = -1.0;
        }
        [volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Volume slider not found"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isMuted:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"isMuted");

    BOOL isMuted = volumeSlider.value == 0.0;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isMuted];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    float volume = [[command argumentAtIndex:0] floatValue];

    DLog(@"setVolume: [%f]", volume);

    if (volumeSlider != nil) {
        [volumeSlider setValue:volume animated:NO];
        [volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Volume slider not found"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    float currentVolume = 0.0;
    if (volumeSlider != nil) {
        currentVolume = volumeSlider.value;

        // Fallback to AVAudioSession output volume if MPVolumeSlider returns 0.0 on the first call
        if (currentVolume == 0.0) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            currentVolume = audioSession.outputVolume;
        }

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:currentVolume];
    } else {
        currentVolume = 0.0;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        currentVolume = audioSession.outputVolume;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:currentVolume];
    }
    NSLog(@"Current Volume: %f", currentVolume);

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
