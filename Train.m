function [prior1,transmat1,mu1,Sigma1,mixmat1]=Train(trainmat)
% trainmat contains observation sequences
    O=size(trainmat,1); %Number of coefficients in a vector 
    T=size(trainmat,2); %Number of vectors in a sequence 
    nex=size(trainmat,3); %Number of sequences 
    M=1;                %Number of mixtures 
    Q=4;                %Number of states 
    cov_type = 'full';
    % initial guess of parameters
    p=0.2;
    prior0=normalise(rand(Q,1));
    transmat0=mk_leftright_transmat(Q,p);
    [mu0, Sigma0] = mixgauss_init(Q*M,trainmat,cov_type);
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    [LL,prior1,transmat1,mu1,Sigma1,mixmat1]=mhmm_em(trainmat,prior0,transmat0,mu0,Sigma0,mixmat0,'max_iter',20);
    loglik=mhmm_logprob(trainmat,prior1,transmat1,mu1,Sigma1,mixmat1);
end
