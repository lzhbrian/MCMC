%% RTS method
% Version 1.0.0
% Work by Brian Lin, Tzu-Heng, Electronic Engineering, Tsinghua University
% Implementation of RTS-method to estimate Z(theta)
% in matlab

%% Info
	% Input:
		% W - weight
		% b - visible bias
		% a - hidden bias
		% batchdata - data to generate base_rate in model A
		% outer_iteration_time - outer iteration time
		% iteration_time - inner iteration time
		% transition_time - how many times we update during x_k -> x_k+1
	% Output:
		% logZ - logZ(theta)
	% eg. Usage:
		% logZ = RTS(W, b, a, testbatchdata, 0:1/100:1, 100, 100, 50);


%% Reference:
	% David E. Carlson et al.
	% Partition Functions from Rao-Blackwellized Tempered Sampling

function [logZ,c] = RTS(W, b, a, batchdata, beta, outer_iteration_time, iteration_time, transition_time)

	%% load data
	fprintf('Running RTS...\n');

	%% beta length
	K = length(beta);	% beta-length

	%% Initiate model
		% model B
		W_B = W;	% weight
		b_B = b;	% visible
		a_B = a;	% hidden

		% model A
		%%%%% Initialize biases of the base-rate model by ML %%%%%%%%%%%%%%%%%%%%%
		[numcases numdims numbatches]=size(batchdata);
		count_int = zeros(numdims,1);
		for batch=1:numbatches
			xx = sum(batchdata(:,:,batch));
			count_int = count_int + xx';
		end
		lp=5;
		p_int = (count_int+lp*numbatches)/(numcases*numbatches+lp*numbatches);
		log_base_rate = log(p_int) - log(1-p_int);
		% Generate model A
		W_A = zeros(size(W_B));
		a_A = a_B;
		b_A = log_base_rate';
		log_Z_A = sum(log(1+exp(a_A))) + sum(log(1+exp(b_A)));
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Init Z,r,v
		Z = ones(1,K);
		Z(1) = exp(log_Z_A);		% Z(1) = Z_A
		r = ones(1,K)/K;    		% Set r with length:K
		v = zeros(1,length(b_B));	% init v

	% Set iteration time
		outer_iteration = outer_iteration_time; % outer iteration
		N = iteration_time;     				% inner iteration
		transition = transition_time;		% transition time to update x_k+1

	% Start iteration
	for o_iter = 1:outer_iteration
		beta_specific = beta(randi([1,K]));	% Init beta
		c = zeros(1,K);						% Init c, length:K
		for i = 1:N
		% first part: from x_k get x_k+1
			for t = 1:transition
				% p(h_j^{A}=1|v) known:v,beta ; for diff:j(h) ; prob(X=1)
				p_hA_v = logsig( (1-beta_specific) * (v*W_A+a_A) );	% length:hidden
				% p(h_j^{B}=1|v) known:v,beta ; for diff:j(h) ; prob(X=1)
				p_hB_v = logsig( beta_specific * (v*W_B+a_B) );		% length:hidden
				%%%%%
				% sample h_A, h_B % length:hidden
				h_A = p_hA_v > rand(size(p_hA_v));
				h_B = p_hB_v > rand(size(p_hB_v));

				% p(v'_i=1|h) known:h,beta ; for diff:i(v) ; prob(X=1)
				p_v_h = logsig( (1-beta_specific)*(W_A*h_A'+b_A') + beta_specific*(W_B*h_B'+b_B') );	% length:visible
				%%%%%
				% sample v (x_k+1) % length:visible
				v = p_v_h > rand(size(p_v_h)); % v === x_k+1
				v = v';
			end
			% Get q(beta|x)
				% q(x|beta)	known:x_k+1 ; for diff:k(beta) ; prob(X=1)
				log_q_x_beta = (1-beta)*(b_A*v') + (beta)*(b_B*v');
				for k = 1:K
					log_q_x_beta(k) = log_q_x_beta(k) + ...
								sum(log( 1+exp( (1-beta(k))*(v*W_A+a_A) ) ), 2) + ...
								sum(log( 1+exp( (beta(k))*(v*W_B+a_B) ) ), 2);
								% length:K
				end
				% q(beta|x) known:x_k+1 ; for diff:k(beta) ;
				q_x_beta = exp(log_q_x_beta);
				log_q_beta_x = log_q_x_beta + log(r) - log(Z) - log(sum(q_x_beta.*r./Z));
				q_beta_x = exp(log_q_beta_x);	% length:K

		% second part: from q(beta|x) get beta
			% sample beta_k+1 
			% beta_specific = q_beta_x > rand(size(beta_specific));
			beta_specific = beta(randi([1,K]));

		% third part: Update c_k
			c = c + 1/N*q_beta_x;
		end
		
		% Update Z_k^{RTS}
		Z = [Z(1) ,Z(2:K).*(c(2:K)./r(2:K))*(r(1)/c(1))];
        fprintf('Finished %d iteration\n', o_iter);
	end

	% Get log(Z)
	logZ = log(Z);
	fprintf('Final, Estimated log Z(theta)=%d\n',logZ(K));

%     figure;
%     plot(1:K,c,'--gs','MarkerSize',10)
    
end
