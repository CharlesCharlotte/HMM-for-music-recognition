function [r,delta_r,delta_delta_r]=MFCC(s,fs)
% s is the signal to be processed
% fs is the sample rate of signal s
% r is the signal after being processed
% delta_r is  differentials of r
% delta_delta_r is differentials of delta_r
% Reference:http://ibillxia.github.io/blog/2012/07/18/MFCC-feature-extraction/
    n=fs*0.05; %֡��,50ms
    m=fs*0.02; %֡��,20ms
    l=size(s,1)*size(s,2); %�ź��ܳ���
    nbFrame=floor((l-n)/m)+1; %�ź���֡��
    M=zeros(n,nbFrame);
    for i=1:n
      for j=1:nbFrame
          M(i,j)=s(((j-1)*m)+i); %��֡
      end
    end
    h=hamming(n); %������w=0.54-0.46*cos(2*pi*x);
    M2=diag(h)*M; %��M�Ӵ����γɶԽǾ���M2
    frame=zeros(n,nbFrame);
    for i=1:nbFrame
      frame(:,i)=fft(M2(:,i)); %���п��ٸ���Ҷ�任������ת����Ƶ����
    end
    t=n/2;
    m=melfb(20,n,fs); %����20��MEL�˲���������˲�
    n2=1+floor(t);
    z=m*abs(frame(1:n2,:)).^2; %ȡǰn2��֡��������ƽ��
    r=dct(log(z)); %ȡ��������з����ұ任
    rproc=[zeros(size(r,1),1),r,zeros(size(r,1),1)];
    delta_r=zeros(size(r,1),nbFrame);
    delta_delta_r=zeros(size(r,1),nbFrame);
    for k=1:nbFrame
        delta_r(:,k)=rproc(:,k+2)-rproc(:,k);
    end
    delta_r=delta_r/2;
    delta_rproc=[zeros(size(r,1),1),delta_r,zeros(size(r,1),1)];
    for k=1:nbFrame
        delta_delta_r(:,k)=delta_rproc(:,k+2)-delta_rproc(:,k);
    end
    delta_delta_r=delta_delta_r/2;
end
function m = melfb(p, n, fs)
    % MELFB  Determine matrix for a mel-spaced filterbank
    %
    % Inputs:       p   number of filters in filterbank
    %               n   length of fft
    %               fs  sample rate in Hz
    %
    % Outputs:      x   a (sparse) matrix containing the filterbank amplitudes
    %                   size(x) = [p, 1+floor(n/2)]
    %
    f0 = 700 / fs;
    fn2 = floor(n/2);
    lr = log(1 + 0.5/f0) / (p+1);
    % convert to fft bin numbers with 0 for DC term
    bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));
    b1 = floor(bl(1)) + 1;
    b2 = ceil(bl(2));
    b3 = floor(bl(3));
    b4 = min(fn2, ceil(bl(4))) - 1;
    pf = log(1 + (b1:b4)/n/f0) / lr;
    fp = floor(pf);
    pm = pf - fp;
    r = [fp(b2:b4) 1+fp(1:b3)];
    c = [b2:b4 1:b3] + 1;
    v = 2 * [1-pm(b2:b4) pm(1:b3)];
    m = sparse(r, c, v, p, 1+fn2);
end