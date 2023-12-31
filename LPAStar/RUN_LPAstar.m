% LPA*: Lifelong Planning A* Path Planning Algorithm - MATLAB

% Initialization
clc
clear
close

% adding paths
addpath('..\models');
addpath('..\common');

%% settings
Model.expandMethod = 'random'; % random or heading
Model.distType = 'euclidean'; % euclidean or manhattan;
Model.adjType = '8adj'; % 4adj or 8adj

%% create Map and Model
create_model_method = 'from_custom'; % from_map_file, from_samples, from_custom

switch create_model_method
    case 'from_map_file'
        % load Map file and create model - (1:free, o:obstacles)
        map_name = 'Map.mat';
        load(map_name, 'Map');
        Model = createModelFromMap(Map, Model);
        Model = addRobotToModel(Model);
    case 'from_samples'
        sample_model_name = "Obstacle2";
        Model = createModelSamples(sample_model_name, Model);
    case 'from_custom'
        Model = createModelBase(Model);
end

% Complete Base Model for LPAStar
Model = createModelLPAstar(Model);

% add dynamic obstacles
Model = newObstacles(Model);

%% optimal path by LPAstar
% Path: nodeNumbers, coords, dirs
tic
[Model, Path] = myLPAstar(Model);
Sol = Path;
Sol.runTime = toc;
Sol.cost = calCostL(Sol.coords);
Sol.smoothness = calSmoothnessbyDir(Sol);

%% display data and plot solution
disp(['run time for path= ' num2str(Sol.runTime)])
disp(Sol)

showDynamicObst = true;
plotModel(Model, showDynamicObst)
plotSolution(Sol.coords, [])
% plotAnimation2(Model, Sol.coords)

%% clear temporal data
clear adj_type dist_type
