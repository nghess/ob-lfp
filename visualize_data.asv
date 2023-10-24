%% Plot sniff peaks against signal

% Define window to plot
window = 30000;
win_beg = 1;
win_end = win_beg + window;

% Find nearest peak to window start and ending
beg_diff = abs(locs - win_beg);
end_diff = abs(locs - win_end);
[~, beg_idx] = min(beg_diff);
[~, end_idx] = min(end_diff);

% Plot
clf
plot(sniff_smooth(locs(beg_idx):win_end))
hold on
scatter(locs(beg_idx:end_idx)-locs(beg_idx), pks(beg_idx:end_idx))
axis([locs(beg_idx) window min(sniff_smooth) max(sniff_smooth)]); % Scale axes

%% Visualize Ephys channels with inhalation times

% Set up plot
clf
cmap = colormap('jet');
colorIndices = round(linspace(1, size(cmap, 1), nchannels));

for ii = 1:4:nchannels
    
    % Plot traces
    p = plot(ephysx_rs(ii, win_beg:win_end));
    color = cmap(colorIndices(ii), :); 
    p.Color = color;  % Set the color

    % Add a label at the trace and legend
    label_str = "Ch " + num2str(ii);
    p.DisplayName = "Ch " + num2str(ii);
    end_val = ephysx_rs(ii, win_end); % Y position of label
    t = text(window+50, end_val, label_str, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    t.Color = color;

    hold on
    
end

% Sniff signal and peaks
% plot(sniff_smooth(locs(beg_idx):win_end))
% hold on
% for ii = beg_idx:end_idx
%     disp(ii)
%     x_value = locs(ii)-locs(beg_idx);
%     line([x_value x_value], ylim)
%     hold on
% end
legend()
hold off