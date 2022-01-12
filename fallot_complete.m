
clear all;
clc;
t1=clock; 
fallout = VideoReader('fallout4.mp4');

for gundam=52;
   
videoFrames_19=read(fallout,gundam); %讀取影片第19張
videoFrames_20=read(fallout,gundam+1); %讀取影片第20張
    

 num=2;  %決定重心位置的數量
  num_loop=10; %決定回圈的數量
   sum=0 ; %先令總和為0


  video_rgb=abs(videoFrames_19-videoFrames_20); %兩張圖相減取絕對值

rimg = video_rgb(:,:,1);%圖片的第一維度
gimg = video_rgb(:,:,2);%圖片的第二維度
bimg = video_rgb(:,:,3);%圖片的第三維度
resultr = adapthisteq(rimg);%使用自適應直方圖均衡第一維度
resultg = adapthisteq(gimg);%使用自適應直方圖均衡第二維度
resultb = adapthisteq(bimg);%使用自適應直方圖均衡第三維度
video_rgb = cat(3, resultr, resultg, resultb);%把三個維度合併

   video_gray=rgb2gray(video_rgb); %取灰階
    level=graythresh(video_gray);   %用這個函數取化為黑白色的level值
%原本是改0.04
    video_binarize=imbinarize(video_gray,level);%變成黑白圖
%把上面的雜訊給消除
      %video_binarize(1:100,1:1280)=false%把1到100*1到11280都變成黑色，這邊我有點在作弊的感覺


video_binarize=bwareaopen(video_binarize,10,8); %%消除雜訊%    
 L=bwlabeln(video_binarize,8); %標註圖形%
  Area=regionprops(video_binarize,'Area');%找出面積
   Area_cell=struct2cell(Area);%轉換面積成cell檔
    Area_double=cell2mat(Area_cell);    %轉換面積value
     Area_double=Area_double';   % 顛倒比較好看
      Centroid=regionprops(L,'Centroid'); %找出重心位置
       Centroid_cell=struct2cell(Centroid);%轉換成cell檔
        Centroid_double=cell2mat(Centroid_cell);   %轉換value%
         Centroid_double=reshape(Centroid_double,2,size(Centroid,1));%重組矩陣的位置


for i=1:size(Centroid_double,2);
     t(1,i)=Centroid_double(1,i);   %這邊是為了讓上一列位置跟第二列位置互換 
        %因為我打的時候以為上面那一排是y軸下面那排是x軸，所以我現在就由互換來改成上面那一排
      %x軸下面那一排是y軸
        l(1,i)=Centroid_double(2,i);
          Centroid_double(1,i)=l(1,i);
              Centroid_double(2,i)=t(1,i);
end


                 DOT=Centroid_double';%顛倒 這樣看起來好看


%這邊是為了讓兩個初始位置的點相距大於200感覺這樣比較準確

    yo=1 ;%判別兩點距離200
     go=1;%判別兩點距離200
     
while yo==1;
    
    %這邊是為了判別隨機的兩點是不是同一點，不然有機會挑出的兩點是同一點
    while go==1;
        must_inequal=ceil(rand(1,num)*length(Centroid_cell));%隨機的兩點
       if must_inequal(1)~=must_inequal(2); %判別兩點是否為同一點
           go=2;%這樣可以跳出迴圈
       end;
       
    end
   
  Cent=Centroid_cell(must_inequal)                             ;%隨機找出重心位置
    Cent=cell2mat(Cent)                                         ; %變成cell值
      Cent=reshape(Cent,2,num)                                   ;  %重組位置
        Cent_minus=Cent(1,:)-Cent(2,:)                            ;  %兩個重心相減
          Cent_dist=sqrt(Cent_minus(1,1)^2+Cent_minus(1,2)^2)      ;  %算兩個重心彼此的距離
          ;
          %如果 兩個重心位置距離大於200的話 改yo=2就可以跳出迴圈，因為我希望兩個重心位置大於200
          %不然會一直在迴圈裡面反覆計算，算到又超過200為止
if Cent_dist>=200 

    yo=2;
end
   
go=1;
end
%Cent=cell2mat(Cent)                                          %變成cell值
%Cent=reshape(Cent,2,num)                                     %重組位置

