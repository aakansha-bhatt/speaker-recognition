# EEC-201 [Speaker Recognition]
<a name="jump_to_top"></a>
<p align="center"><i>♪ All around me were familiar faces..but now they are familiar voices...♫</i></p>
<img src=https://www.civitaslearning.com/wp-content/uploads/2017/10/cls_signal.jpg width="1000" height="200">

### Team: Broketivated Engineers
*This project was undertaken by Aakansha and Sadia in a collaborative effort to implement speaker recognition using MFCC, VQ, and LBG algorithm. Sadia has worked on pre-procressing and MFCC. Aakansha has worked on LBG, noise addition, and notch filtering. Training, testing, and analysis writing was done simultaneously.*

## Introduction
In the current world situation with a pandemic and quarantine, our voices have become ever more important, literally. There is deceased identity verification through face to face or through finger prints due to communication being restricted to mostly virtual. However, just as our faces and finger prints are unique, our voices also have distinct and differentiable characteristics. Computer programs are able to identify these features better than the human ear as demonstrated in our project. We implement a speaker recognition system using pattern recognition, or feature matching, where sequences of acoustic vectors that are extracted from input speech signals are classified into individual speaker IDs. Specifically, our system is an implementation of supervised pattern recognition where the database consists of known patterns in the training set which are compared to a test set to evaluate our classification algorithm. 

There are two methods through which speaker recognition is carried out - text dependent and text independent. The text dependent speaker recognition strategy requires the speaker to provide utterances of key words or sentences, i.e. the same text is used for both training and testing. The text independent speaker recognition strategy does not rely on specific text being spoken. 

Speaker Recognition has two phases: Enrollment and Recognition. 
- Enrollment: During enrollment, the speaker's voice is recorded and a number of the voice features are extracted to create a voice print that uniquely identifies the speaker. The voice print in our project is the training data that we have been provided. 
- Recognition: During this process, the provided speaker's audio sample is compared against the created voice print and the speaker's identity is verified. The audio sample in our project is the test data that we have been provided.

In this project, we will be implementing the text independent speaker recognition strategy by the process of feature matching techniques described below. Our obejctive is to train a voice model for each of the 11 speakers in the *Training* folder and then match them to the speech files in the *Test* folder. We will vary the paramters and add noise to test the robustness of our system.

## Methodology 

<h3> Pre-processing </h3>

In raw speech signals, noise is ubiquitous. The speech signal is generally contaminated by noise originating from various sources which alter the characteristics of the speech signals. It also degrades the speech quality and intelligibility. Speech signals also contain regions of silence which convey no necessary data. Therefore, noise reduction and silence removal is important to process the signals and save processing time and bandwidth of the system.

Pre-processing of our signals is done in the `preProcessing.m` where we remove silence regions and normalize the amplitude to one. The input speech files contain 11 speakers uttering "zero" with a sampling rate of 12.5 KHz. Three of our training speech signals are stereophonic (2 audio channels); however, for processing we extract a single channel from all signals for monophonic sound. Speaker 1's raw speech signal is shown in Figure 1. There are periods of silence before and after the voiced segment which unnecessarily increase computational time. Therefore, the silence was removed through endpoint detection. The region where the amplitude is first greater than -30 dB (0.03) is regarded as the start of the voiced speech and the region where amplitude is first lower than -30 dB is regarded as the stop point. Outside of this portion is the silence to be removed. The signal was then normalized to an user-defined maximum amplitude, to one in our case, by dividing by the current maximum of the signal as shown in Figure 2.

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/73858403/112219263-fa68b280-8be1-11eb-8627-9b17ec6a4514.png">
  <br><i> Figure 1: Original (Raw) Signal 1 </i>
</p>


<p align="center"> 
  <img src="https://user-images.githubusercontent.com/73858403/112219413-2c7a1480-8be2-11eb-8f53-78003fa3a91c.png">
  <br><i>Figure 2: Normalized and Silence Removed Signal 1</i>
</p>

<h3> Feature Extraction </h3>

Speech signals are slowly-timed varying signals and when we observe their characteristics over a long period of time, we find that they contain variations that can help distinguish between the different sounds being spoken. Therefore, a short-time spectral analysis is the most common way to characterize any speech signal. One way of representing the speech signal is by using the phenomenon called Mel Frequency Cepstrum (MFC). It is a representation of the short-term power spectrum of a speech signal, based on a linear cosine transform of a log power spectrum on a nonlinear mel scale of frequency. Mel-frequency cepstral coefficients (MFCCs) are coefficients that collectively make up an MFC.

