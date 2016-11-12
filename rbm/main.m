%% TAP,AIS,RTS
% Version 1.0.0

% Work by Brian Lin, Tzu-Heng, Electronic Engineering, Tsinghua University
% Implementation of above methods to estimate Z(theta) of RBM
% in matlab

% by default, we calc using AIS

clear; clc; close all;
rng('default')

%% Load RBM model configuration
load('./data/h10.mat')
% load('./data/h20.mat')
% load('./data/h100.mat')
% load('./data/h500.mat')
	% Including Data:
		% parameter_W
		% parameter_a (hidbiases)
		% parameter_b (visbiases)

%% TAP sampling
% 	W = parameter_W;
% 	a = parameter_b;	% visible
% 	b = parameter_a;	% hidden
% 	max_iteration_time = 10000;
% 	set_eps = 0.01;
% 	[logZ_TAP, convergence_time] = TAP(W, a, b, max_iteration_time, set_eps);

%% AIS sampling
	beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/100000:1.0];
	numruns = 100;
	W = parameter_W;
	a = parameter_a;	% hidden
	b = parameter_b;	% visible
	[logZ_AIS, logZ_AIS_up, logZ_AIS_down] = ...
		AIS(parameter_W,parameter_a,parameter_b,numruns,beta);

% %% RTS sampling
% 	% Load model A data to get Z_A
% 	load('./data/test.mat');
% 	W = parameter_W;
% 	a = parameter_a;	% hidden
% 	b = parameter_b;	% visible
% 	beta = 0:1/100:1;	% Set beta with length:K
% 	outer_iteration_time = 100;
% 	iteration_time = 100;
% 	transition_time = 50;
% 	logZ_RTS = RTS(W, b, a, testbatchdata, beta, outer_iteration_time, iteration_time, transition_time);

%% Calc true partition value
	true_partition = calculate_true_partition(parameter_W,parameter_a,parameter_b);
	fprintf(1,'True partition: %f\n', true_partition);




