close all force;
clc;
cd ..
%clear all
%clear global;
%clear classes;

simulation_type = 'tri_sector_3D';

% Possible simulation types now:
%   - 'tri_sector', 'tri_sector_3D'
%   - 'tri_sector_tilted', 'tri_sector_tilted_4x2', 'tri_sector_tilted_4x4'
%   - 'tri_sector_plus_femtocells'
%   - 'six_sector_tilted'
%   - 'capesso_pathlossmaps'
%   - 'omnidirectional_eNodeBs'

LTE_config = LTE_load_params(simulation_type);

%% If you want to modify something taking as a base the configuration file, do it here: here an example is show that changes the inter-eNodeB distances based on the LTE_load_params_hex_grid_tilted config file.
LTE_config.frequency                  = 2e9;            % Frequency in Hz
LTE_config.bandwidth                  = 10e6;           % Frequency in Hz
% Some changes to the base configuration, in case you would need/want them
LTE_config.show_network               = 2;
LTE_config.nTX                        = 4;
LTE_config.nRX                        = 2;
LTE_config.tx_mode                    = 4;
LTE_config.nr_eNodeB_rings            = 1;              % Number of eNodeB rings
LTE_config.inter_eNodeB_distance      = 500;            % UMa = 500, UMi = 200 [m]
LTE_config.min_UE_eNodeB_distance     = 35;             %[m]  %--> 3D_UMa: 35 [m], 3D_UMi: 10 [m]


LTE_config.UE_per_eNodeB                 = 10;
LTE_config.UE_distribution               = 'constant UEs per cell_TR36873';
LTE_config.UE_speed                      = 5/3.6;     % Speed at which the UEs move. In meters/second: 5 Km/h = 1.38 m/s
% % Radial
%  LTE_config.UE_distribution              = 'radial';
%  LTE_config.UE_distribution_radii        = [10, 20 ,50];
%  LTE_config.UE_distribution_nUEs         = 9;
%  LTE_config.UE_distribution_overlap_radial_UEs = false;
%Predefined
%  LTE_config.UE_distribution              = 'predefined';
%  LTE_config.UE_positions                 = [100, 10; 100, 20; 100,30; 100,40; 100,50];



LTE_config.tx_height                  = 25;  % BS antenna height in [m] --> 3D_UMa: 25 [m]; if 3D_UMi: 10 [m]
LTE_config.rx_height                  = 1.5; % UE antenna height in [m]

LTE_config.eNodeB_tx_power            = 40;  % eNodeB's transmit power, in Watts.
% Recommended by TR 36.873 are:
% 41/44 dBm for 10/20 MHz carrier for 3D_UMi
% 46/49 dBm for 10/20 MHz carrier for 3D_UMa

% UE antenna config
LTE_config.UE_antenna_polarization                       = 'ULA'; %'ULA' (uniform linear array) or 'XPOL' (x-polarized)
LTE_config.UE_antenna_slant_angle                        = 0;     % if ULA --> slant angle is 0�; if 'XPOL' --> slant_angle is 90�
LTE_config.UE_antenna_element_horizontal_spacing         = 0.5 * 299792458/LTE_config.frequency;   % 0.5*wavelength can also be 0.8*wavelength
% eNodeB antenna config
LTE_config.antenna.antenna_polarization                  = 'XPOL'; % 'XPOL' or 'COPOL'.
LTE_config.antenna.slant_angle                           = 45; % If 'COPOL' -->slant_angle is 0�, 'XPOL' --> slant_angle is 45�
LTE_config.antenna_element_vertical_spacing              = 0.5 * 299792458/LTE_config.frequency;     % 0.8*wavelength %
LTE_config.antenna_element_horizontal_spacing            = 0.5 * 299792458/LTE_config.frequency;   % 0.5*wavelength can also be 0.8*wavelength
LTE_config.nr_of_antenna_elements_in_each_column         = 10;
LTE_config.mechanical_downtilt                           = 0; % [�] 
LTE_config.mechanical_slant                              = 0; % [�] 
LTE_config.electrical_downtilt                           = 90; % [�] specify tilt angle with respect to boresight direction 90� (100� means downtilt, 80� means uptilt by 10�)


LTE_config.scheduler                    = 'prop fair Sun';
LTE_config.simulation_time_tti          = 20;
LTE_config.feedback_channel_delay       = 3;
LTE_config.map_resolution               = 5;
LTE_config.compact_results_file         = true;
LTE_config.delete_ff_trace_at_end       = true;
LTE_config.cache_network                = false;
LTE_config.UE_cache                     = false;
LTE_config.trace_version                = 'v2'; 
LTE_config.compute_only_center_users    = true;     % Inclusion radius set in LTE_init_determine_eNodeBs_to_compute.m
LTE_config.keep_UEs_still               = true;
LTE_config.compact_results_file         = 0;
LTE_config.results_folder         = './results/demo';
%%

output_results_file               = LTE_sim_main(LTE_config);

simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);