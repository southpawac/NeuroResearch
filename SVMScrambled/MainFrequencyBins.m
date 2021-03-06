%Load the data
% Data should be stored in '../NeuroData/ta505_datasets/'
disp('Loading data...')
run('LoadData.m');
disp('Data Loaded');
%{
New/updated variables:
bad_channels -- struct -- the contents of the bad_channels.mat file
data -- struct -- the contents of the relevant dataset (adjustable)
data.use_trials -- 34x1 double --indecies of data.eeg labeled by doc as not sucky
data.use_times -- 34x1 double -- the corresponding timestamps to use_trials
data.fs -- sampling frequency (1000 Hz)
UPDATED: data.eeg -- values labeled bad in bad_channels removed
UPDATED: data.ch_names -- updated accordingly
%}

%Filter out harmonics of 60 Hz because AC
disp('Filtering notches...');
run('NotchFilter.m');
disp('Notches Filtered');
%{
New/updated variables:
data.notch_filtered_eeg created
UPDATE data.eeg <-- data.notch_filtered_eeg
%}


%Create bins for the frequencies
disp('filtering into bins')
run('FrequencyBins.m')
disp('filtered into bins')

