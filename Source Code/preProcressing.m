function sig = preProcressing(signal, maxAmp)

% silence removal
 sig_wo_silence = silence_remove(signal);
 
% normalize  
 scaled_Sig = ampNormalize(sig_wo_silence, maxAmp);
 
 sig = scaled_Sig;
  
function scaled_Sig = ampNormalize(signal, maxAmp)
%     Normalize or scale the amplitude to a value specified
% 
%     Input Parameters : 
%                signal       Input signal
%                maxAmp       Expected peak value (0 ~ 1)
%     Output Parameters:  
%                scaled_sig     Scaled signal

    scaled_Sig = zeros(length(signal),1);
    if( maxAmp > 1 || maxAmp < 0 )
        fprintf('(ampMax) out of bound.');
    else
        if max(signal) > abs(min(signal))
            scaled_Sig = signal*(maxAmp/max(signal));
        else
            scaled_Sig = signal*((-maxAmp)/min(signal));
        end
    end

end
 
function sig = silence_remove(signal)
% remove silence by taking portions above 0.03
          
crit = abs(signal) > 0.03;
sig = signal(find(crit, 1, 'first'):find(crit, 1, 'last'));
end
  
end
