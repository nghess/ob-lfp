%% Reshape Binary Data

% Ephys
nchannels = 16;
ephysx = reshape(ephysx, [], 1);
ephysx = reshape(ephysx,[nchannels, round(length(ephysx)/nchannels)]); % Reshape binary vector to N channel matrix

% Sniff
sniff_nchannels = 8;
adcx = reshape(adcx, [], 1);
adcx = reshape(adcx,[sniff_nchannels, round(length(adcx)/sniff_nchannels)]); % Reshape binary vector to N channel matrix

%% Isolate Sniff Signal
ch = 8;
sniff = adcx(ch, :); % Sniff signal should be in channel 8

% correct jumps in sniff signal
for x = 1:length(sniff)
    if sniff(x) > 40000
        sniff(x) = sniff(x) - 65520;
    end
end

%% Correct jumps in Ephys Signal
for ch = 1:nchannels
    for x = 1:length(ephysx(ch,:))
        if ephysx(ch, x) > 40000
            ephysx(ch, x) = ephysx(ch, x) - 65520;
        end
    end
end

%% Resample Sniff signals to 1khz
resample_factor = 30;

sniff = resample(sniff, 1, resample_factor);
sniff_smooth = smooth(sniff, 25, 'sgolay');

%% Find inhalation times
[pks, locs] = findpeaks(sniff_smooth, 'MinPeakProminence', 50);

%% Resample Ephys to 1khz
% Initialize resampled ephys matrix
N_rs = width(ephysx) / 30;
ephysx_rs = zeros(16, N_rs);

% Resample each channel in ephys data
for i = 1:16
    ephysx_rs(i,:) = resample(ephysx(i,:), 1, resample_factor);
end


