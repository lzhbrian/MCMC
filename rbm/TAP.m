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
	% Output:
		% Z - Z(theta)
		% Convergent_time - Convergent time
	% eg. Usage:
		% [Z, convergence_time] = TAP(W, a, b, 10000, 1);

%% Reference: 
	% Marylou Gabrie et al.
	% Training Restricted Boltzmann Machines via the Thouless-Anderson-Palmer Free Energy

function [Z, Convergent_time] = TAP(W, a, b, max_iteration_time, set_eps)

	% Note: logsig(n) = 1 / (1 + exp(-n))

	%% Some info
		len_vis = length(a);
		len_hid = length(b);
		% a little bit diff for a,b
		W_2 = W.^2;			% W^2

	%% calc m^{v} & m^{h} Eq.9,10
		m_v = zeros(1,len_vis);		% represent m_v(t)
		m_h = zeros(1,len_hid);		% represent m_h(t)
		temp_m_v = ones(1,len_vis);	% represent m_v(t+1)
		temp_m_h = ones(1,len_hid);	% represent m_h(t+1)

		for iter = 1:max_iteration_time
			if sum(abs(m_v-temp_m_v)) < set_eps
				Convergent_time = iter;
				fprintf('Convergent in %d times\n',iter)
				break;
			end
			% m_v(t) = m_v(t-1)
			m_v = temp_m_v;
			m_h = temp_m_h;

			% Calc m^{h}
			for j = 1:len_hid
				% Calc sigma(...)
				sigma_blah = 0;
				for i = 1:len_vis
					temp = W(i,j)*m_v(i) - W_2(i,j)*(m_h(j)-1/2)*(m_v(i)-m_v(i)^2);
					sigma_blah = sigma_blah + temp;
				end
				% Add
				temp_m_h(j) = logsig(b(j) + sigma_blah);
			end

			% Calc m^{v}
			for i = 1:len_vis
				% Calc sigma
				sigma_blah = 0;
				for j = 1:len_hid
					temp = W(i,j)*temp_m_h(j) - W_2(i,j)*(m_v(i)-1/2)*(temp_m_h(j)-temp_m_h(j)^2);
					sigma_blah = sigma_blah + temp;
				end
				% Add
				temp_m_v(i) = logsig(a(i) + sigma_blah);
			end
		end
		% output
		m_v = temp_m_v;
		m_h = temp_m_h;
		disp('Finished Calc m^v, m^h\n')

	%% Add them all
		% Calc Entropy: S(m^{v},m^{h})
		Entropy = 0;
		for i = 1:len_vis
			temp = m_v(i)*log(m_v(i)) + (1-m_v(i))*log(1-m_v(i));
			Entropy = Entropy + temp;
		end
		for j = 1:len_hid
			temp = m_h(j)*log(m_h(j)) + (1-m_h(j))*log(1-m_h(j));
			Entropy = Entropy + temp;
		end

		disp('Finished Calc Entropy\n')

		% Calc Second_part: sum_{i} a_{i}*m^{v}_{i} + sum_{i} a_{i}*m^{v}_{i}
		Second_part = 0;
		for i = 1:len_vis
			temp = a(i)*m_v(i);
			Second_part = Second_part + temp;
		end
		for j = 1:len_hid
			temp = b(j)*m_h(j);
			Second_part = Second_part + temp;
		end
		disp('Finished Calc Second Part\n')

		% Calc Third_part: sum_{i,j} W_ij * m^{v}_i * m^{h}_j + W_ij/2 * (m^{v}_i - (m^{v}_i)^2)*(m^{v}_j - (m^{v}_j)^2)
		Third_part = 0;
		for i = 1:len_vis
			for j = 1:len_hid
				Third_part = Third_part + W(i,j)*m_v(i)*m_h(j);
				Third_part = Third_part + W(i,j)^2/2 * (m_v(i)-(m_v(i))^2) * (m_h(j)-(m_h(j))^2);
			end
		end
		disp('Finished Calc Third Part\n')

		% Add them all, F = -ln(Z(\theta))
		F = Entropy - Second_part - Third_part;
		Z = -F;
		fprintf('\nFinal, Estimated Z(theta)=%d\n',Z)

end






