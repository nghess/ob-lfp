%% Reshape Binary Data

% Ephys
nchannels = 16;
ephysx = reshape(ephysx, [], 1);
ephysx = reshape(ephysx,[nchannels, round(length(ephysx)/nchannels)]); % Reshape binary vector to N channel matrix

%% Sniff
sniff_nchannels = 8;
adcx = reshape(adcx, [], 1);
adcx = reshape(adcx,[sniff_nchannels, round(length(adcx)/sniff_nchannels)]); % Reshape binary vector to N channel matrix

%% Get Sniff Signal
ch = 8;
sniff = adcx(ch, :); % Sniff signal should be in channel 8

% correct jumps in sniff signal
for x = 1:length(sniff)
    if sniff(x) > 40000
        sniff(x) = sniff(x) - 65520;
    end
end

sniff = resample(sniff,1,30);
sniff_smooth = smooth(sniff,25,'sgolay');
%plot(sniff(1:150000));

%% Correct jumps in Ephys Signal
for ch = 1:nchannels
    for x = 1:length(ephysx(ch,:))
        if ephysx(ch, x) > 40000
            ephysx(ch, x) = ephysx(ch, x) - 65520;
        end
    end
end

%% Visualize Ephys channels with inhalation times

% Window to plot
window = 30000;
window_start = 500000;
window_end = window_start + window;

% Set up plot
clf
cmap = colormap('jet');
colorIndices = round(linspace(1, size(cmap, 1), nchannels));

for ii = 3%:nchannels
    
    % Plot traces
    p = plot(ephysx(ii, window_start:window_end));
    color = cmap(colorIndices(ii), :); 
    p.Color = color;  % Set the color

    % Add a label at the trace and legend
    label_str = "Ch " + num2str(ii);
    p.DisplayName = "Ch " + num2str(ii);
    end_val = ephysx(ii,window); % Y position of label
    t = text(window, end_val-5, label_str, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    t.Color = color;

    hold on
    

end
%plot(sniff(window_start:window_end));
legend()
hold off