for i=1:size(Cent,2)
t(1,i)=Cent(1,i);%這邊是為了讓上一列位置跟第二列位置互換 因為我打的時候以為上面那一排是y軸下面那排是x軸
  l(1,i)=Cent(2,i); %所以我現在就由互換來改成上面那一排x軸下面那一排是y軸
    Cent(1,i)=l(1,i);
      Cent(2,i)=t(1,i);
end

Cent=Cent' ;%顛倒矩陣

count_A=0,count_B=0, count_C=0,count_D=0,count_E=0 ; %計數器先令為0
            
o=0,p=0,q=0,w=0,r=0 ;%偵測是否有這個變數的變數為0

                          
                          
loop=1               ;         
                         
while loop<=num_loop %做幾次
    
    a=[0 0]; %把a,b,c,d,e另成矩陣的形式他才可以輸入 不然一邊是一般的數字另一鞭式矩陣不對等
    b=[0 0];
    c=[0 0];
    d=[0 0];
    e=[0 0];
     
    
    
       j=1
       while j<=size(Centroid,1) %重心的數量
             i=1;
          while i<=num %num等於我要標出幾個物體 
              
              dal(i,:)=DOT(j,:)-Cent(i,:) ;%每一個重心位置跟rand取出的重心減掉
               i=i+1;
               
           end
       
       
       m=1;
      while m<=num %算距離
          
             
         distance(m,1)=sqrt(dal(m,1)^2+dal(m,2)^2)  ;%算距離 
        m=m+1;
          
      end
                
      
          minmum=min(distance); %找出最小距離的值
              special=find(distance==minmum); %找第幾行 就代表他是屬於a b c d e某一類
      
      
      %注意大小寫a b c A B C小寫是為了演算法判斷說到底要找幾個物品
      
      if special==1        %歸在A
          
          
            count_A=count_A+1         ; %列計數器
             a(count_A,1:2)=DOT(j,:)  ; %把重心位置輸入過去
               a_area(count_A,1)=Area_double(j,1);%我把面積的位置記住 方便找出他是底個重心
                 o=1                  ; %用來表示這個地方有數字輸入
                    end
      
      if special==2  %歸在B
         
          count_B=count_B+1          ; %列計數器
            b(count_B,1:2)=DOT(j,:)   ;     %把重心位置輸入過
              b_area(count_B,1)=Area_double(j,1);%我把面積的位置記住 方便找出他是底個重心
                 p=1                  ; %用來表示這個地方有數字輸入
       end
       
       if special==3 %歸在C
           
          
          count_C=count_C+1           ;%列計數器
           c(count_C,:)=DOT(j,:)       ;%把重心位置輸入過去
            c(count_C,3)=Area_double(j,1);
             q=1                   ;%用來表示這個地方有數字輸入
           
      end
       
       
       if special==4 %歸在D
        
          count_D=count_D+1         ; %列計數器
             d(count_D,:)=DOT(j,:)   ;   %把重心位置輸入過去
               w=1                   ;%用來表示這個地方有數字輸入
       end
       
        if special==5  %歸在E
       
           count_E=count_E+1          ;%列計數器
               e(count_E,:)=DOT(j,:)   ;   %把重心位置輸入過去
                 r=1                  ; %用來表示這個地方有數字輸入
        end
                   
          j=j+1;
       end
      





if isempty(o)==0   %判斷是否有用到
     if size(a,1)>=2
         mean_A=mean(a);    %算平均找出位置
           end
     if size(a,1)==1
         mean_A=a;         %位置一樣
           end
end

if isempty(p)==0  %判斷是否有用到
    if size(b,1)>=2
        mean_B=mean(b) ;   %算平均找出位置
                    end
    
    if size(b,1)==1
        mean_B=b;          %位置一樣
                    end
  
end
    
if isempty(q)==0  %判斷是否有用到
    
    mean_C=mean(c) ;   %算平均找出位置
    
    
      end
        
if isempty(w)==0  %判斷是否有用到
    
   mean_D=mean(d)   ; %算平均找出位置
    
       end


if isempty(r)==0  %判斷是否有用到
    
   mean_E=mean(e)    ;%算平均找出位置
    
end

