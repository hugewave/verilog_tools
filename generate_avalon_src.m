%filename: generate_avalon_src.m
%生成符合avalon st 接口的数据源
clear all;
clc;
memdep = 2048;
width  = 11;
membits = zeros(memdep,width);
mode = 2;%模式，可以为1，2，3
framlens = [128 256 512];
msglens  = [82 183 404];
filenames = ['1024src.txt'; '2048src.txt'; '4096src.txt'];
framlen  = framlens(mode);
msglen   = msglens(mode);
filename = filenames(mode,:);
framenum = memdep/framlen;
for k = 1:framenum
    msg = 0:1:msglen-1;
    msg = mod(msg,256);
    binmsg = dec2bin(msg,8)-'0';
    binmsgframe = zeros(framlen,8);
    binmsgframe(10:10+msglen-1,:) = binmsg;
    binframe = [zeros(framlen,3) binmsgframe];
    binframe(10,1) = 1;%sop;
    binframe(10+msglen-1,2) = 1;%eop
    binframe(10:10+msglen-1,3) = 1;%val
    membits((k-1)*framlen+1:k*framlen,:) = binframe;
end
mem = bin2dec(char(membits+'0'));

fid = fopen(filename,'w');
for i = 1:memdep
    fprintf(fid,'%03x\n',mem(i));
end
fclose(fid);