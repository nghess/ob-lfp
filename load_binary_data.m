%% Load Ephys .bin
clear

ephys_file = '061421_4127_session10_Ephys_int16_med0_nch16.bin';
ephys = fopen(ephys_file, 'r'); 
ephysx = fread(ephys, 'uint16');
fclose(ephys);


%% Load Sniff .bin

sniff_file = '061421_4127_session10_ADC_int16_med0_nch8.bin';
adc = fopen(sniff_file, 'r');
adcx = fread(adc, 'uint16');
fclose(adc);