sum=o+p+q+w+r   ; %算出總共要偵測幾個物體  


if sum==1      %一個物體時
   
    
    mean_mean=mean_A;
       
      end


if sum==2    %兩個物體

   mean_mean=cat(1,mean_A,mean_B);

     end

if sum==3   %三個物體
    
    mean_mean=cat(1,mean_A,mean_B,mean_C);
     
     end

if sum==4   %四個物體
   
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D)
    
     end

if sum==5   %五個物體
    
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D,mean_E)
    
     end
  


Cent=mean_mean ; %把平均值輸入重心
count_A=0    ; %把數數歸為0
count_B=0    ; %把數數歸為0
count_C=0    ;    %把數數歸為0     
count_D=0    ;%把數數歸為0
count_E=0    ;%把數數歸為0


if(loop<num_loop)  %把a b c d e a_area b_area distance dal 等數字清除等到因為要一直重新尋找a b c d e的位置
    p=0;
    clear a ;
    clear b;
    clear c;
    clear d;
    clear e;
    clear a_area;
    clear b_area;
    clear a_sum;
    clear b_sum;
    clear distance;
    clear dal;
count_A=0     ;%把數數歸為0
count_B=0     ;%把數數歸為0
count_C=0      ;  %把數數歸為0     
count_D=0    ;%把數數歸為0
count_E=0    ;%把數數歸為0


end


%這邊判斷是否有兩個物體

    

%if a_sum<1700||b_sum<1700
    
 %  num=1 
  %loop=0
  
 % if a_sum<1700
      
  %    if size(Cent,1)>=1
   %   Cent(1,:)=[]
    %  end
      
  %end
  
 % if b_sum<1700
      
  %    if size(Cent,1)>=2
   %   Cent(2,:)=[]
  %    end
 % end 
 
  %if num_loop>=1
   %     p=0
   % clear a 
    %clear b
    %clear c
    %clear d
    %clear e
    %clear a_area
    %clear b_area
    %clear a_sum
    %clear b_sum
    %clear distance
    %clear dal
     loop=loop+1 ;
    
    
  end

         
singleFrame = read(fallout,gundam); %讀取影片的某一張圖片

%這邊是利用加總來判別今天我是要找幾個物體
if sum==1||sum==2||sum==3||sum==4||sum==5 
A_centroid(1,:)=Cent(1,:); %把重心位置輸入給A

           
        
       g=0
       %這邊是找A的distance跟A_dal
           while g<size(a,1)
             g=g+1 ;
              A_dal(g,:)=a(g,:)-A_centroid(1,:); %每一個重心位置跟rand取出的重心減掉
              A_distance(g,1)=sqrt(A_dal(g,1)^2+A_dal(g,2)^2);%找重心的距離
           
           end
           
           
            A_delete=find(A_distance>=150);%先找A_distance距離大於150的點直接是a的位置
            a_isolate(:,:)=a(A_delete,:) ;%找到孤立的點確切座標位置
            
            
              l=1 ;
               while l<size(a_isolate,1)
                  
                   
                    s=1 ;
                    while s<size(a,1)             
                      
                   A_isolate_dal(s,:)=a(s,:)-a_isolate(l,:)%u次a的每一個點位置檢調一個要被剪掉a的位置
                  A_isolate_distance(s,1)=sqrt(A_isolate_dal(s,1).^2+A_isolate_dal(s,2).^2)%算出a的距離
                          s=s+1
                    end
                    
                    
                    
                   a_area_sum=a_area(find(A_isolate_distance<=150),1)%找到a範圍小於150把那些位置都轉找出他們每一個面積
                   a_area_sum_real=0 %先令0不然他好像會錯誤
                    
                   of=1
                    while of<size(a_area_sum,1)
                        a_area_sum_real=a_area_sum(of,1)+ a_area_sum_real; %一直不斷加
                        of=of+1 ;

                    end
                    
                  Area_sum(l)=a_area_sum_real  ; %想記錄每個要被刪減的面積
                    if  a_area_sum_real<=4500   %判斷小於4500面積的點
                            a(A_delete(l,1),:)=[]; %直接刪掉那個點
                            a_area(A_delete(l,1))=[];%直接刪掉那個面積
                            A_dal(A_delete(l,1),:)=[];%直接刪掉那個dal
                            A_distance(A_delete(l,1))=[];%直接刪掉那個A_distance
                            A_delete(l:end,1)=A_delete(l:end,1)-1  ;%因為那個點被刪掉連帶位置都要往下遞補所以減1
                            
                    end
                    
                    l=l+1;
                   %全部清除
                    if l<size(a_isolate,1)
                   clear a_area_sum_real ; 
                   clear A_isolate_dal;
                   clear A_isolate_distance;
                  clear a_area_sum;
                  
                    end
                   
                      
                    end 
    %如果a是有數字不是空的           
