% main execution
clear all;

%%% Input parameters
% Frame length = window length
N = 256;

% Number of Mel filter banks
p = 20;

% Frame overlap length
%M = round(N*2/3);
M=100;

% read input speech signal
[sig1,fs1] = audioread('s1.wav');
[sig2,fs2] = audioread('s2.wav');

% take channel 1
sig1 = sig1(:,1);
sig2 = sig2(:,1);

% pre-process to remove silence and normalize amplitude to 1
sig1 = preProcressing(sig1, 1);
sig2 = preProcressing(sig2, 1);
 
%plot_timeDomain(s1,1)

% calculate MFCC coefficients
[MFCC1, timeVec] = mfcc(sig1, fs1, N, p, M);
[MFCC2, timeVec] = mfcc(sig2, fs2, N, p, M);

% plot ceptral coefficents 
plot_ceptrum(timeVec, MFCC1, p, 1)
%plot_ceptrum(timeVec, MFCC1, p, 1)

%plotting mfcc clusters
c1 = MFCC1;
c2 = MFCC2;
% plot(c1(5, :), c1(6, :), 'or');
% hold on;
% plot(c2(5, :), c2(6, :), 'xb');
% xlabel('5th Dimension');
% ylabel('6th Dimension');
% legend('Signal 1', 'Signal 2');
% title('2D plot of accoustic vectors');

d1 = vqlbg(c1,10);
d2 = vqlbg(c2,10);
plot(c1(5, :), c1(6, :), 'xr')
hold on
plot(d1(5, :), d1(6, :), 'vk')
plot(c2(5, :), c2(6, :), 'xb')
plot(d2(5, :), d2(6, :), '+k')
xlim([-0.5,0.5]); ylim([-0.5,0.5]);
xlabel('mfcc_5'); ylabel('mfcc_6');
legend('Speaker 1', 'Codebook 1', 'Speaker 2', 'Codebook 2');
title('VQ plot of accoustic vectors');
title('2D plot of accoustic vectors');
legend('Speaker 1', 'Speaker 2')
grid on
        
         

% plot time domain
function plot_timeDomain(signal,speaker_id)
plot(signal)
xlabel('Time (s)');
ylabel('Amplitude');
title(strcat('Speaker: ', int2str(speaker_id)) );
end



function plot_ceptrum(timeVec, MFCCcoef, p, speaker_id)
    figure; 
    surf(timeVec, 1:p, MFCCcoef,'EdgeColor','none'); 
  % surf(1:13, timeVec, MFCCcoef,'EdgeColor','none'); 
    view(0, 90); 
    colorbar;
    xlim([min(timeVec), max(timeVec)]); 
    ylim([1 13]);
    xlabel('Time (s)'); ylabel('Ceptral Coefficients');
    title(strcat('MFCC of Speaker ID: ', int2str(speaker_id)) );
end


