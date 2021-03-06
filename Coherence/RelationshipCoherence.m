%% Relationships over time


% Left Temporal : 1:37
% Left Frontal: 38:56
% Occipital Pole: 57:60
% Orbital Frontal 61:76
% Suboccipital 77:86
% Temporal Pole 87:88
% Medial Subtemporal 89:92
% Lateral Occipital 93:100
% Posterior Subtemporal 101:107

% This file has been deemed ann elephant

region_name = {'Left Temporal'; 'Left Frontal'; 'Occipital Pole'; 'Orbital Frontal'; 'Suboccipital'; 'Temporal Pole'; 'Medial Subtemporal'; 'Lateral Occipital'; 'Posterior Subtemporal'};
region_shortname = {'LT', 'LF', 'OP', 'OF', 'SO', 'TP', 'MST', 'LO', 'PST'};
regions = [1,37;38,56;57,60;61,76;77,86;87,88;89,92;93,100;101,107];
region_index = 0;

cross_region_name = cell((length(region_shortname)^2 - length(region_shortname))/2,1);
for r1 = 1:length(region_shortname)
    for r2 = r1:length(region_shortname)
        region_index = region_index + 1;
        cross_region_name(region_index) = strcat(region_shortname(r1) , 'x' , region_shortname(r2)) 
    end
end
region_index = 0;

%%
region_index = 0;

WINDOW_SIZE = 1000;
TIME_SIZE = 50;
START_TIME = data.pulse_on(6);
END_TIME = data.pulse_on(7);

for r1 = 1:length(region_shortname)
    r1_size = regions(r1,2) - regions(r1, 1) + 1;
    
    for r2 = r1:length(region_shortname)
        r2_size = regions(r2,2) - regions(r2, 1) + 1;

        region_index = region_index+1;
        fprintf('\n')
        fprintf('Calculating coherency for %s', cross_region_name{region_index})

        coh = zeros(r1_size, r2_size, 20);
        count = 0;
        window = 0;
        for window_start = START_TIME:TIME_SIZE:END_TIME
            fprintf('\n');
            window = window+1;
            count = 0;
            for r1_channel = 1:r1_size
                for r2_channel= r1_channel:r2_size
                    msc = mscohere(data.eeg((regions(r1,1) + r1_channel) - 1,window_start:window_start+WINDOW_SIZE),  data.eeg((regions(r2, 1) + r2_channel) - 1,window_start:window_start+WINDOW_SIZE),  257,  129,  [70:300], 1000);
                    msc_mean = mean(msc(:));
                    coh(r1_channel, r2_channel, window) = msc_mean;
                    coh(r2_channel, r1_channel, window) = msc_mean;
                end
                fprintf('.')
                count = count + 1;
                if(count == 10)
                    count = 0;
                    fprintf('\n')
                end
            end
            
        end
        cross_regional_coherence{region_index} = coh;
        fprintf('data from %s loaded into region index %i', cross_region_name{region_index}, region_index);
    end
end

%%
hold off;
index = 0;
included_names = []
for i=cross_regional_coherence
    index = index+1;
    for window=size(i,3)
        disp(index);
        disp(mean(mean(i{:,:,window})));
        ct(index, :) = mean(mean(i{:,:,window})); 
    end
    if(max(ct(index, :)) < 0.21)
        plot(ct(index, :))
        included_names = [included_names cross_region_name(index)]
        hold on;
    end

    disp ('-------------');
    
end

legend(included_names)

