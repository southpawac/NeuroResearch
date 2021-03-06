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


%% EXECUTE AT YOUR OWN RISK
index = 0;
for count = minusmin_sorted_CL_indices(:)'
    index = index + 1
    subplot(2,1,1)
    %plot (mean_across_trials(count, :))
    plot(lolz_real_target_data(count, :))
    hold on
    plot (filt_minusmin_centroid_location(count), lolz_real_target_data(count, floor(filt_minusmin_centroid_location(count))), '*g')
    %plot (filtered_mean_across_trials(count, :))
    %plot (centroid_location_with_avg_trial(count, 248), mean_across_trials(count, floor(centroid_location_with_avg_trial(count,248))), '*r')
    %plot (filt_minusmin_centroid_location(count), mean_across_trials(count, floor(filt_minusmin_centroid_location(count))), '*g')
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
target_data = filtered_mean_across_trials(:, FILTER_LENGTH + 1:end);
lolz_real_target_data = zeros(107, size(target_data, 2));
filt_minusmin_centroid_location = zeros(107, 1);

count = 0;
for channel = 1:107
    count = count + 1;
    numer = 0; %Sum: f(x)*x
    denom = 0; %Sum: x
    lolz_real_target_data(channel, :) = target_data(channel, :) - min(target_data(channel, :));
    for time = 1:size(target_data,2)
        numer = numer + abs((lolz_real_target_data(channel, time) * time));
        denom = denom + abs(lolz_real_target_data(channel, time));
        if mod(time, 500) == 0
            fprintf('.');
        end
    end
    fprintf('done trial %i\n', trial);
    filt_minusmin_centroid_location(count) = numer / denom;
    fprintf('\n ------------------ Channel %i done-------------------------\n', channel);
end
%%
[trash, minusmin_sorted_CL_indices] = sort(filt_minusmin_centroid_location)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[trash, sCLidxidx] = sort(sorted_CL_indices)
[trash, mmsCLidxidx] = sort(minusmin_sorted_CL_indices)
plot([sCLidxidx, mmsCLidxidx]')