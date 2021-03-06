DOWNSAMPLE_AMOUNT = 1;
FILTER_LENGTH = 100;
target_data = real_target_data;
clearvars mean_across_trials filtered_mean_across_trials mean_1st_diff mean_1st_diff_filtered
for channel = sorted_CL_indices'
    mean_across_trials(channel, :) = mean(target_data(channel, :, 1:DOWNSAMPLE_AMOUNT:5000).^2, 2);
    filtered_mean_across_trials(channel, :) = filter( (1/(FILTER_LENGTH/DOWNSAMPLE_AMOUNT)) * ones(FILTER_LENGTH/DOWNSAMPLE_AMOUNT,1), 1, mean_across_trials(channel, :));
    mean_1st_diff(channel, : ) = mean_across_trials(channel, 2:end) - mean_across_trials(channel, 1:end-1);
    mean_1st_diff_filtered(channel, : ) = filtered_mean_across_trials(channel, 2:end) - filtered_mean_across_trials(channel, 1:end-1);
end

%%
%count = mod(count +1, 107)
count = 57
subplot(2,1,1)
plot (mean_across_trials(count, :))
hold on
plot (filtered_mean_across_trials(count, :))
plot (centroid_location_with_avg_trial(count, 248), mean_across_trials(count, floor(centroid_location_with_avg_trial(count,248))), '*r')
hold off
subplot(2,1,2)
h = heatmap(reshape(abs(target_data(count, :, :)), [247,5000]), 'colormap', colormap('summer'), 'GridVisible', 'off')
h.title('Z-Score for channel ' + [string + count])
h.xlabel('Time');
h.ylabel('Trial');

%% EXECUTE AT YOUR OWN RISK
index = 0;
for count = sorted_CL_indices(:)'
    index = index + 1
    subplot(2,1,1)
    plot (mean_across_trials(count, :))
    hold on
    plot (filtered_mean_across_trials(count, :))
    plot (centroid_location_with_avg_trial(count, 248), mean_across_trials(count, floor(centroid_location_with_avg_trial(count,248))), '*r')
    plot (minusmin_centroid_location(count), mean_across_trials(count, floor(minusmin_centroid_location(count))), '*g')
    hold off
    title ('Average z-score and filtered average z-score for CH' + [string + count] + ' with centroid marked');
    subplot(2,1,2)
    h = heatmap(reshape(abs(target_data(count, :, :)), [247,5000]), 'colormap', colormap('summer'), 'GridVisible', 'off');
    h.title('Z-Score for channel ' + [string + count])
    h.xlabel('Time');
    h.ylabel('Trial');
    
    name = char(strcat('MeanAndCentroidOverRasterCH',string(index),'.png'))
    saveas(figure(1), name)
    %print ('pactures\MeanAndCentroidOverRaster CH' + [string + count], '-dpng');
end

%%
%VERY BIASED list of channels that dont look like noise
wave_channels = [8, 9, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 48, 49, 50, 51, 52, 53, 57, 58, 59, 60, 76, 78, 79, 80, 81, 84, 85, 82, 83, 96, 97, 98, 99, 100, 104, 107];

%%
target_data = mean_across_trials;

minusmin_centroid_location = zeros(107, 1);

count = 0;
for channel = 1:107
    count = count + 1;
    numer = 0; %Sum: f(x)*x
    denom = 0; %Sum: x
    real_target_data = target_data(channel, :) - min(target_data(channel, :));
    for time = 1:size(target_data,2)
        numer = numer + abs((target_data(channel, time) * time));
        denom = denom + abs(target_data(channel, time));
        if mod(time, 500) == 0
            fprintf('.');
        end
    end
    fprintf('done trial %i\n', trial);
    minusmin_centroid_location(count) = numer / denom;
    fprintf('\n ------------------ Channel %i done-------------------------\n', channel);
end

%%
[temp sorted_av_CL_indices] = sort(wc_centroid_location)
count = 0

%%
count = mod(count + 1, length(wave_channels))
plot(mean_across_trials(wave_channels(sorted_av_CL_indices(count)),:))

%%
target_data = mean_across_trials;

minusmin_centroid_location = zeros(107, 1);

count = 0;
for channel = 1:107
    count = count + 1;
    numer = 0; %Sum: f(x)*x
    denom = 0; %Sum: x
    lolz_real_target_data = target_data(channel, :) - min(target_data(channel, :));
    for time = 1:size(target_data,2)
        numer = numer + abs((target_data(channel, time) * time));
        denom = denom + abs(target_data(channel, time));
        if mod(time, 500) == 0
            fprintf('.');
        end
    end
    fprintf('done trial %i\n', trial);
    minusmin_centroid_location(count) = numer / denom;
    fprintf('\n ------------------ Channel %i done-------------------------\n', channel);
end