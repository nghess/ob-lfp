%% Select inhalation times

win = 1000; % Set window size
N_sniff = 512;  % Set number of sniffs to look at
beg = 5000;
loc_set = locs(beg:N_sniff+beg-1); % Pull out N_sniffs starting at idx 5

% Create windows based on locs
windows = cell(N_sniff, 1);

for ii = 1:N_sniff
    win_beg = loc_set(ii) - round(win/2);
    win_end = loc_set(ii) + round(win/2);
    windows{ii} = [win_beg win_end];
end

%% Get Ephys activity for each window in each channel
sniff_activity = zeros(N_sniff, win, nchannels);

for ii = 1:N_sniff
    for ch = 1:nchannels
        data = ephysx_rs(ch, windows{ii}(1):windows{ii}(2)-1);
        
        % Calculate mean and standard deviation
        data_mean = mean(data);
        data_std = std(data);
       
        % Z-score normalization
        zscore_data = (data - data_mean) / data_std;
        sniff_activity(ii, :, ch) = zscore_data;
    end
end

% Sort by mean z-score
sorted_activity = zeros(N_sniff, win, nchannels);
freq_sorted = zeros(N_sniff, win, nchannels);

for ch = 1:nchannels
    
    n_peaks = zeros(N_sniff, 1);
    
    for ii = 1:N_sniff
        freq_test = smooth(sniff_activity(ii, win/2:end, ch), 50, 'sgolay');
        [pk_test, loc_test] = findpeaks(freq_test, "MinPeakProminence", .1);
        n_peaks(ii) = loc_test(1); %length(pk_test);
    end

    % Sort the vector and get the sorting indices
    [~, sort_indices] = sort(n_peaks);

    % Combine unique rows and frequencies
    result = [sniff_activity(:,:,ch), sort_indices];

    
        
    % Sort by frequency
    sortedResult = sortrows(result, width(result));
    
    % Extract just the sorted unique rows
    %sortedResult(:, end-1) = sortedResult(:, end);
    sorted_activity(:,:,ch) = sortedResult(:, 1:end-1);

end

%% Plot
% Create a new figure
figure;

for ii = 1:nchannels
    % Arrange the subplots in a 4x4 grid
    subplot(4, 4, ii); 
    
    % Plot the data;
    imagesc(sorted_activity(:,:,ii));
    
    % Add title to the subplot to indicate the channel number
    title(['Channel ' num2str(ii)]);
    axis square;  % Make the subplot square
    
    % Set x-tick positions
    x_lim = xlim;  % get current x-axis limits
    x_middle = mean(x_lim);  % Calculate the middle point of x-axis
    xticks([x_middle - 500, x_middle, x_middle + 500]);
    
    % Set labels
    yticklabels([])
    yticks([])
    xticklabels({'-500', '0', '500'});
end


