function test(testdir, n, code, N, p, M)
% Input:
%       testdir : string name of directory contains all test sound files
%       n       : number of test files in testdir
%       code    : codebooks of all trained speakers
%       N       : Frame length = window length
%       p       : Number of Mel filter banks
%       M       : Frame overlap length

% Note:
%       Sound files in testdir is supposed to be: 
%               s1.wav, s2.wav, ..., sn.wav
%
% Example:
%       >> test('C:\Audio\Test\', 11);

% read test sound file of each speaker

disp("Speaker Recognition verification:");

for k = 1:n                    
    file = sprintf('%ss%d.wav', testdir, k);
    [s, fs] = audioread(file);      
    
    % adding noise
    % [s,noise] = add_noise(s, "white", 30); % adding 30 dB of white noise
    % [s,noise] = add_noise(s, "pink", 30); % adding 30 dB of pink noise
    % [s,noise] = add_noise(s, "brown", 30); % adding 30 dB of brown noise
    % [s,noise] = add_noise(s, "blue", 30); % adding 30 dB of brown noise
    
    % notch filter computations
    % q = 1; % q factor
    % f0 = 0.4*fs; % tone that needs to be removed
    % w0 = f0 / (fs/2);
    % bw = w0/q;
    % [num,den] = iirnotch(w0,bw);
    % s = filter(num,den,s); % notch filtered signal s
    % f0 = 0.3*fs; % tone that needs to be removed
    % w0 = f0 / (fs/2);
    % bw = w0/q;
    % [num,den] = iirnotch(w0,bw);
    % s = filter(num,den,s); % notch filtered signal s
    % f0 = 0.2*fs; % tone that needs to be removed
    % w0 = f0 / (fs/2);
    % bw = w0/q;
    % [num,den] = iirnotch(w0,bw);
    % s = filter(num,den,s); % notch filtered signal s
    % f0 = 0.1*fs; % tone that needs to be removed
    % w0 = f0 / (fs/2);
    % bw = w0/q;
    % [num,den] = iirnotch(w0,bw);
    % s = filter(num,den,s); % notch filtered signal s
    
     % Compute MFCC
    v =  mfcc(s, fs, N, p, M);            
   
    distmin = inf;
    k1 = 0;
   
    % compute distortion for each trained codebook
    for l = 1:length(code)     
        d = disteu(v, code{l}); 
        dist = sum(min(d,[],2)) / size(d,1);
      
        % compare distance with threshold
        if dist < distmin
            distmin = dist;
            k1 = l;
        end      
    end
 
    % output results
    msg = sprintf('Speaker ID: %d matches with ID: %d', k, k1);
    disp(msg);
    
end