if isempty(a)==0         
a_sum=0 ;%先射a_sum為0


as=1   ; %as等於1用來累加a整個面積
while as<=size(a_area,1)

a_sum=a_area(as,1)+a_sum ;
as=as+1 ;

end
         %今天假設a的面積大於2000
      if a_sum>=2000                 
              %找位置 上下左右
        A_top=max(a(:,1)) ; %下
        A_down=min(a(:,1)); %上
        A_right=max(a(:,2));%右
        A_left =min(a(:,2));%左
        
        %畫圖
    
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_left),1)=255 ;
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_left),2)=0  ;
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_left),3)=0  ;
                 
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_right),1)=255 ;
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_right),2)=0 ;
    singleFrame(ceil(A_down):ceil(A_top),ceil(A_right),3)=0 ;
    
    
    singleFrame(ceil(A_down),ceil(A_left):ceil(A_right),1)=255 ;
    singleFrame(ceil(A_down),ceil(A_left):ceil(A_right),2)=0 ;
    singleFrame(ceil(A_down),ceil(A_left):ceil(A_right),3)=0 ;
              
    singleFrame(ceil(A_top),ceil(A_left):ceil(A_right),1)=255 ;
    singleFrame(ceil(A_top),ceil(A_left):ceil(A_right),2)=0  ;
    singleFrame(ceil(A_top),ceil(A_left):ceil(A_right),3)=0  ;
              
      end
    end
end



if sum==5||sum==2||sum==3||sum==4

    
    B_centroid(1,:)=Cent(2,:) ;%找重心第二點為b點

            t=0 ;
           while t<size(b,1) 
              
              t=t+1;
              B_dal(t,:)=b(t,:)-B_centroid(1,:) ;%每一個重心位置跟rand取出的重心減掉
              B_distance(t,1)=sqrt(B_dal(t,1)^2+B_dal(t,2)^2) ; %每一個跟重心b相減的距離
              
           end
            
            B_delete=find(B_distance>=150);%可以知道重心的第幾個位置（Centroid) 可以用來找area
            B_isolate(:,:)=b(B_delete,:) ;%找到超過距離150的B座標的位置 來找b的座標位置，
               l=1 ;
              while l<size(B_isolate,1)
                 
                    u=1 ;
                   while u<size(b,1)
                      
                    B_isolate_dal(u,:)=b(u,:)-B_isolate(l,:); %每一點b的位置剪掉超過距離150的b位置
                     
                    B_isolate_distance(u,1)=sqrt(B_isolate_dal(u,1).^2+B_isolate_dal(u,2).^2)  ;%直接找到距離
                  
                    u=u+1;
                    end
                    
                    
                    b_area_sum=b_area(find(B_isolate_distance<=150),1)%先找到B的距離小於150的位置在找到面積儲存在b_area_sum
                    b_area_sum_real=0  ;
                    
                    og=1
                    while og<=size(b_area_sum,1)
                      
                       
            
                         b_area_sum_real=b_area_sum(og,1)+ b_area_sum_real ;%一直不斷相加 可以計算出這個點範圍的面積
                         og=og+1  ;
                        
                    end
                    %找小於4500的點把它刪掉
                       if  b_area_sum_real<=4500
                            
                           b(B_delete(l,1),:)=[] ; %把b的位置刪掉
                           b_area(B_delete(l,1))=[]; %b的面積給刪掉
                            B_dal(B_delete(l,1),:)=[]; %b_dal給刪掉
                            B_distance(B_delete(l,1))=[] ; %b的距離給刪掉
                           B_delete(l:end,1)=B_delete(l:end,1)-1  ;
                           
                       end
                       
                       l=l+1  ;
                       
                      %一定要clear不然他會一直疊加明明已經已經都被刪掉了
                    if l<size(B_isolate,1)
                       clear B_isolate_dal    ;
                       clear B_isolate_distance    ;
                       clear b_area_sum   ;
                       clear b_area_sum_real
                       
                    end
              end

