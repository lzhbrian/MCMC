
%%
rng('default')

%%
% Load RBM model
load('./data/h10.mat')
% Including Data:
	% parameter_W
	% parameter_a (hidbiases)
	% parameter_b (visbiases)

%% TAP sampling
W = parameter_W;
a = parameter_b;	% visible
b = parameter_a;	% hidden
max_iteration_time = 10000;
set_eps = 0.001;
[Z, convergence_time] = TAP(W, a, b, max_iteration_time, set_eps);

%% AIS Sampling

%%