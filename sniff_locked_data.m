%% Select inhalation times

win = 1024; % Set window size
N_sniff = 1024;  % Set number of sniffs to look at
loc_set = locs(5:N_sniff+4); % Pull out N_sniffs starting at idx 2

% Create windows based on locs
windows = cell(N_sniff, 1);

for ii = 1:N_sniff
    win_beg = loc_set(ii) - round(win/2);
    win_end = loc_set(ii) + round(win/2);
    windows{ii} = [win_beg win_end];
end

%% Get Ephys activity for each window in each channel
sniff_activity = zeros(N_sniff, win+1, nchannels);

for ii = 1:N_sniff
    for ch = 1:nchannels
        data = ephysx_rs(ch, windows{ii}(1):windows{ii}(2));
        
        % Calculate mean and standard deviation
        data_mean = mean(data);
        data_std = std(data);
       
        % Z-score normalization
        zscore_data = (data - data_mean) / data_std;
        sniff_activity(ii, :, ch) = zscore_data;
    end
end

% Sort by mean z-score
sorted_activity = zeros(N_sniff, win+1, nchannels);

for ch = 1:nchannels
    
    % Get row means and concatenate
    row_means = mean(sniff_activity(:,:,ch), 2);
    data_with_means = [sniff_activity(:,:,ch), row_means];
    
    % Sort by the mean column
    sorted_data_with_means = sortrows(data_with_means, size(A_with_means, 2));
    
    % Step 4: Remove the last column to get the sorted matrix
    sorted_activity(:,:,ch) = sorted_data_with_means(:, 1:end-1);
end

%% Plot
% Create a new figure
figure;

for ii = 1:nchannels
    % Arrange the subplots in a 4x4 grid
    subplot(4, 4, ii); 
    
    % Plot the data; assuming you're plotting as a 2D plot against time or some variable
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

