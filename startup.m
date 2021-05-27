% gets executed when MATLAB ist started

% enables using umlauts
slCharacterEncoding('UTF-8');

% add directories to search path, so MATLAB can execute contained functions
addpath('model');

load('bus_definitions.mat');
load('plotcolors.mat');


load('ptruns.mat')
pyenv("Version", "3.7", "ExecutionMode", "OutOfProcess");