Computation of MFCC is done in `mfcc.m` where we first frame the signals into short chunks. Using a frame size in powers of 2 allows for faster processing time. Initial analysis was done using a frame size N = 256 samples which amounts to a frame duration of 20.48 ms. Then we apply a Hamming window to each of the frames. Windowing generates a periodic signal but also causes loss of information at the ends of the frames due to smoothening. To recover this loss, we use overlapping frames where the overlap size M = 100 samples. The discrete Fourier Transform (DFT) is then calculated on a frame by frame basis, the result of which is a periodogram. Up to this step is known as Short Time Fourier Transform (STFT). Fourier transform tells what frequencies are present in a signal, but STFT tells when these frequencies occur in the linear frequency scale.

The resulting spectral matrix from STFT contains the frames of the original signal in its columns. The elements are complex and symmetrical. We take the absolute value of half of the elements and plot them as shown in the figures below for Speaker 1. In Figure 3, the highest levels of energy are shown in red with black peaks which is most prominent between 0.1 and 0.25 seconds. This energy is concentrated in lower frequency range of 90-700 Hz. The majority of the signal is contained below 4.7 KHz.

To better understand the output of STFT and its parameters, we vary the frame size and set the frame overlap to one-third of the frame size (about 33% overlap). In the first trial N = 128, the shorter time period in each frame means the spectral characteristics will be nearly constant and the time resolution is high. However, as the frame length is increased, the frequency resolution increases while the time resolution decreases. This is because if the frame is too short, it smears time-frequency distribution in the frequency dimension without a proportionate improvement in detail in the time dimension. If the frame is too long, it will fail to capture the most rapid variations of spectral content. High-frequency components will not be considered as they will be normalized over the long time-interval. So more rapidly changing spectral content need shorter frames. Thus, there is a compromise between time resolution and frequency resolution. We choose a frame length of 256 samples as the compromise for further analysis.

<p align="center"> 
   <img src="https://github.com/Supova/EEC-201/blob/main/Images/sig1%20stft_1.PNG" alt="N = 128" ">
   <br><i> Figure 3: N = 128, M = 42, Frames = 303 </i>
</p>                                                                                             

<p align="center"> 
   <img src="https://github.com/Supova/EEC-201/blob/main/Images/sig1%20stft_2.PNG" alt="N = 256" ">
   <br><i>Figure 4: N = 256, M = 86, Frames = 150 </i>
</p>
                                                                                                  
<p align="center">                                                                                                   
   <img src="https://github.com/Supova/EEC-201/blob/main/Images/sig1%20stft_3.PNG" alt="N = 512" ">
   <br><i> Figure 5: N = 512,  M = 171, Frames = 73 </i>
</p>

After performing the STFT, the next step is to carry out mel-frequency wrapping as implemented in `melfb.m`. In this process, we simulate a subjective spectrum by creating a filter bank which is spaced uniformly on the mel-scale. The mel-frequency scale is a linear frequency spacing below 1000 Hz and a logarithmic spacing above 1000 Hz. We create this spectrum because speech signals do not follow a linear scale, and hence for each tone with an actual frequency, f, a subjective pitch is to be measured and determined. 

20 triangular filters are equally spaced along the mel-scale defined by the equation below. This is a good amount without increasing the complexity of our system. It is representative of being more discriminative at lower frequencies and less discriminative at higher frequencies. The filters are spread over the whole frequency range from 0.01 up to the Nyquist frequency of 6.25 KHz as shown in Figure 6. We can however bandlimit this frequency to avoid allocating filters to frequency regions where there is no useful signal energy. The current distribution up to Nyquist frequency is kept as there are slight variations in the frequency ranges for the different speakers. The STFT coefficients are then binned by correlating them with each filter. Each coefficient is multiplied by the corresponding filter gain and the products accumulated. The result is that each bin will hold a weighted sum representing the spectral magnitude in that filterbank channel. We then take the log of the result. The effect of the mel-frequency wrapping of signal 1 is shown in Figure 7 and 8. It is observed that the spectral shape is smoothened and amplified. This also reduces the number of coefficients to the number of filterbank outputs thus achieving dimensionality reduction.

