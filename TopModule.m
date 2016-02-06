clear all;close all;clc;
[trainSet,testSet,fs]=ReadMusic();
load origindata;
data=cell(genreNum,1);
%%%%
'read music done!'
pause(1);

addpath(genpath('F:\ѧϰ\������\�������\�ڶ���Project\codes\HMMall'));
% addpath(genpath('F:\ѧϰ\������\�������\�ڶ���Project\codes\voicebox'));
% Training
for k=1:genreNum
    pieces=trainSet{k}; %ÿһ�ж�Ӧһ������Ƭ��
    fsmat=fs{k}; %����Ƭ�εĲ�����
    for m=1:train_num(k)
        if(m==1)
            [r0,delta_r0,delta_delta_r0]=MFCC(pieces(:,m),fsmat(m));
            [x,y]=size(r0);
            r1=zeros(3*x,y,train_num(k));
            r1(:,:,1)=[r0;delta_r0;delta_delta_r0];
        else
            [r1(1:x,:,m),r1(x+1:2*x,:,m),r1(2*x+1:3*x,:,m)]=MFCC(pieces(:,m),fsmat(m));
        end
        m
    end
    data{k}=r1;
    [prior{k},transmat{k},mu{k},Sigma{k},mixmat{k}]=Train(r1);
end
save hmm prior transmat mu Sigma mixmat;
%%%%
'train done!'
pause(1);

%Testing
load hmm;
num=cell(genreNum,1);%ÿ������Ƭ�εķ�����
for k=1:genreNum
    testset=testSet{k};
    num0=zeros(test_num(k),1);
    fsmat=fs{k};
    for m=1:test_num(k)
        [r,delta_r,delta_delta_r]=MFCC(testset(:,m),fsmat(m));
        testdata=[r;delta_r;delta_delta_r];
        loglik=zeros(genreNum,1);
        for n=1:genreNum
            loglik(n)=mhmm_logprob(testdata, prior{n}, transmat{n}, mu{n}, Sigma{n}, mixmat{n});
        end
        [~,num0(m)]=max(loglik);
        m
    end
    num{k}=num0;
    clear num0 testset;
end
rmpath(genpath('F:\ѧϰ\������\�������\�ڶ���Project\codes\HMMall'));
%Evaluating
result=zeros(genreNum);
for k=1:genreNum
    numproc=num{k};
    for m=1:genreNum
        result(k,m)=length(find(numproc==m));
    end
    result(k,:)=result(k,:)./sum(result(k,:));
end
save result result;

