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
         
         for(int i = 0; i < arraySize; i++) {
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
}

- (void) initSounds
{
    __weak ViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    
    
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
    
//    [self playSound:[filesToPlay count]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak ViewController * wself = self;

    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];

    
    // Basic playthru example
//    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
//        float volume = 0.5;
//        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
//        wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
//    }];
//    
//    
//    [self.audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
//        wself.ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
//    }];
    
    
     // MAKE SOME NOOOOO OIIIISSSEEE
    // ==================================================
//     [self.audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
//         {
//             for (int i = 0; i < numFrames * thisNumChannels; i++) {
////                 newdata[i] = (rand() % 100) / 100.0f / 2;
//                 newdata[i] = 10.0f;
//         }
//     }];
    
    
    // MEASURE SOME DECIBELS!
    // ==================================================
//    __block float dbVal = 0.0;
//    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
//
//        vDSP_vsq(data, 1, data, 1, numFrames*numChannels);
//        float meanVal = 0.0;
//        vDSP_meanv(data, 1, &meanVal, numFrames*numChannels);
//
//        float one = 1.0;
//        vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
//        dbVal = dbVal + 0.2*(meanVal - dbVal);
//        printf("Decibel level: %f\n", dbVal);
//        
//    }];
    
    // How would you find the amplitude from the current time?
    // Where it is in respect to PI
    // amplitude = f(t) = sin(t / inv_f * 2 * pi) = sin(t * frequency * 2 * pi)
    // after inv_f, the argument inside sin should be 2 * pi
    
    // frequency = # sin waves in a second
    // sin(0) = 0, sin(2 * pi) = 0
    // inv_f = 1/frequency (time it takes to one wave to finish)
    // sin(pi/2) = 1,
    
    
    // SIGNAL GENERATOR!
//    __block float frequency = 500.0;
//    __block float frequency2 = 5000.0;
//    __block float phase = 0.0;
//    __block float time = 0.0;
//    
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
////             if(time> 1.0) time= -1;
//         }
//     }];
    // samplingRate = # samples / second = 44100
    // samplingRate / numFrames = # times the block runs / second
    // numFrames = 512
    
//     [self.audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
//         {
//             for (int i = 0; i < numFrames * thisNumChannels; i++) {
////                 newdata[i] = (rand() % 100) / 100.0f / 2;
////                 newdata[i] = i*5;
//         }
//     }];
    
    
    // DALEK VOICE!
//     (aka Ring Modulator)
//    
//    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
//     }];
//    
//    __block float frequency = 100.0;
//    __block float phase = 0.0;
//    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         wself.ringBuffer->FetchInterleavedData(data, numFrames, numChannels);
//         
//         float samplingRate = wself.audioManager.samplingRate;
//         for (int i=0; i < numFrames; ++i)
//         {
//             for (int iChannel = 0; iChannel < numChannels; ++iChannel) 
//             {
//                 float theta = phase * M_PI * 2;
//                 data[i*numChannels + iChannel] *= sin(theta);
//             }
//             phase += 1.0 / (samplingRate / frequency);
//             if (phase > 1.0) phase = -1;
//         }
//     }];
    
    
    // VOICE-MODULATED OSCILLATOR
    
//    __block float magnitude = 0.0;
//    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         vDSP_rmsqv(data, 1, &magnitude, numFrames*numChannels);
//     }];
//    
//    __block float frequency = 100.0;
//    __block float phase = 0.0;
//    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//
//         printf("Magnitude: %f\n", magnitude);
//         float samplingRate = wself.audioManager.samplingRate;
//         for (int i=0; i < numFrames; ++i)
//         {
//             for (int iChannel = 0; iChannel < numChannels; ++iChannel) 
//             {
//                 float theta = phase * M_PI * 2;
//                 data[i*numChannels + iChannel] = magnitude*sin(theta);
//             }
//             phase += 1.0 / (samplingRate / (frequency));
//             if (phase > 1.0) phase = -1;
//         }
//     }];
    
    
    // AUDIO FILE READING OHHH YEAHHHH
    // ========================================
   [self initSounds];
    for(int i = 0; i < 10; i++) {
    [self playSound:4];
    [NSThread sleepForTimeInterval:1.0f];
    }
    
    for(int i = 0; i < 300; i++) {
        [self playSound:4];
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
