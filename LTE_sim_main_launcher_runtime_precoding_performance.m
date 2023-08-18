close all force;
clear classes
clc;
cd ..

simulation_type = 'TPvsSNR'; % see "LTE_load_params." for possible choices 
bandwidth_options             = [1.4e6, 3e6, 5e6, 10e6,  20e6];
% bandwidth_options             = [20e6];
simSet                        = [2, 2; 4, 2; 4, 4]; % [NTx , NRx ;]

%% Load simulation parameters
LTE_config = LTE_load_params(simulation_type);

LTE_config.keep_UEs_still     = true;

LTE_config.bandwidth          = 20e6; %1.4e6 %3e6 %5e6  %10e6 %15e6  %20e6           % Frequency in Hz
LTE_config.nTX                = 2;
LTE_config.nRX                = 2;
LTE_config.tx_mode            = 4; % CLSM

LTE_config.eNodeB_tx_power       = 5; % eNodeB's transmit power, in Watts.
LTE_config.inter_eNodeB_distance = 500; % In meters. When the network is generated, this determines the distance between the eNodeBs.
LTE_config.nr_eNodeB_rings       = 0; % Number of eNodeB rings

LTE_config.channel_model.type = 'PedA'; % 'TU' % 'winner+' 'PedB' 'extPedB' 'TU' 'Gamma' --> the PDP to use 
LTE_config.trace_version      = 'v2';

LTE_config.UE_distribution    = 'constant UEs per cell';
LTE_config.UE_per_eNodeB      = 1;    % number of users per eNodeB sector (calculates it for the center sector and applies this user density to the other sectors)
LTE_config.UE_speed           = 5/3.6; % Speed at which the UEs move. In meters/second: 5 Km/h = 1.38 m/s

LTE_config.simulation_time_tti      = 500; % Simulation time in TTIs
LTE_config.feedback_channel_delay   = 0; % In TTIs

NumberOfSimulationRuns        = 10; %10
LTE_config.save_results_file  = 'false'; % Do not save results file
simTime                       = zeros(length(bandwidth_options),NumberOfSimulationRuns, size(simSet,1));

%% run the main simulation loop
for ss = 1:size(simSet,1)
    LTE_config.nTX  = simSet(ss,1);
    LTE_config.nRX  = simSet(ss,2);
    fprintf('***** Simulating antenna configuration: %dx%d \n\n',LTE_config.nTX, LTE_config.nRX);
    for jj = 1:length(bandwidth_options)
        LTE_config.bandwidth = bandwidth_options(jj);
        fprintf('***** Simulating bandwidth: %f \n\n',LTE_config.bandwidth);
        for ii = 1:NumberOfSimulationRuns
            ticIdx = tic;
            output_results_file = LTE_sim_main(LTE_config);
            time = toc(ticIdx);
            fprintf('\n Simulation Time: %f\n\n',time);
            simTime(jj,ii,ss) = time;
        end
    end
end

%% start the GUIs for evaluation
% simulation_data                   = load(output_results_file);
% GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
% GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);

%% Evaluate simulation time
% Cut first simulation run with specific setting, since it may have
% triggered a channel generation.
simTimeEval = simTime(:,2:end,:);
% Average over all simulation runs for specific setting
meanSimTime = squeeze(mean(simTimeEval, 2));
figure; hold on;
stem(bandwidth_options, meanSimTime);
plot(bandwidth_options, meanSimTime, '--');
xlabel('LTE-A bandwidth [MHz]');
ylabel('Simulation time [s]');
hold off; grid on;



%%