<p align="center"> 
  <img src=https://github.com/Supova/EEC-201/blob/main/Images/mel%20scale%20equation.jpeg>
  </p>

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/20%20mel%20filter%20banks.PNG">
  <br><i>Figure 6:  Mel filter bank response 1</i>
</p>

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/stft%20sig1_before%20Mel.PNG">
  <br><i>Figure 7:  Before mel-frequency wrapping</i>
</p>

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/sig1%20MelFreqWrap.PNG">
  <br><i>Figure 8:  After mel-frquency wrapping</i>
</p>

After carrying out the wrapping, the speech signal has to be converted back into the time domain, hence creating coefficients in time called MFCCs. We use the discrete cosine transform (DCT) extract most of the information of the signal to its lower order coefficients. The zeroth coefficient is often excluded since it represents the average log-energy of the signal, which carries little speaker-specific information. The first order coefficient represents the distribution of spectral energy between the low and high frequencies. Then 13 coefficients after the 0th order are taken for each time instance as shown in Figure 9. We then normalize the ceptral coefficients. After this, each voice utterance has been transformed into a sequence of acoustic vectors.

<p align="center"> 
<img src=https://github.com/Supova/EEC-201/blob/main/Images/MFCC%20Speaker1_2.PNG>
<br><i> Figure 9: MFCCs for speaker 1 and speaker 2 </i>
</p>

In the figure below, we inspect the acoustic space (MFCC vectors) of two different speakers (speaker 1 and 2) in a 2D plane to observe the different features of the speech signals - observing the overlap and similarities in the dimensions. Although there is some overlap, the non-overlapping portions will help distinguish the different speakers.

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/mfcc5_6%20speaker1_2.PNG">
<br><i> Figure 10: MFCC space for speaker 1 and speaker 2 </i>
</p>

<h3> Feature Matching </h3>

The next step in the speaker recognition process is using applying vector quantization (VQ) and the Linde-Buze-Gray (LBG) algorithm. VQ is a quantization process of data in contiguous blocks known as vectors. Quantization maps these infinite vectors into finite representative vectors. There are several techniques for quantization and the efficiency of these steps is reliant upon the generated codebooks by the training set of speech signals. Our method uses LBG algorithm to iteratively form the codebooks. First, a finite number of regions known as clusters are generated from the MFCCs. Then we partition these clusters into non-overlapping regions where every vector is represented by a corresponding centroid vector known as the code word. The code words are then grouped together to form a codebook.

The recursive process of the LBG algorithm used in `LBG.m` is as follows. First a single-vector codebook, the centroid for all training vectors, is initialized. Next the size of the codebook is doubled by splitting each current codebook by adding or subtracting epsilon, the percentage of splitting. Then for each of the training vectors, the closest codeword in the current codebook is found so the vectors can be assigned to the corresponding cell associated with the closest centroid.  Finally the codeword in each cell is updated using the centroid of training vectors assigned to that cell. The iterative process of nearest-neighbor search and centroid update is repeated until the average distance between the training vectors and centroids falls below a preset threshold. Furthermore, the iteration from the doubling of the size of the codebook step to centroid update is repeated until a preset codebook size is designed. Then the loop breaks once this condition is achieved.

Below is our image of our acoustic vectors after implementing the vector quantization with 8 centroids. There are systematic methods that can be implemented to choose the number of centroids. However, in our implementation, the number of centroids can be any number that the user chooses. The optimal number is chosen through trial and error in our case. We found that 8 centroids is a good fit that does not underfit nor overfit the clusters.

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/VQ%20acoustic%20vector%20codeblocks.PNG">
<br><i> Figure 11: MFCC space with centroids after VQ </i>
</p>

<h3> Testing </h3>

The final step for our speaker recognition system is the verification. Using the two data sets - Training and Test - we ensure that each test speaker signal is matched correctly to a training signal. We first tabulate our human recognition rate in the table below for comparison. For our speaker recognition system, we train a VQ codebook for each speaker using `train.m`. Then using `test.m`, we verify the results. We also added our individual voices labelled as "s12" and "s13". The matching results in Figure 12 show the system can recognize all speakers with 100% accuracy. After multiple runs, our system was consistent with 100% recognition rate and did not incorrectly assign any wrong IDs. We show that indeed our system is better than the human recognition rate.

<p align="center"> 
<i> Table 1: Human recognition rate </i><br>
<img src="https://user-images.githubusercontent.com/73858403/112112590-f5b8e580-8b72-11eb-996c-1224704a4517.png">
</p>

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/results.PNG">
<br><i> Figure 12: Matching </i>
</p>

