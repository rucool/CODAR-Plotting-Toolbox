%% Directory Creator for toolbox
clear
clc
close

%% Main folder for codar data
N_codar_data_dir = [pwd '/codar_data/'];
if ~exist(N_codar_data_dir, 'dir')
    mkdir(N_codar_data_dir);
end
%% WLV files
N_WVLM_dir = [pwd '/codar_data/WLVM/'];
if ~exist(N_WVLM_dir, 'dir')
    mkdir(N_WVLM_dir);
end

N_WVLR_dir = [pwd '/codar_data/WLVR/'];
if ~exist(N_WVLR_dir, 'dir')
    mkdir(N_WVLR_dir);
end
%% WVL SPRK
N_WVLM_SPRK_dir = [pwd '/codar_data/WLVM/SPRK/'];
if ~exist(N_WVLM_SPRK_dir, 'dir')
    mkdir(N_WVLM_SPRK_dir);
end

N_WVLR_SPRK_dir = [pwd '/codar_data/WLVR/SPRK/'];
if ~exist(N_WVLR_SPRK_dir, 'dir')
    mkdir(N_WVLR_SPRK_dir);
end
%% figures folder 
N_figures_dir = [pwd '/figures/'];
if ~exist(N_figures_dir, 'dir')
    mkdir(N_figures_dir);
end

%% site statistics folder
N_site_statistics_dir = [pwd '/site_statistics/'];
if ~exist(N_site_statistics_dir, 'dir')
    mkdir(N_site_statistics_dir);
end

%% NDBC data and buoys
N_ndbc_data_dir = [pwd '/ndbc_data/'];
if ~exist(N_ndbc_data_dir, 'dir')
    mkdir(N_ndbc_data_dir);
end

N_44065_dir = [pwd '/ndbc_data/44065/'];
if ~exist(N_44065_dir, 'dir')
    mkdir(N_44065_dir);
end

N_44091_dir = [pwd '/ndbc_data/44091/'];
if ~exist(N_44091_dir, 'dir')
    mkdir(N_44091_dir);
end

clear
clc