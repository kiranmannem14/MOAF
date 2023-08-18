close all force;
clc;
cd ..

simulation_type = 'tri_sector_tilted';


% Possible simulation types now:
%   - 'tri_sector'
%   - 'tri_sector_tilted', 'tri_sector_tilted_4x2', 'tri_sector_tilted_4x4'
%   - 'tri_sector_plus_femtocells'
%   - 'six_sector_tilted'
%   - 'capesso_pathlossmaps'
%   - 'omnidirectional_eNodeBs'
%   - 'tri_sector_tilted_traffic'

%simSet = [400 4 1];
simSet = [7 4 1];


%% Base configuration
LTE_config = LTE_load_params(simulation_type);
LTE_config.bandwidth                    = 3e6;
LTE_config.UE_distribution              = 'constant UEs per cell';
LTE_config.network_geometry             = 'regular_hexagonal_grid'; %'stochastic'; %'regular_hexagonal_grid'; %'stochastic'; 
% LTE_config.network_geometry             = 'circular';
LTE_config.nr_eNodeB_rings              = 1; % Number of eNodeB rings
LTE_config.UE_per_eNodeB                = 5;
LTE_config.simulation_time_tti          = 20;
LTE_config.compute_only_center_users    = false; % Inclusion radius set in LTE_init_determine_eNodeBs_to_compute.m
LTE_config.feedback_channel_delay       = 1;
LTE_config.channel_model.type           = 'TU';
LTE_config.channel_model.trace_length   = 1;
LTE_config.scheduler                    = 'round robin';
LTE_config.trace_version                = 'v2';
LTE_config.recalculate_fast_fading      = 1;
LTE_config.support_beamforming          = 1;
LTE_config.channel_model.correlated_fading = 1;

LTE_config.selected_codebook            = 1;


LTE_config.selected_codebook = 1;


% 
% % Misc options
LTE_config.non_parallel_channel_trace   = true;
LTE_config.show_network                 = 0;
LTE_config.keep_UEs_still               = true;
LTE_config.UE_speed                     = 10/3.6;
LTE_config.compact_results_file         = false;
LTE_config.delete_ff_trace_at_end       = false;
LTE_config.UE_cache                     = false;
LTE_config.cache_network                = false;
LTE_config.support_handover             = true;
% LTE_config.pregenerated_ff_file       = 'auto';
% Delete after Testing the Gamma Fading:
% LTE_config.channel_model.type           = 'Gamma';
% LTE_config.recalculate_fast_fading      = true;


LTE_config.nTX     = simSet(2);
LTE_config.nRX     = simSet(3);
LTE_config.tx_mode = simSet(1);
ticIdx = tic;
output_results_file = LTE_sim_main(LTE_config);
time = toc(ticIdx);

simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);