%找位置             
        

 if isempty(b)==0    

b_sum=0  ;
bs=1  ;

while  bs<size(b_area,1)
    
b_sum=b_area(bs,1)+b_sum   ;
bs=bs+1    ;

end
%2000
if b_sum>=2000


        B_top=max(b(:,1)) ; %上下
        B_down=min(b(:,1)); %上下
        B_right=max(b(:,2));%左右
        B_left =min(b(:,2));%左右
    %畫圖    
   singleFrame(ceil(B_down):ceil(B_top),ceil(B_left),1)=255;
   singleFrame(ceil(B_down):ceil(B_top),ceil(B_left),2)=0 ;
  singleFrame(ceil(B_down):ceil(B_top),ceil(B_left),3)=0;
                 
   singleFrame(ceil(B_down):ceil(B_top),ceil(B_right),1)=255;
   singleFrame(ceil(B_down):ceil(B_top),ceil(B_right),2)=0;
   singleFrame(ceil(B_down):ceil(B_top),ceil(B_right),3)=0;
   
    
   singleFrame(ceil(B_down),ceil(B_left):ceil(B_right),1)=255;
   singleFrame(ceil(B_down),ceil(B_left):ceil(B_right),2)=0;
   singleFrame(ceil(B_down),ceil(B_left):ceil(B_right),3)=0;
              ;
   singleFrame(ceil(B_top),ceil(B_left):ceil(B_right),1)=255;
  singleFrame(ceil(B_top),ceil(B_left):ceil(B_right),2)=0;
   singleFrame(ceil(B_top),ceil(B_left):ceil(B_right),3)=0;
         
end
 end
end
    
    %square=true(size(video_binarize,1),size(video_binarize,2))
    %square(ceil(B_down):ceil(B_top),ceil(B_left))=false
    %square(ceil(B_down):ceil(B_top),ceil(B_left))=false 
    %square(ceil(B_down):ceil(B_top),ceil(B_left))=false
                 
    %square(ceil(B_down):ceil(B_top),ceil(B_right),1)=false
    %square(ceil(B_down):ceil(B_top),ceil(B_right),2)=false
    %square(ceil(B_down):ceil(B_top),ceil(B_right),3)=false
    
    
    %square(ceil(B_down),ceil(B_left):ceil(B_right),1)=false
    %square(ceil(B_down),ceil(B_left):ceil(B_right),2)=false
    %square(ceil(B_down),ceil(B_left):ceil(B_right),3)=false
              
    %square(ceil(B_top),ceil(B_left):ceil(B_right),1)=false
    %square(ceil(B_top),ceil(B_left):ceil(B_right),2)=false
    %square(ceil(B_top),ceil(B_left):ceil(B_right),3)=false
    
   % square=uint8(square)
    %singleFrame(:,:,1)=singleFrame(:,:,1).*square(:,:,1)
    %singleFrame(:,:,2)=singleFrame(:,:,2).*square(:,:,2)
    %singleFrame(:,:,3)=singleFrame(:,:,3).*square(:,:,3) 
    
%end


%if sum==3||sum==4||sum==5
    %C_centroid(1,:)=Cent(3,:)
         %for u=1:size(c,1)
           %    C_dal(u,:)=c(u,:)-C_centroid(1,:)
          %        C_distance(u,1)=sqrt(C_dal(u,1)^2+C_dal(u,2)^2)
              
         %        end
         
        %       C_delete=find(C_distance>=150)
       %        c(C_delete,:)=[] 
               
      % C_top=max(c(:,1))  %上下
      % C_down=min(c(:,1)) %上下
      % C_right=max(c(:,2))%左右
     %  C_left =min(c(:,2))%左右
   
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_left),1)=0
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_left),2)=0 
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_left),3)=255
                 
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_right),1)=0
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_right),2)=0
    %singleFrame(ceil(C_down):ceil(C_top),ceil(C_right),3)=255
    
    
    %singleFrame(ceil(C_down),ceil(C_left):ceil(C_right),1)=0
    %singleFrame(ceil(C_down),ceil(C_left):ceil(C_right),2)=0
   % singleFrame(ceil(C_down),ceil(C_left):ceil(C_right),3)=255
 
   
   %singleFrame(ceil(C_top),ceil(C_left):ceil(C_right),1)=0
   %  singleFrame(ceil(C_top),ceil(C_left):ceil(C_right),2)=0
 %   singleFrame(ceil(C_top),ceil(C_left):ceil(C_right),3)=255
         
