function [trainSet,testSet]=ReadMusic()
%--Read music files,results storing in trainSet for training and testSet for testing
%--For each genre,data is randomly split into two parts,70% for training and 30% for testing
	[~,fs]=audioread('Various Artists - Deck The Halls.mp3',[1 100]); %读取一首歌曲得到采样频率
	first=fs*60;
	last=first+fs*10; %将读取乐曲第60~70秒的部分
    filepath='F:\学习\大三上\随机过程\第二次Project\Music'; 
    genre=dir(filepath);
    genreNum=size(genre,1)-2; %音乐曲风类别数目
    genreName=cell(genreNum,1); %曲风名称
    trainSet=cell(genreNum,1);
    testSet=cell(genreNum,1);
    for k=1:genreNum
        genreName{k}=genre(k+2).name;
    end
	music_num=zeros(genreNum,1); %各种曲风音乐的数目
    for k=1:genreNum
        genrepath=[filepath,'\',genreName{k},'\'];   
        music_path_list= dir(strcat(genrepath,'*.mp3'));
        music_num(k)=length(music_path_list);
		piece=zeros(last-first+1,music_num(k)); %每一列对应一首乐曲
		for m=1:music_num(k)
			piece(:,m)=mean(audioread(music_path_list(m),[first,last]),2);%取多声道平均值作为单声道的值 
		end
		piece=piece-mean(piece); %减直流将时域数据的均值调成0
		piece=piece./repmat(sqrt(var(piece)),last-first+1,1); %将方差调整为1
		cache=HammingProcess(piece,0.05*fs,0.02*fs); %分帧，加窗
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
