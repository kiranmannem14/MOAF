close all force;
clc;
cd ..
%clear all
%clear global;
%clear classes;

simulation_type = 'tri_sector_plus_femtocells';

% Possible simulation types now:
%   - 'tri_sector'
%   - 'tri_sector_tilted', 'tri_sector_tilted_4x2', 'tri_sector_tilted_4x4'
%   - 'tri_sector_plus_femtocells'
%   - 'six_sector_tilted'
%   - 'capesso_pathlossmaps'
%   - 'omnidirectional_eNodeBs'

LTE_config = LTE_load_params(simulation_type);

%% If you want to modify something taking as a base the configuration file, do it here: here an example is show that changes the inter-eNodeB distances based on the LTE_load_params_hex_grid_tilted config file.

% Some changes to the base configuration, in case you would need/want them
LTE_config.show_network               = 2;
LTE_config.nTX                        = 1;
LTE_config.nRX                        = 1;
LTE_config.tx_mode                    = 1;
LTE_config.scheduler                  = 'round robin'; 
LTE_config.UE_per_eNodeB              = [40 2]; % First number refers to 'macro', second to 'femto' ,i.e. [Nr_of_UEs_per_Macro Nr_of_UEs_per_Femto]   
LTE_config.macroscopic_pathloss_model = 'TS36942'; 
LTE_config.shadow_fading_type         = 'none';
LTE_config.channel_model.type         = 'TU';
LTE_config.simulation_time_tti        = 10;
LTE_config.feedback_channel_delay     = 1;
LTE_config.map_resolution             = 5;
LTE_config.compact_results_file       = true;
LTE_config.delete_ff_trace_at_end     = true;
LTE_config.cache_network              = false;
LTE_config.UE_cache                   = false;
LTE_config.UE_cache_file              = 'auto';
LTE_config.pregenerated_ff_file       = 'auto';
LTE_config.trace_version              = 'v1'; 
LTE_config.adaptive_RI                = 0;
LTE_config.keep_UEs_still             = true;
% Femto specific
LTE_config.femtocells_config.femtos_per_cell    = 2;
LTE_config.femtocells_config.tx_power_W         = 10^(20/10)*1/1000;  
LTE_config.femtocells_config.mode               = 'CSG'; 
LTE_config.femtocells_config.macroscopic_pathloss_model_settings.wall_loss        = 20; 
LTE_config.femtocells_config.macroscopic_pathloss_model_settings.penetration_loss = LTE_config.femtocells_config.macroscopic_pathloss_model_settings.wall_loss; % Desired signal experiences penetration loss

%%
% Simulate only UEs in the sectors and femtos of center site:
% Indices of femtos in coverage of center site:
first_center_femto_index    = 22 + LTE_config.femtocells_config.femtos_per_cell * 12;
last_center_femto_index     = first_center_femto_index + 3 * LTE_config.femtocells_config.femtos_per_cell - 1;
LTE_config.compute_only_UEs_from_this_eNodeBs =  [13:15]; [13:15 first_center_femto_index:last_center_femto_index]; [13 14 15 16 17 18 19 20 21 28 29 30 31 32 33 34 35 36 46 47 48 58:100];
LTE_config.default_shown_GUI_cells            =  [13:15]; [13:15 first_center_femto_index:last_center_femto_index]; [13 14 15 16 17 18 19 20 21 28 29 30 31 32 33 34 35 36 46 47 48 58:100];

%%
output_results_file = LTE_sim_main(LTE_config);

simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);
