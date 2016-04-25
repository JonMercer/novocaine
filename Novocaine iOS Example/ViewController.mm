// Copyright (c) 2012 Alex Wiltschko
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) RingBuffer *ringBuffer;

@end

@implementation ViewController

- (void)dealloc
{
    delete self.ringBuffer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)playSound:(int)arraySize
{
    
    __weak ViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         // numFrames = 512
         // samplingFrequency = 44100
         // length of float *data is numChannels * numFrames.
         float dataSum[numChannels * numFrames];
         // initialize dataSum to 0
         for(int i = 0; i < numChannels * numFrames; i++) {
             dataSum[i] = 0.0f;
         }
         
         for(int i = 0; i < arraySize; i++) {
             AudioFileReader *audioFilereader = (AudioFileReader*)[wself.fileReaders objectAtIndex:i];
             [audioFilereader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
             NSLog(@"Time: %f", ((AudioFileReader*)[wself.fileReaders objectAtIndex:i]).currentTime);
         
            // just keep adding the values in data to dataSum

             for (int j=0; j < numFrames * numChannels; ++j)
             {
                 dataSum[j] += data[j] * 0.01;
             }
         } // for(int i = 0; i < arraySize; i++)
         
         for(int i = 0; i < numChannels * numFrames; i++) {
             data[i] = dataSum[i];
         }


     }];
    [self.audioManager play];
}

- (void) initSounds
{
    __weak ViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    
    
//    NSArray *filesToPlay = @[@"0",
//                             @"12",
//                             @"78",
//                             @"90"];
    
    NSArray *filesToPlay = @[@"0",
                             @"1",
                             @"2",
                             @"3",
                             @"4",
                             @"5",
                             @"6",
                             @"7",
                             @"8",
                             @"9",
                             @"10",
                             @"11",
                             @"12",
                             @"13",
                             @"14",
                             @"15",
                             @"16",
                             @"17",
                             @"18",
                             @"19",
                             @"20",
                             @"21",
                             @"22",
                             @"23",
                             @"24",
                             @"25",
                             @"26",
                             @"27",
                             @"28",
                             @"29",
                             @"30",
                             @"31",
                             @"32",
                             @"33",
                             @"34",
                             @"35",
                             @"36",
                             @"37",
                             @"38",
                             @"39",
                             @"40",
                             @"41",
                             @"42",
                             @"43",
                             @"44",
                             @"45",
                             @"46",
                             @"47",
                             @"48",
                             @"49",
                             @"50",
                             @"51",
                             @"52",
                             @"53",
                             @"54",
                             @"55",
                             @"56",
                             @"57",
                             @"58",
                             @"59",
                             @"60",
                             @"61",
                             @"62",
                             @"63",
                             @"64",
                             @"65",
                             @"66",
                             @"67",
                             @"68",
                             @"69",
                             @"70",
                             @"71",
                             @"72",
                             @"73",
                             @"74",
                             @"75",
                             @"76",
                             @"77",
                             @"78",
                             @"79",
                             @"80",
                             @"81",
                             @"82",
                             @"83",
                             @"84",
                             @"85",
                             @"86",
                             @"87",
                             @"88",
                             @"89",
                             @"90"];
    
    
    
    
    
    
    
    self.fileReaders = [[NSMutableArray alloc]init];
    
    for(int i = 0; i< [filesToPlay count]; i ++) {
        
        NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", filesToPlay[i]] withExtension:@"mp3"];
        
        //[inputURLs addObject:inputFileURL];
        
        AudioFileReader *fileReader = [[AudioFileReader alloc]
                                       initWithAudioFileURL:inputFileURL
                                       samplingRate:self.audioManager.samplingRate
                                       numChannels:self.audioManager.numOutputChannels];
        
        [self.fileReaders addObject:fileReader];
        
        [((AudioFileReader*)[wself.fileReaders objectAtIndex:i]) play];
    }
    
//    [self playSound:[filesToPlay count]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak ViewController * wself = self;

    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];

    
    
    // AUDIO FILE READING OHHH YEAHHHH
    // ========================================
   [self initSounds];
