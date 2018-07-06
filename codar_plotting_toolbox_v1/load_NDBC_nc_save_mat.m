close all
clear 
clc
tic

%% Time Period to grab data
year = input('What year would you like buoy data for?: ');

%% Buoy Info Cell Arrays
buoy.name={'44065','44091'};
buoy.year={year,year};

%% loop to go though each buoy
for ii=1:length(buoy.name)
    
    %% decalre the individual buoy
    buoy2.name=buoy.name{ii};
    buoy2.year=buoy.year{ii};
    buoyyearstr=num2str(buoy2.year);
    %% read in the wind data
    [DATA]=ndbc_nc(buoy2);

    %% Save the data
    savefile=[pwd '/ndbc_data/' buoy2.name '/ndbc_' buoy2.name '_' buoyyearstr '.mat'];
    save(savefile,'DATA')

end

toc