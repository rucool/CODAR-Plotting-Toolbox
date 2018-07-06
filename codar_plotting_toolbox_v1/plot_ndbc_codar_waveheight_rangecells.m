clear
clc
close all
tic

%% m script written on January 17, 2014 to make scatter plots of the wave height
% Recoded by Jaden Dicopoulos on June 6, 2017 to be up to date on current HF Radar
% and Buoy inputs
%% comparisons between NDBC buoys

%% Buoy Info Cell Arrays
BuoyInput = ['Buoy Number?' newline '1 for 44091' newline '2 for 44065' newline 'Input: '];
indB = input(BuoyInput);
buoy.name={'44091','44065'};
disp(newline);

%% CODAR Info Cell Arrays
SiteInput = ['CODAR Site Code?' newline 'examples: SPRK, SEAB, BRMR.' newline 'Input: '];
site=string(input(SiteInput,'s'));
codar.name=(site);
disp(newline);

%% determine the time that you want to analyze
inputdate.start = input('Starting date: ','s');
inputdate.end = input('Ending date: ','s');
dtime.span=datenum(inputdate.start):1/24:datenum(inputdate.end);
dtime.start=min(dtime.span);
dtime.end=max(dtime.span);
dtime.startstr=datestr(dtime.start,'yyyymmdd');
dtime.endstr=datestr(dtime.end,'yyyymmdd');
disp(newline);

%% Directory defining
%Buoy Directory
conf.data_path.ndbc=[pwd '/ndbc_data/'];
%CODAR .wls file Directory
directoryinput = input(['Magic Average or Range Cells?' newline '1 for WVLM (Magic Average)' ...
    newline '2 for WVLR (Range Cells)' newline 'Input: '],'s');
if directoryinput == '1'
conf.data_path.codar_waves=[pwd '/codar_data/WVLM/'];
elseif directoryinput == '2'
conf.data_path.codar_waves=[pwd '/codar_data/WVLR/'];
end
%Print location
conf.print_path=[pwd '/figures/'];
disp(newline);

%% Read in fuctions and defining data

for ii=1:length(codar.name)

buoy_data=load([conf.data_path.ndbc buoy.name{indB} '/ndbc_' buoy.name{indB} '_2018.mat']);

datapath=[conf.data_path.codar_waves codar.name{ii}];
[CODAR]=Codar_WVM9_readin_func(datapath,'wls');

%% First round of indexing, only taking the data from the specified range cell
if directoryinput == '2'
rci = input(['What Range Cells would you like to use?' newline 'Use matrix format, ex: [3 5 7]' newline 'Input: ']);
disp(newline);
elseif directoryinput == '1'
rci = 2;
end

for rc = rci
ind1=find(CODAR.RCLL==rc);

CODAR2.MWHT=CODAR.MWHT(ind1);
CODAR2.MWPD=CODAR.MWPD(ind1);
CODAR2.WAVB=CODAR.WAVB(ind1);
CODAR2.WNDB=CODAR.WNDB(ind1);
CODAR2.ACNT=CODAR.ACNT(ind1);
CODAR2.DIST=CODAR.DIST(ind1);
CODAR2.RCLL=CODAR.RCLL(ind1);
CODAR2.time=CODAR.time(ind1);

%% find the data that matches the time period you are interested in
indtime_buoy=find(buoy_data.DATA(:,1)>=dtime.start & buoy_data.DATA(:,1)<=dtime.end);
indtime_codar=find(CODAR2.time>=dtime.start & CODAR2.time<=dtime.end);

%% FIGURE 1 Time series plot of the two comparisons
%% declare a new variable for codar data
CODAR3.time=CODAR2.time(indtime_codar);
CODAR3.MWHT=CODAR2.MWHT(indtime_codar);
% ind3=CODAR3.MWHT>6;
% CODAR3.MWHT(ind3)=NaN;
NDBC.time=buoy_data.DATA(indtime_buoy,1);
NDBC.MWHT=buoy_data.DATA(indtime_buoy,5);

%% identify the spikes in the data records
[CODAR4.MWHT,idx] = removeSpikes(CODAR3.MWHT,2);
sum(idx);

[NDBC4.MWHT,idx2] = removeSpikes(NDBC.MWHT,2);
sum(idx2);

%% Interpolating on a common time axis for data statisics 
buoy01i=interp1(NDBC.time,NDBC4.MWHT,dtime.span);
codar02i=interp1(CODAR3.time,CODAR4.MWHT,dtime.span)';
buoy01i=buoy01i';
Good = isnan(buoy01i) + isnan(codar02i);
digits = 2;

%% Range and Site statistics printed and saved to a txt file
statsfile = ['Site ' codar.name{ii} ' RC ' num2str(rc) ' ' dtime.startstr ' ' dtime.endstr ' stats.txt'];
statsfolder = [pwd '/site_statistics/'];
fclose('all');
fileID = fopen(statsfile, 'w');
fprintf(fileID,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n');
fprintf(fileID,'Percent Data return for Wave Height at CODAR site %s \n',codar.name{ii});
fprintf(fileID,'Between %s & %s \n',datestr(dtime.start),datestr(dtime.end));
DataPts.CODAR = sum(~isnan(codar02i));
fprintf(fileID,'Number of CODAR Data Points %5.0f \n',DataPts.CODAR);
total = numel(dtime.span);
fprintf(fileID,'Number of Total Possible Data Recordings %5.0f \n',total);
PDR = DataPts.CODAR/total;
fprintf(fileID,'Percent Data Return for Site %5.1f%% \n \n',PDR*100);
fprintf(fileID,'Correlation and RMS Difference Between CODAR and BUOY %s \n',buoy.name{indB});
RHO = corr(buoy01i(Good==0),codar02i(Good==0));
fprintf(fileID,'Correlation %s \n',num2str(RHO,digits));
RMSD = sqrt(mean((buoy01i(Good==0)-codar02i(Good==0)).^2));
fprintf(fileID,'RMS Difference %5.2f \n',RMSD);
fprintf(fileID,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n');
fclose(fileID);
movefile(statsfile,statsfolder);

%% plot the despiked data
hold all
if directoryinput == '2'
plot(CODAR3.time,CODAR4.MWHT,'LineWidth',1,'DisplayName', ['Range Cell ' num2str(rc)]);
elseif directoryinput == '1'
plot(CODAR3.time,CODAR4.MWHT,'LineWidth',1,'DisplayName', 'Magic Average');
end

end
plot(NDBC.time,NDBC4.MWHT,'k','LineWidth',2,'DisplayName', ['Buoy ' buoy.name{indB}]);

%% Plotting tools
title(['Comparison of Buoy and CODAR Wave Height ' datestr(dtime.start) ' to ' datestr(dtime.end)]);
legend('show','AutoUpdate','off')
ylabel('Wave Height (m)')
format_axis(gca,dtime.start,dtime.end,7,1,'mm/dd',0,6,1)

timestamp(1,'codar_plotting_toolbox_v1')

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print('-dpng','-r150',[conf.print_path 'WaveHeightTS_' buoy.name{indB} '_' codar.name{ii}...
    '_' dtime.startstr '_'  dtime.endstr '.png'])

end
disp(['figure saved to ' conf.print_path]);
disp(['statistics saved to ' statsfolder]);
toc