//    [self playSound:30];
    for(int i = 0; i < 100; i++) {
    
        // the argument should be an array of floats of lengh 91
        // each float representing how loud we should play each sound
        // 0 being minimum and 1 being maximum
        
    [self playSound:30];
    [NSThread sleepForTimeInterval:0.5f];
    }
    
    for(int i = 0; i < 300; i++) {
        [self playSound:91];
        [NSThread sleepForTimeInterval:1.0f];
    }


     /*
    NSArray *filesToPlay = @[@"0",
                             @"12",
                             @"78",
                             @"90"];
    



    self.fileReaders = [[NSMutableArray alloc]init];
 
    for(int i = 0; i< [filesToPlay count]; i ++) {
        
        NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", filesToPlay[i]] withExtension:@"mp3"];
        
        //[inputURLs addObject:inputFileURL];
        
        AudioFileReader *fileReader = [[AudioFileReader alloc]
                           initWithAudioFileURL:inputFileURL
                           samplingRate:self.audioManager.samplingRate
                           numChannels:self.audioManager.numOutputChannels];
        
        [self.fileReaders addObject:fileReader];

        [((AudioFileReader*)[wself.fileReaders objectAtIndex:i]) play];
    }

    [self playSound:[filesToPlay count]];

    
   
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         // numFrames = 512
         // samplingFrequency = 44100
         // length of float *data is numChannels * numFrames.
         float dataSum[numChannels * numFrames];
         
         for(int i = 0; i < [filesToPlay count]; i++) {
//             [wself.fileReaders[i] retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
             [((AudioFileReader*)[wself.fileReaders objectAtIndex:i]) retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
             NSLog(@"Time: %f", ((AudioFileReader*)[wself.fileReaders objectAtIndex:i]).currentTime);
             
             if(i == 0) {
                 for (int i=0; i < numFrames * numChannels; ++i)
                 {
                     dataSum[i] = data[i];
                 }
             } else {
                 for (int i=0; i < numFrames * numChannels; ++i)
                 {
                     data[i] += dataSum[i];
                 }
             }
         }
     }];
    [self.audioManager play];
     
     */
    
//    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         
//         float samplingRate = wself.audioManager.samplingRate;
//         for (int i=0; i < numFrames; ++i)
//         {
//             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
//             {
//                 float theta = time * frequency * M_PI * 2;
//                 float theta2 = time * frequency2 * M_PI * 2;
//                 float amplitude = sin(theta);
//                 float amplitude2 = sin(theta2);
//                 data[i*numChannels + iChannel] = amplitude + amplitude2; // amplitude
//             }
//             time += 1 / samplingRate;
//             //             if(time> 1.0) time= -1;
//         }
//     }];

    
//    [self.audioManager play];
    
    // AUDIO FILE WRITING YEAH!
    // ========================================    
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], 
//                               @"My Recording.m4a", 
//                               nil];
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//    NSLog(@"URL: %@", outputFileURL);
//    
//    self.fileWriter = [[AudioFileWriter alloc]
//                       initWithAudioFileURL:outputFileURL 
//                       samplingRate:self.audioManager.samplingRate
//                       numChannels:self.audioManager.numInputChannels];
//    
//    
//    __block int counter = 0;
//    self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
//        [wself.fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
//        counter += 1;
//        if (counter > 400) { // roughly 5 seconds of audio
//            wself.audioManager.inputBlock = nil;
//        }
//    };

    // START IT UP YO
//    [self.audioManager play];
//    if([self.audioManager playing]) {
//        NSLog(@"#$#$#$#$#$#$#$#$#$#playing");
//    }
//    [NSThread sleepForTimeInterval:2.0f];
//    if(![self.audioManager playing]) {
//        NSLog(@"Not playing22222");
//    }
//    [self.audioManager pause];
//    if(![self.audioManager playing]) {
//        NSLog(@"Not playing");
//    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
