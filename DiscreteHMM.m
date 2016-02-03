function [lamda,M,N]=DiscreteHMM()
% --lamda contains:(1)the initial states distribution, pie
% --               (2)the state transition probability distribution, A
% --               (3)the observation symbol probability distribution, B
% --M is the number of distinct observation symbols per state
% --N is the number of hidden states

lamda=cell(1,3);
lamda{1}=pie;
lamda{2}=A;
lamda{3}=B;
end
