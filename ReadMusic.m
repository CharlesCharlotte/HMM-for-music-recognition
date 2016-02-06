function [trainSet,testSet,fs]=ReadMusic()
%--Read music files,results storing in trainSet for training and testSet for testing
%--For each genre,data is randomly split into two parts,70% for training and 30% for testing
	[~,fs]=audioread('Various Artists - Deck The Halls.mp3',[1 100]); %读取一首歌曲得到采样频率
	first=fs*60;
	last=first+fs*10; %将读取乐曲第60~70秒的部分
    filepath='F:\学习\大三上\随机过程\第二次Project\Data\sample'; 
    genre=dir(filepath);
    genreNum=size(genre,1)-2; %音乐曲风类别数目
    genreName=cell(genreNum,1); %曲风名称
    trainSet=cell(genreNum,1);
    testSet=cell(genreNum,1);
    for k=1:genreNum
        genreName{k}=genre(k+2).name;
    end
	music_num=zeros(genreNum,1); %各种曲风音乐的数目
    train_num=zeros(genreNum,1);
    test_num=zeros(genreNum,1);
    for k=1:genreNum
        genrepath=[filepath,'\',genreName{k},'\'];   
        music_path_list= dir(strcat(genrepath,'*.mp3'));
        %%%modified
        music_num(k)=min(30,length(music_path_list));
		piece=zeros(last-first,music_num(k)); %每一列对应一首乐曲
		for m=1:music_num(k)
			piece(:,m)=mean(audioread([genrepath,music_path_list(m).name],[first+1,last]),2);%取多声道平均值作为单声道的值 
            m
        end
		piece=piece-repmat(mean(piece),last-first,1); %减直流将时域数据的均值调成0
		piece=piece./repmat(sqrt(var(piece)),last-first,1); %将方差调整为1
        train_num(k)=round(0.7*music_num(k));
		idx=randperm(music_num(k),train_num(k)); 
		trainSet{k}=piece(:,idx);
		tidx=true(1,music_num(k));
		tidx(idx)=false;
		testSet{k}=piece(:,tidx);
    end	
    test_num=music_num-train_num;
    save origindata trainSet testSet fs genreNum genreName music_num train_num test_num;
end

