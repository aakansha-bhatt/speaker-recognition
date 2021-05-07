function code = train(traindir,n, N, p, M)
% Speaker Recognition: Training Stage
%
% Input:
%       traindir : string name of directory contains all train sound files
%       n        : number of train files in traindir
%       m        : number of centroids required
%
% Output:
%       code     : trained VQ codebooks, code{i} for i-th speaker
%
% Note:
%       Sound files in traindir is supposed to be: 
%                       s1.wav, s2.wav, ..., sn.wav
% Usage:
%       >> code = train('C:\Audio\Training\', 11);

% number of centroids required
m = 10;

% train a VQ codebook for each speaker
for i = 1:n                     
    file = sprintf('%ss%d.wav', traindir, i);           
    disp(file)
   
    % read in all audio files
    [s, fs] = audioread(file);
    
    % Compute MFCC
    v = mfcc(s, fs, N, p, M); 
    
    % Train VQ codebook
    code{i} = LBG(v, m);      
end
