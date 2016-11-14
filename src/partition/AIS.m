%% AIS method
% Version 1.0.0
% Work by Brian Lin, Tzu-Heng, Electronic Engineering, Tsinghua University
% Implementation of AIS-method to estimate Z(theta)
% in matlab

% Very much rely on Prof. Ruslan Salakhutdinov's Ph.D thesis, and his code:
	% LEARNING DEEP GENERATIVE MODELS

%% Info
	% Input:
		% vishid    -- a matrix of RBM weights [numvis, numhid]
		% hidbiases -- a row vector of hidden  biases [1 numhid]
		% visbiases -- a row vector of visible biases [1 numvis]
		% numruns   -- number of AIS runs
		% beta      -- a row vector containing beta's
		% batchdata -- the data that is divided into batches (numcases numdims numbatches)
	% Output:
		% logZ - logZ(theta)
		% upper logZ
		% lower logZ 
	% eg. Usage:
		% beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/100000:1.0];
		% numruns = 100;
		% [logZZ_est, logZZ_est_up, logZZ_est_down] = ...
		%     AIS(vishid,hidbiases,visbiases,numruns,beta,batchdata);

function [logZZ_est, logZZ_est_up, logZZ_est_down] = ...
	AIS(vishid, hidbiases, visbiases, numruns, beta, batchdata);


[numdims numhids]=size(vishid);
if(nargin>5)
%%% Initialize biases of the base rate model by ML %%%%%%%%%%%%%%%%%%%%%%%
	base_rate 
	visbiases_base = log_base_rate';
else
	visbiases_base = 0*visbiases;
end  

numcases = numruns; 

%%%%%%%%%% RUN AIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
visbias_base = repmat(visbiases_base,numcases,1); %biases of base-rate model.  
hidbias = repmat(hidbiases,numcases,1); 
visbias = repmat(visbiases,numcases,1);

%%%% Sample from the base-rate model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logww = zeros(numcases,1);
negdata = repmat(1./(1+exp(-visbiases_base)),numcases,1);  
negdata = negdata > rand(numcases,numdims);
logww  =  logww - (negdata*visbiases_base' + numhids*log(2));

Wh = negdata*vishid + hidbias; 
Bv_base = negdata*visbiases_base';
Bv = negdata*visbiases';   
tt=1; 

%%% The CORE of an AIS RUN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for bb = beta(2:end-1);  
	fprintf(1,'beta=%d\r',bb);
	tt = tt+1; 

	expWh = exp(bb*Wh);
	logww  =  logww + (1-bb)*Bv_base + bb*Bv + sum(log(1+expWh),2);

	poshidprobs = expWh./(1 + expWh);
	poshidstates = poshidprobs > rand(numcases,numhids);

	negdata = 1./(1 + exp(-(1-bb)*visbias_base - bb*(poshidstates*vishid' + visbias)));
	negdata = negdata > rand(numcases,numdims);

	Wh      = negdata*vishid + hidbias;
	Bv_base = negdata*visbiases_base';
	Bv      = negdata*visbiases';

	expWh = exp(bb*Wh);
	logww = logww - ((1-bb)*Bv_base + bb*Bv + sum(log(1+expWh),2));

end 

expWh = exp(Wh);
logww  = logww +  negdata*visbiases' + sum(log(1+expWh),2);

%%% Compute an estimate of logZZ_est +/- 3 standard deviations.   
r_AIS = logsum(logww(:)) -  log(numcases);  
aa = mean(logww(:)); 
logstd_AIS = log (std(exp ( logww-aa))) + aa - log(numcases)/2;   
%%% Same as computing  logstd_AIS = log(std(exp(logww(:)))/sqrt(numcases));  

logZZ_base = sum(log(1+exp(visbiases_base))) + (numhids)*log(2); 
logZZ_est = r_AIS + logZZ_base;
logZZ_est_up = logsum([log(3)+logstd_AIS;r_AIS]) + logZZ_base;
logZZ_est_down = logdiff([(log(3)+logstd_AIS);r_AIS]) + logZZ_base;
if ~isreal(logZZ_est_down)
	logZZ_lat_comp_down = 0;
end

fprintf('Final, Estimated log Z(theta)=%f\nupper and lower is:%f, %f\n',...
    logZZ_est,logZZ_est_up,logZZ_est_down)




