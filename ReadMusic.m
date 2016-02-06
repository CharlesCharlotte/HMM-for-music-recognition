function [trainSet,testSet,fs]=ReadMusic()
%--Read music files,results storing in trainSet for training and testSet for testing
%--For each genre,data is randomly split into two parts,70% for training and 30% for testing
	[~,fs]=audioread('Various Artists - Deck The Halls.mp3',[1 100]); %��ȡһ�׸����õ�����Ƶ��
	first=fs*60;
	last=first+fs*10; %����ȡ������60~70��Ĳ���
    filepath='F:\ѧϰ\������\�������\�ڶ���Project\Data\sample'; 
    genre=dir(filepath);
    genreNum=size(genre,1)-2; %�������������Ŀ
    genreName=cell(genreNum,1); %��������
    trainSet=cell(genreNum,1);
    testSet=cell(genreNum,1);
    for k=1:genreNum
        genreName{k}=genre(k+2).name;
    end
	music_num=zeros(genreNum,1); %�����������ֵ���Ŀ
    train_num=zeros(genreNum,1);
    test_num=zeros(genreNum,1);
    for k=1:genreNum
        genrepath=[filepath,'\',genreName{k},'\'];   
        music_path_list= dir(strcat(genrepath,'*.mp3'));
        %%%modified
        music_num(k)=min(30,length(music_path_list));
		piece=zeros(last-first,music_num(k)); %ÿһ�ж�Ӧһ������
		for m=1:music_num(k)
			piece(:,m)=mean(audioread([genrepath,music_path_list(m).name],[first+1,last]),2);%ȡ������ƽ��ֵ��Ϊ��������ֵ 
            m
        end
		piece=piece-repmat(mean(piece),last-first,1); %��ֱ����ʱ�����ݵľ�ֵ����0
		piece=piece./repmat(sqrt(var(piece)),last-first,1); %���������Ϊ1
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

