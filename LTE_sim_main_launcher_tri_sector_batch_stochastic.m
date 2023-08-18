close all force;
clc;
cd ..
%clear all
clear global;
%clear classes;

for i_ = 1:10
    
    example_class = 'tri_sector';
    simulation_type = 'stochastic_tri_sector_tilted';
    
    % Possible simulation types now:
    %   - 'tri_sector'
    %   - 'tri_sector_tilted', 'tri_sector_tilted_4x2', 'tri_sector_tilted_4x4'
    %   - 'tri_sector_plus_femtocells'
    %   - 'six_sector_tilted'
    %   - 'capesso_pathlossmaps'
    %   - 'omnidirectional_eNodeBs'
    %   - 'tri_sector_tilted_traffic'
    
    LTE_config = LTE_load_params(simulation_type);
    
    LTE_config.simulation_time_tti              = 1;
    LTE_config.show_network                     = 1;
    LTE_config.nTX                              = 2;
    LTE_config.nRX                              = 2;
    LTE_config.tx_mode                          = 4;
    LTE_config.UE_per_eNodeB                    = 20;
    LTE_config.keep_UEs_still                   = true;
    LTE_config.compact_results_file             = 1;
    LTE_config.scheduler                        = 'prop fair Sun'; % prop fair Sun % round robin
%     LTE_config.antenna.antenna_gain_pattern     = 'TS 36.942 3D';
    LTE_config.bandwidth                        = 20e6;
    LTE_config.shadow_fading_sd                 = 10;
    % Calculate spatially uncorrelated maps to evaluate shadow fading
%     LTE_config.deactivate_claussen_spatial_correlation = true;
    LTE_config.network_source                   = 'generated';
    LTE_config.network_geometry                 = 'stochastic';%'regular_hexagonal_grid'; 
    LTE_config.average_eNodeB_distance          = 500;
    LTE_config.network_size                     = 3;
    %
    % According to the simulation scenario 1
    LTE_config.eNodeB_tx_power                  = 40; % 46 dBm
%     LTE_config.tx_height                      = 32;
%     LTE_config.rx_height                      = 1.5;
%     LTE_config.antenna.electrical_downtilt    = 15;
%     LTE_config.calculate_3D_pathloss          = true;
    %
    LTE_config.compact_results_file             = true;
    LTE_config.cache_network                    = false;
    LTE_config.delete_ff_trace_at_end           = true;
    LTE_config.UE_cache                         = false;
    LTE_config.pregenerated_ff_file             = 'auto';
    % LTE_config.trace_version                  = 'v1';    % 'v1' for pregenerated precoding. 'v2' for run-time-applied precoding
    
    LTE_config.compute_only_center_users        = true;  %A-posteriori determine eNBs, from which attached users are computed.
    
    output_results_file = LTE_sim_main(LTE_config);
end

%% Plot simulation results
simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);