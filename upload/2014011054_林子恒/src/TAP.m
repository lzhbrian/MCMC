%% TAP method
% Version 1.0.0
% Work by Brian Lin, Tzu-Heng, Electronic Engineering, Tsinghua University
% Implementation of TAP-method to estimate Z(\theta)
% in matlab

%% Info
	% Input:
		% W - weight
		% a - visible bias
		% b - hidden bias
		% max_iteration_time
		% set_eps - for convergence
        % plot_or_not - 1 to plot
	% Output:
		% Z - Z(theta)
		% Convergent_time - Convergent time
	% eg. Usage:
		% [Z, convergence_time] = TAP(W, a, b, 10000, 1);

%% Reference: 
	% Marylou Gabrie et al.
	% Training Restricted Boltzmann Machines via the Thouless-Anderson-Palmer Free Energy

function [Z, Convergent_time] = TAP(W, a, b, max_iteration_time, set_eps, plot_or_not)

	fprintf('Running TAP with max_iter_time=%d, eps=%f ...\n',max_iteration_time,set_eps);
	% Note: logsig(n) = 1 / (1 + exp(-n))

	%% Some info
		len_vis = length(a);
		len_hid = length(b);
		% a little bit diff for a,b
		W_2 = W.^2;			% W^2
		Convergent_time = 0;
    
	%% calc m^{v} & m^{h} Eq.9,10
    if plot_or_not == 1
        figure;
    end
		m_v = zeros(1,len_vis);		% represent m_v(t)
		m_h = zeros(1,len_hid);		% represent m_h(t)
		for iter = 1:max_iteration_time
			last_m_v = m_v;
			last_m_h = m_h;
			m_h = logsig( b + m_v*W - ((m_v-m_v.^2)*W_2).*(m_h-1/2) );
			m_v = logsig( a + (W*m_h')' - ( (m_v-1/2)'.*(W_2*(m_h-m_h.^2)') )' );
			if mean(abs(m_v-last_m_v)) < set_eps
				Convergent_time = iter;
				fprintf('\tConvergent in %d times\n',iter)
				break;
            end
            if plot_or_not == 1
                subplot(2,1,1);hold on;scatter(iter,mean(m_h),'r');
                subplot(2,1,2);hold on;scatter(iter,mean(m_v),'b');
            end
        end
        xlabel('Iteration Time')
        subplot(2,1,1);ylabel('m_h');set(gca,'fontsize',16)
        subplot(2,1,2);ylabel('m_v');set(gca,'fontsize',16)
        
	%% Add them all
		% Calc Entropy: S(m^{v},m^{h})
		m_v_entropy = m_v*log(m_v)' + (1-m_v)*log(1-m_v)';
		m_h_entropy = m_h*log(m_h)' + (1-m_h)*log(1-m_h)';
		Entropy = m_v_entropy + m_h_entropy;

		% Calc Second_part: sum_{i} a_{i}*m^{v}_{i} + sum_{i} a_{i}*m^{v}_{i}
		Second_part = a*m_v' + b*m_h';

		% Calc Third_part: sum_{i,j} W_ij * m^{v}_i * m^{h}_j + W_ij/2 * (m^{v}_i - (m^{v}_i)^2)*(m^{v}_j - (m^{v}_j)^2)
		Third_part = m_v*W*m_h' + 1/2*(m_v-m_v.^2)*W_2*(m_h-m_h.^2)';

		% Add them all, F = -ln(Z(\theta))
		F = Entropy - Second_part - Third_part;
		Z = -F;
		fprintf('Final, Estimated log Z(theta)=%f\n',Z)

end