%end


%if sum==4||sum==5
%D_centroid(1,:)=Cent(4,:)
%hold on
           %for z=1:size(d,1)
           %    D_dal(z,:)=d(z,:)-D_centroid(1,:)
          %     D_distance(z,1)=sqrt(D_dal(z,1)^2+D_dal(z,2)^2)
              
         %  end
        %       D_delete=find(D_distance>=150)
       %        d(D_delete,:)=[]
               
               
      % D_top=max(d(:,1))  %上下
     %  D_down=min(d(:,1)) %上下
      % D_right=max(d(:,2))%左右
    %   D_left =min(d(:,2))%左右
       
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_left),1)=0
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_left),2)=100
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_left),3)=255
                 
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_right),1)=0
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_right),2)=100
    %singleFrame(ceil(D_down):ceil(D_top),ceil(D_right),3)=255
    
    
    %ingleFrame(ceil(D_down),ceil(D_left):ceil(D_right),1)=0
    %singleFrame(ceil(D_down),ceil(D_left):ceil(D_right),2)=100
    %singleFrame(ceil(D_down),ceil(D_left):ceil(D_right),3)=255
              
    %singleFrame(ceil(D_top),ceil(D_left):ceil(D_right),1)=0
    %singleFrame(ceil(D_top),ceil(D_left):ceil(D_right),2)=100
    %singleFrame(ceil(D_top),ceil(D_left):ceil(D_right),3)=255
         
               
%end
%if sum==5
%E_centroid(1,:)=Cent(5,:)
%hold on
 %for x=1:size(c,1)
          %     E_dal(x,:)=e(x,:)-E_centroid(1,:)
         %      E_distance(x,1)=sqrt(E_dal(x,1)^2+E_dal(x,2)^2)
              
        %   end

       %        E_delete=find(E_distance>=150)
      %         e(E_delete,:)=[] 
               
     %            E_top=max(e(:,1))  %上下
    %             E_down=min(e(:,1)) %上下
   %              E_right=max(e(:,2))%左右
  %               E_left =min(e(:,2))%左右
    
    
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_left),1)=100
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_left),2)=0 
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_left),3)=255
                 
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_right),1)=100
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_right),2)=0
  %  singleFrame(ceil(E_down):ceil(E_top),ceil(E_right),3)=255
    
    
   % singleFrame(ceil(E_down),ceil(E_left):ceil(E_right),1)=100
    %singleFrame(ceil(E_down),ceil(E_left):ceil(E_right),2)=0
    %singleFrame(ceil(E_down),ceil(E_left):ceil(E_right),3)=255
              
    %singleFrame(ceil(E_top),ceil(E_left):ceil(E_right),1)=100
   % singleFrame(ceil(E_top),ceil(E_left):ceil(E_right),2)=0
  %  singleFrame(ceil(E_top),ceil(E_left):ceil(E_right),3)=255
         
              
 %     end
              
  

question(:,:,:,gundam) = singleFrame%記錄影片檔
       
  
      
%if sum==2
                
%[L,P]=imseggeodesic(videoFrames_19,BW1,BW2,'AdaptiveChannelWeighting',false);figure(2);
%figure(2)
%imshow(label2rgb(L),'InitialMagnification', 50);
%title('Segmented image with three regions');


%figure(3)
%imshow(P(:,:,2),'InitialMagnification', 50)
%title('Probability that a pixel belongs to region/label 2')


% end






%clearvars -except fallout question t1

end

frameRate = fallout.FrameRate;
implay(question,frameRate);
 t2=clock;
 etime(t2,t1)
