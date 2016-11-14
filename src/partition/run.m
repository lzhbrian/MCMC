%% TAP,AIS,RTS
% Version 1.0.0

% Work by Brian Lin, Tzu-Heng, Electronic Engineering, Tsinghua University
% Implementation of above methods to estimate Z(theta) of RBM
% in matlab

% by default, we calc using AIS

%% Initialize
clear; clc; close all;
Z = zeros(1,8);

% Load model A data to get Z_A
load('./data/test.mat');

%% AIS
for i = 1:4
    fprintf('Running %d time...\n',i)
%% Load Data
    if i == 1
        load('./data/h10.mat')
    elseif i == 2
        load('./data/h20.mat')
    elseif i == 3
        load('./data/h100.mat')
    else
        load('./data/h500.mat')
    end
%% AIS sampling
tic
    beta = [0:1/10000:1.0];
	numruns = 100;
	W = parameter_W;
	a = parameter_a;	% hidden
	b = parameter_b;	% visible
% 	[logZ_AIS, logZ_AIS_up, logZ_AIS_down] = ...
% 		AIS(parameter_W,parameter_a,parameter_b,numruns,beta);
    [logZ_AIS, logZ_AIS_up, logZ_AIS_down] = ...
		AIS(parameter_W,parameter_a,parameter_b,numruns,beta,testbatchdata);
toc

%% Save to Z
    Z(i) = logZ_AIS;
    Z(i+4) = calculate_logprob(W,a,b,logZ_AIS,testbatchdata);
end


