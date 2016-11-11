

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
[Z, convergence_time] = TAP(W, a, b, 10000, 5);