#### Added Noise

To further test our system, colored noises with different SNRs were added to our signals using `add_noise.m`. Signal 1 with various noises are plotted in Figure 13. We used white, pink, brown, blue, and purple noise. The testing was done by adding one type of noise  and varying the SNR in 10 dB increments until we got a result with close to 100% accuracy. We then decreased the SNR to find the lowest SNR that gives the highest accuracy in 30 trials. We reject a SNR level if within 5 trials, 3 trials include incorrect recognition. This method was used on unprocessed and preprocessed signals for all the noises as listed below.

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/noiseaddedsig1.PNG">
<br><i> Figure 13: Noise added signals </i>
</p>

<p align="center"> 
  <i> Table 2: SNR for 100% accuracy for unprocessed signals </i><br>
<img src="https://user-images.githubusercontent.com/73858403/112204731-3e06f080-8bd1-11eb-9930-4bf75ad718b4.png">
</p>


<p align="center"> 
  <br><i> Table 3: Accuracy for preprocessed signals with colored noises </i><br>
<img src="https://user-images.githubusercontent.com/73858403/112199731-b10d6880-8bcb-11eb-9fdb-2b390b9a26b7.png">
</p>

We observed that for the white noise, we require the most SNR to get a 100% accuracy and for the brown noise, we require the least SNR. We believe that is because white noise, being a combination of all the colored noises, is the kind of noise with the highest frequency while brown is the noise with the lowest frequency. That being said, to compensate for the high frequency noises, we require a larger signal-to-noise ratio as compared to those colored noises which have low frequency. 
The color of sound chart shown below can be used for a more detailed understanding of why we observe these trends.

<p align="center"> 
<img src="https://github.com/Supova/EEC-201/blob/main/Images/noisechart.PNG">
<br><i> Figure 14: Colors of Sounds Chart </i>
</p>

When we tested our signal with added noises before and after preprocessing, we observed that before preprocessing our signals, we generally require a higher SNR to achieve a 100% accuracy. This is because preprocessing our signals rids them of any unnecessary noise and information. Hence when we add noise to our signals after preprocessing them, our system only needs a smaller signal-to-noise ratio to achieve the closest resembling test signal to that of our training signal. 

#### Notch Filter

Notch Filters reject or attenuate signals at specific frequency tones or bands called the stop band frequency range and pass the signals above and below this band. For the purpose of our experimentation, we used four notch filters that filtered out frequency tones 1250 Hz, 2500 Hz, 3750 Hz, and 5000 Hz at different Q factor values. The implementation was done directly in the `test.m` file.

<p align="center"> 
  <i> Table 4: Recognition rate for different Q factors </i><br>
<img src="https://user-images.githubusercontent.com/73858403/112113227-c656a880-8b73-11eb-9c91-c06b9ccc5760.png">
  </p>  

We observed that the smaller the quality factor, the smaller is the recognition rate. This is because Q factor is inversely proportional to the bandwidth of the band-reject filter. Due to the small Q factor and large bandwidth, we filter out some of the useful information in our signals, hence rendering our recognition system unable to correctly identify the speaker in question.

## Conclusion
From our implementation and results, we find that our speaker recognition system is fairly good. There is 100% accuracy against clean test data samples. However, our system does not tolerate a high level of noise, because the noise removal method used is not very efficient. Furthermore, the performance of the speaker recognition system is vulnerable to changes in speaker characteristics. As we age, our voices vary throughout the years and sickness may also alter our voice characteristics. Words spoken with emotions will also have changed pitch and may be harder to recognize. Also, a system may falsely recognize a recorded playback of a speaker as a true identity match. This will be a big security flaw if speaker recognition is used for access control. We realize that our system will need to be wary of these issues and needs to be more robust. We will continue to improve our system by taking this on as a personal project by using both MATLAB and Python. 

## Acknowledgements:
We would like to thank Professor Z. Ding and S. Zhang for their support and explanations for the project. We would also like to acknowledge the help received from our classmates.

We have referenced multiple papers on MFCC and VQ for further understanding.

##### Remarks:
The computational time and space complexity of our code can be further improved by combining functions and processes. By using an user-defined STFT function, the preprocessing can effectively be done after the framing within this step. More efficient algorithms for silence and noise removal can be implemented for flexibility of the system.

[Go to top](#jump_to_top)
       
