load('./data/h10.mat')


% Using AIS to estimate partition value
% beta = [0:1/100000:0.5 0.5:1/10000:0.9 0.9:1/1000:1.0];
% beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/10000:1.0];
beta = 0:1/5000:1;
numruns = 500;
[logZZ_est, logZZ_est_up, logZZ_est_down] = ...
    RBM_AIS(parameter_W,parameter_a,parameter_b,numruns,beta);
fprintf(1,'estimated partition: %f, upper: %f, down: %f\n'...
    , logZZ_est,logZZ_est_up,logZZ_est_down);

% Calc true partition value
true_partition = calculate_true_partition(parameter_W,parameter_a,parameter_b);
fprintf(1,'True partition: %f\n', true_partition);
