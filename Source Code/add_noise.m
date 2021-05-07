function [s_with_noise, noise] = add_noise(s, noisetype, snr)

    threshold = 10; % 10 dB

    % Set param
    num_samples = length(s);
    num_channels = 1;
    
    bounded_output = (noisetype ~= "brown");

    % Get Noise
    noise_function = dsp.ColoredNoise(noisetype, num_samples, num_channels, 'BoundedOutput', bounded_output);
    noise = noise_function();

    % Scale to specified dB
    scale = db2mag(-1*snr-threshold) * max(abs(s));
    
    scale = scale / max(abs(noise)); % Normalized
    
    noise = scale .* noise;

    % Add noise to output
    s_with_noise = s + noise;
    
end
