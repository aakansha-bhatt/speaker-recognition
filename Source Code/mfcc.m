function [MFCCcoef, timeVec] = mfcc(s, fs, N, p, M) 
% Inputs:
%     s : speech signal
%     fs : Sampling Frequency
%     N : Frame length = window length
%     p : Number of Mel filter banks
%     M : Frame overlap length
    
% Outputs:
%     MFCCcoef : MFCC coefficents 
%     timeVec : time vector 

% Steps to extract MFCC:
% Frame the signal into short frames.
% For each frame calculate the periodogram estimate of the power spectrum.
% Apply the mel filterbank to the power spectra, sum the energy in each filter.
% Take the logarithm of all filterbank energies.
% Take the DCT of the log filterbank energies.
% Keep first few DCT coefficients, discard the 0th one and the rest.

    % using MATLAB's stft function to frame, window, and take fft
    [s,freqVec,timeVec] = stft(s, fs, 'Window', hamming(N), 'OverlapLength', M);
    
    % taking the positive half of the stft due to symmetry
    s = s((N/2):end, :);
    
    % take absolute value 
    s = abs(s);
   
   %plot(s)
    
    % Mel-frequency Wrapping using filter banks
    m = melfb(p, N, fs);
    
    % mel filter bank output
    mel_output = m*s;
    
    % 
    log_mel_output = log(mel_output);
    
    % discrete cosine transform
    MFCCcoef = dct(log_mel_output);
    
    % normalize ceptral coefficents 
    MFCCcoef = MFCCcoef ./ max(max(abs(MFCCcoef)));

    
    % exclude 0'th order cepstral coefficient as it's the mean value 
    % (doesn't provide much info)
    %  output(1,:) = [];    
   
%    consider whether to do scaling here
    
% any plotting neeed

%%%%%%%%%%% Extra %%%%%%%%%%%%%
% usage of manual stft: 
% frameLength=256;
% windowLength = frameLength;
% frameHop = 100;
% win = hamming(frameLength);
% [STFT,time, freq] = stft(s1,win,frameLength,frameHop,fs);
% STFT=mag2db(abs(STFT))
% plotSTFT(time,freq,STFT)

       
% function [STFT,time, freq] = stft(x,window,frameLength,frameHop,fs)
% % manually calculate the STFT
% 
% % represent signal as column vector 
% x = x(:);
% 
% % determine sinal length 
% sigLength = length(x);
% 
% % calculate number of frames
% numFrames = floor((sigLength-frameLength)/frameHop);
% 
% % calculate number of fft points
% nfft = 2^nextpow2(frameLength);
% 
% % calculate positive half of fft points 
% % due to symmetry, only 1/2 the points are unique  
% halfFFT = ceil((1+nfft)/2);  
% 
% % create STFT matrix
% STFT = zeros(halfFFT,numFrames);
% 
% 
% % apply window to each frame then take fft
% k = 1;
% for i = 1:numFrames
%     
%         % windowing
%         windowedSignal = window.*x(k:k+frameLength-1);
%     
%         % FFT
%         xFFT = fft(windowedSignal,nfft);
%         
%         % update STFT matrix
%         STFT(:,i) = xFFT(1:halfFFT);
%    
%         % update index
%         k = k+frameHop;
% end
% 
% % time vector
% time = (frameLength/2:frameHop:frameLength/2+(numFrames-1)*frameHop)/fs;
% 
% % frequency vector
% freq = (0:halfFFT-1)*fs/nfft;
% 
% end

% function plotSTFT(time,freq,STFT)
% surf(time, freq, STFT)
% shading interp
% axis tight
% view(0, 90)
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 13)
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% title('Short-Time Fourier Transform')
% 
% hcol = colorbar;
% set(hcol, 'FontName', 'Times New Roman', 'FontSize', 12)
% ylabel(hcol, 'Magnitude (dB)')
% 
% view(-45,65)
% colormap jet
% end

% function mel = frq2mel(freq)
% mel = 2595*log(1+freq/500);
% end

% function freq = mel2frq(mel)
% freq = 700*10^(mel/2595) - 1;
% end
end
