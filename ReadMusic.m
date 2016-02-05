function [trainSet,testSet]=ReadMusic()
%--Read music files,results storing in trainSet for training and testSet for testing
%--For each genre,data is randomly split into two parts,70% for training and 30% for testing
	[~,fs]=audioread('Various Artists - Deck The Halls.mp3',[1 100]); %��ȡһ�׸����õ�����Ƶ��
	first=fs*60;
	last=first+fs*10; %����ȡ������60~70��Ĳ���
    filepath='F:\ѧϰ\������\�������\�ڶ���Project\Music'; 
    genre=dir(filepath);
    genreNum=size(genre,1)-2; %�������������Ŀ
    genreName=cell(genreNum,1); %��������
    trainSet=cell(genreNum,1);
    testSet=cell(genreNum,1);
    for k=1:genreNum
        genreName{k}=genre(k+2).name;
    end
	music_num=zeros(genreNum,1); %�����������ֵ���Ŀ
    for k=1:genreNum
        genrepath=[filepath,'\',genreName{k},'\'];   
        music_path_list= dir(strcat(genrepath,'*.mp3'));
        music_num(k)=length(music_path_list);
		piece=zeros(last-first+1,music_num(k)); %ÿһ�ж�Ӧһ������
		for m=1:music_num(k)
			piece(:,m)=mean(audioread(music_path_list(m),[first,last]),2);%ȡ������ƽ��ֵ��Ϊ��������ֵ 
		end
		piece=piece-mean(piece); %��ֱ����ʱ�����ݵľ�ֵ����0
		piece=piece./repmat(sqrt(var(piece)),last-first+1,1); %���������Ϊ1
		cache=HammingProcess(piece,0.05*fs,0.02*fs); %��֡���Ӵ�
		idx=randperm(music_num(k),round(0.7*music_num(k))); 
		trainSet{k}=cache(:,idx);
		tidx=true(1,music_num(k));
		tidx(idx)=false;
		testSet{k}=cache(:,tidx);
    end	
end

function out=HammingProcess(sig,N,M)
% A sliding Hamming window with N samples is applied to the signal using a skip of M samples
	n=1:N;
	w=0.54-0.46*cos(2*pi*(n-1)/(N-1));
	sig=reshape(sig,1,size(sig,1)*size(sig,2));
	idx=1;
	while(idx<length(sig))
		sig(idx:idx+N)=sig(idx:idx+N).*w;
		idx=idx+M;
	end
	sig=sig(round((N-M)/2):end-round((N-M)/2));
	frameNum=floor(length(sig)/M);
	sig=sig(1:frameNum*M);
	out=reshape(sig,M,frameNum);
end
