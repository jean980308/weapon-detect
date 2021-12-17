
clear all;
clc;
t1=clock; 
fallout = VideoReader('fallout4.mp4');

for gundam=52;
   
videoFrames_19=read(fallout,gundam); %Ū���v����19�i
videoFrames_20=read(fallout,gundam+1); %Ū���v����20�i
    

 num=2;  %�M�w���ߦ�m���ƶq
  num_loop=10; %�M�w�^�骺�ƶq
   sum=0 ; %���O�`�M��0


  video_rgb=abs(videoFrames_19-videoFrames_20); %��i�Ϭ۴�������

rimg = video_rgb(:,:,1);%�Ϥ����Ĥ@����
gimg = video_rgb(:,:,2);%�Ϥ����ĤG����
bimg = video_rgb(:,:,3);%�Ϥ����ĤT����
resultr = adapthisteq(rimg);%�ϥΦ۾A������ϧ��ŲĤ@����
resultg = adapthisteq(gimg);%�ϥΦ۾A������ϧ��ŲĤG����
resultb = adapthisteq(bimg);%�ϥΦ۾A������ϧ��ŲĤT����
video_rgb = cat(3, resultr, resultg, resultb);%��T�Ӻ��צX��

   video_gray=rgb2gray(video_rgb); %���Ƕ�
    level=graythresh(video_gray);   %�γo�Ө�ƨ��Ƭ��¥զ⪺level��
%�쥻�O��0.04
    video_binarize=imbinarize(video_gray,level);%�ܦ��¥չ�
%��W�������T������
      %video_binarize(1:100,1:1280)=false%��1��100*1��11280���ܦ��¦�A�o��ڦ��I�b�@�����Pı


video_binarize=bwareaopen(video_binarize,10,8); %%�������T%    
 L=bwlabeln(video_binarize,8); %�е��ϧ�%
  Area=regionprops(video_binarize,'Area');%��X���n
   Area_cell=struct2cell(Area);%�ഫ���n��cell��
    Area_double=cell2mat(Area_cell);    %�ഫ���nvalue
     Area_double=Area_double';   % �A�ˤ���n��
      Centroid=regionprops(L,'Centroid'); %��X���ߦ�m
       Centroid_cell=struct2cell(Centroid);%�ഫ��cell��
        Centroid_double=cell2mat(Centroid_cell);   %�ഫvalue%
         Centroid_double=reshape(Centroid_double,2,size(Centroid,1));%���կx�}����m


for i=1:size(Centroid_double,2);
     t(1,i)=Centroid_double(1,i);   %�o��O���F���W�@�C��m��ĤG�C��m���� 
        %�]���ڥ����ɭԥH���W�����@�ƬOy�b�U�����ƬOx�b�A�ҥH�ڲ{�b�N�Ѥ����ӧ令�W�����@��
      %x�b�U�����@�ƬOy�b
        l(1,i)=Centroid_double(2,i);
          Centroid_double(1,i)=l(1,i);
              Centroid_double(2,i)=t(1,i);
end


                 DOT=Centroid_double';%�A�� �o�ˬݰ_�Ӧn��


%�o��O���F����Ӫ�l��m���I�۶Z�j��200�Pı�o�ˤ���ǽT

    yo=1 ;%�P�O���I�Z��200
     go=1;%�P�O���I�Z��200
     
while yo==1;
    
    %�o��O���F�P�O�H�������I�O���O�P�@�I�A���M�����|�D�X�����I�O�P�@�I
    while go==1;
        must_inequal=ceil(rand(1,num)*length(Centroid_cell));%�H�������I
       if must_inequal(1)~=must_inequal(2); %�P�O���I�O�_���P�@�I
           go=2;%�o�˥i�H���X�j��
       end;
       
    end
   
  Cent=Centroid_cell(must_inequal)                             ;%�H����X���ߦ�m
    Cent=cell2mat(Cent)                                         ; %�ܦ�cell��
      Cent=reshape(Cent,2,num)                                   ;  %���զ�m
        Cent_minus=Cent(1,:)-Cent(2,:)                            ;  %��ӭ��߬۴�
          Cent_dist=sqrt(Cent_minus(1,1)^2+Cent_minus(1,2)^2)      ;  %���ӭ��ߩ������Z��
          ;
          %�p�G ��ӭ��ߦ�m�Z���j��200���� ��yo=2�N�i�H���X�j��A�]���ڧƱ��ӭ��ߦ�m�j��200
          %���M�|�@���b�j��̭����Эp��A���S�W�L200����
if Cent_dist>=200 

    yo=2;
end
   
go=1;
end
%Cent=cell2mat(Cent)                                          %�ܦ�cell��
%Cent=reshape(Cent,2,num)                                     %���զ�m

for i=1:size(Cent,2)
t(1,i)=Cent(1,i);%�o��O���F���W�@�C��m��ĤG�C��m���� �]���ڥ����ɭԥH���W�����@�ƬOy�b�U�����ƬOx�b
  l(1,i)=Cent(2,i); %�ҥH�ڲ{�b�N�Ѥ����ӧ令�W�����@��x�b�U�����@�ƬOy�b
    Cent(1,i)=l(1,i);
      Cent(2,i)=t(1,i);
end

Cent=Cent' ;%�A�˯x�}

count_A=0,count_B=0, count_C=0,count_D=0,count_E=0 ; %�p�ƾ����O��0
            
o=0,p=0,q=0,w=0,r=0 ;%�����O�_���o���ܼƪ��ܼƬ�0

                          
                          
loop=1               ;         
                         
while loop<=num_loop %���X��
    
    a=[0 0]; %��a,b,c,d,e�t���x�}���Φ��L�~�i�H��J ���M�@��O�@�몺�Ʀr�t�@�@���x�}���ﵥ
    b=[0 0];
    c=[0 0];
    d=[0 0];
    e=[0 0];
     
    
    
       j=1
       while j<=size(Centroid,1) %���ߪ��ƶq
             i=1;
          while i<=num %num����ڭn�ХX�X�Ӫ��� 
              
              dal(i,:)=DOT(j,:)-Cent(i,:) ;%�C�@�ӭ��ߦ�m��rand���X�����ߴ
               i=i+1;
               
           end
       
       
       m=1;
      while m<=num %��Z��
          
             
         distance(m,1)=sqrt(dal(m,1)^2+dal(m,2)^2)  ;%��Z�� 
        m=m+1;
          
      end
                
      
          minmum=min(distance); %��X�̤p�Z������
              special=find(distance==minmum); %��ĴX�� �N�N��L�O�ݩ�a b c d e�Y�@��
      
      
      %�`�N�j�p�ga b c A B C�p�g�O���F�t��k�P�_���쩳�n��X�Ӫ��~
      
      if special==1        %�k�bA
          
          
            count_A=count_A+1         ; %�C�p�ƾ�
             a(count_A,1:2)=DOT(j,:)  ; %�⭫�ߦ�m��J�L�h
               a_area(count_A,1)=Area_double(j,1);%�ڧ⭱�n����m�O�� ��K��X�L�O���ӭ���
                 o=1                  ; %�ΨӪ�ܳo�Ӧa�観�Ʀr��J
                    end
      
      if special==2  %�k�bB
         
          count_B=count_B+1          ; %�C�p�ƾ�
            b(count_B,1:2)=DOT(j,:)   ;     %�⭫�ߦ�m��J�L
              b_area(count_B,1)=Area_double(j,1);%�ڧ⭱�n����m�O�� ��K��X�L�O���ӭ���
                 p=1                  ; %�ΨӪ�ܳo�Ӧa�観�Ʀr��J
       end
       
       if special==3 %�k�bC
           
          
          count_C=count_C+1           ;%�C�p�ƾ�
           c(count_C,:)=DOT(j,:)       ;%�⭫�ߦ�m��J�L�h
            c(count_C,3)=Area_double(j,1);
             q=1                   ;%�ΨӪ�ܳo�Ӧa�観�Ʀr��J
           
      end
       
       
       if special==4 %�k�bD
        
          count_D=count_D+1         ; %�C�p�ƾ�
             d(count_D,:)=DOT(j,:)   ;   %�⭫�ߦ�m��J�L�h
               w=1                   ;%�ΨӪ�ܳo�Ӧa�観�Ʀr��J
       end
       
        if special==5  %�k�bE
       
           count_E=count_E+1          ;%�C�p�ƾ�
               e(count_E,:)=DOT(j,:)   ;   %�⭫�ߦ�m��J�L�h
                 r=1                  ; %�ΨӪ�ܳo�Ӧa�観�Ʀr��J
        end
                   
          j=j+1;
       end
      





if isempty(o)==0   %�P�_�O�_���Ψ�
     if size(a,1)>=2
         mean_A=mean(a);    %�⥭����X��m
           end
     if size(a,1)==1
         mean_A=a;         %��m�@��
           end
end

if isempty(p)==0  %�P�_�O�_���Ψ�
    if size(b,1)>=2
        mean_B=mean(b) ;   %�⥭����X��m
                    end
    
    if size(b,1)==1
        mean_B=b;          %��m�@��
                    end
  
end
    
if isempty(q)==0  %�P�_�O�_���Ψ�
    
    mean_C=mean(c) ;   %�⥭����X��m
    
    
      end
        
if isempty(w)==0  %�P�_�O�_���Ψ�
    
   mean_D=mean(d)   ; %�⥭����X��m
    
       end


if isempty(r)==0  %�P�_�O�_���Ψ�
    
   mean_E=mean(e)    ;%�⥭����X��m
    
end

sum=o+p+q+w+r   ; %��X�`�@�n�����X�Ӫ���  


if sum==1      %�@�Ӫ����
   
    
    mean_mean=mean_A;
       
      end


if sum==2    %��Ӫ���

   mean_mean=cat(1,mean_A,mean_B);

     end

if sum==3   %�T�Ӫ���
    
    mean_mean=cat(1,mean_A,mean_B,mean_C);
     
     end

if sum==4   %�|�Ӫ���
   
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D)
    
     end

if sum==5   %���Ӫ���
    
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D,mean_E)
    
     end
  


Cent=mean_mean ; %�⥭���ȿ�J����
count_A=0    ; %��Ƽ��k��0
count_B=0    ; %��Ƽ��k��0
count_C=0    ;    %��Ƽ��k��0     
count_D=0    ;%��Ƽ��k��0
count_E=0    ;%��Ƽ��k��0


if(loop<num_loop)  %��a b c d e a_area b_area distance dal ���Ʀr�M������]���n�@�����s�M��a b c d e����m
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
count_A=0     ;%��Ƽ��k��0
count_B=0     ;%��Ƽ��k��0
count_C=0      ;  %��Ƽ��k��0     
count_D=0    ;%��Ƽ��k��0
count_E=0    ;%��Ƽ��k��0


end


%�o��P�_�O�_����Ӫ���

    

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

         
singleFrame = read(fallout,gundam); %Ū���v�����Y�@�i�Ϥ�

%�o��O�Q�Υ[�`�ӧP�O���ѧڬO�n��X�Ӫ���
if sum==1||sum==2||sum==3||sum==4||sum==5 
A_centroid(1,:)=Cent(1,:); %�⭫�ߦ�m��J��A

           
        
       g=0
       %�o��O��A��distance��A_dal
           while g<size(a,1)
             g=g+1 ;
              A_dal(g,:)=a(g,:)-A_centroid(1,:); %�C�@�ӭ��ߦ�m��rand���X�����ߴ
              A_distance(g,1)=sqrt(A_dal(g,1)^2+A_dal(g,2)^2);%�䭫�ߪ��Z��
           
           end
           
           
            A_delete=find(A_distance>=150);%����A_distance�Z���j��150���I�����Oa����m
            a_isolate(:,:)=a(A_delete,:) ;%���t�ߪ��I�T���y�Ц�m
            
            
              l=1 ;
               while l<size(a_isolate,1)
                  
                   
                    s=1 ;
                    while s<size(a,1)             
                      
                   A_isolate_dal(s,:)=a(s,:)-a_isolate(l,:)%u��a���C�@���I��m�˽դ@�ӭn�Q�ű�a����m
                  A_isolate_distance(s,1)=sqrt(A_isolate_dal(s,1).^2+A_isolate_dal(s,2).^2)%��Xa���Z��
                          s=s+1
                    end
                    
                    
                    
                   a_area_sum=a_area(find(A_isolate_distance<=150),1)%���a�d��p��150�⨺�Ǧ�m�����X�L�̨C�@�ӭ��n
                   a_area_sum_real=0 %���O0���M�L�n���|���~
                    
                   of=1
                    while of<size(a_area_sum,1)
                        a_area_sum_real=a_area_sum(of,1)+ a_area_sum_real; %�@�����_�[
                        of=of+1 ;

                    end
                    
                  Area_sum(l)=a_area_sum_real  ; %�Q�O���C�ӭn�Q�R����n
                    if  a_area_sum_real<=4500   %�P�_�p��4500���n���I
                            a(A_delete(l,1),:)=[]; %�����R�������I
                            a_area(A_delete(l,1))=[];%�����R�����ӭ��n
                            A_dal(A_delete(l,1),:)=[];%�����R������dal
                            A_distance(A_delete(l,1))=[];%�����R������A_distance
                            A_delete(l:end,1)=A_delete(l:end,1)-1  ;%�]�������I�Q�R���s�a��m���n���U���ɩҥH��1
                            
                    end
                    
                    l=l+1;
                   %�����M��
                    if l<size(a_isolate,1)
                   clear a_area_sum_real ; 
                   clear A_isolate_dal;
                   clear A_isolate_distance;
                  clear a_area_sum;
                  
                    end
                   
                      
                    end 
    %�p�Ga�O���Ʀr���O�Ū�           
if isempty(a)==0         
a_sum=0 ;%���ga_sum��0


as=1   ; %as����1�ΨӲ֥[a��ӭ��n
while as<=size(a_area,1)

a_sum=a_area(as,1)+a_sum ;
as=as+1 ;

end
         %���Ѱ��]a�����n�j��2000
      if a_sum>=2000                 
              %���m �W�U���k
        A_top=max(a(:,1)) ; %�U
        A_down=min(a(:,1)); %�W
        A_right=max(a(:,2));%�k
        A_left =min(a(:,2));%��
        
        %�e��
    
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

    
    B_centroid(1,:)=Cent(2,:) ;%�䭫�߲ĤG�I��b�I

            t=0 ;
           while t<size(b,1) 
              
              t=t+1;
              B_dal(t,:)=b(t,:)-B_centroid(1,:) ;%�C�@�ӭ��ߦ�m��rand���X�����ߴ
              B_distance(t,1)=sqrt(B_dal(t,1)^2+B_dal(t,2)^2) ; %�C�@�Ӹ򭫤�b�۴�Z��
              
           end
            
            B_delete=find(B_distance>=150);%�i�H���D���ߪ��ĴX�Ӧ�m�]Centroid) �i�H�Ψӧ�area
            B_isolate(:,:)=b(B_delete,:) ;%���W�L�Z��150��B�y�Ъ���m �ӧ�b���y�Ц�m�A
               l=1 ;
              while l<size(B_isolate,1)
                 
                    u=1 ;
                   while u<size(b,1)
                      
                    B_isolate_dal(u,:)=b(u,:)-B_isolate(l,:); %�C�@�Ib����m�ű��W�L�Z��150��b��m
                     
                    B_isolate_distance(u,1)=sqrt(B_isolate_dal(u,1).^2+B_isolate_dal(u,2).^2)  ;%�������Z��
                  
                    u=u+1;
                    end
                    
                    
                    b_area_sum=b_area(find(B_isolate_distance<=150),1)%�����B���Z���p��150����m�b��쭱�n�x�s�bb_area_sum
                    b_area_sum_real=0  ;
                    
                    og=1
                    while og<=size(b_area_sum,1)
                      
                       
            
                         b_area_sum_real=b_area_sum(og,1)+ b_area_sum_real ;%�@�����_�ۥ[ �i�H�p��X�o���I�d�򪺭��n
                         og=og+1  ;
                        
                    end
                    %��p��4500���I�⥦�R��
                       if  b_area_sum_real<=4500
                            
                           b(B_delete(l,1),:)=[] ; %��b����m�R��
                           b_area(B_delete(l,1))=[]; %b�����n���R��
                            B_dal(B_delete(l,1),:)=[]; %b_dal���R��
                            B_distance(B_delete(l,1))=[] ; %b���Z�����R��
                           B_delete(l:end,1)=B_delete(l:end,1)-1  ;
                           
                       end
                       
                       l=l+1  ;
                       
                      %�@�w�nclear���M�L�|�@���|�[�����w�g�w�g���Q�R���F
                    if l<size(B_isolate,1)
                       clear B_isolate_dal    ;
                       clear B_isolate_distance    ;
                       clear b_area_sum   ;
                       clear b_area_sum_real
                       
                    end
              end

%���m             
        

 if isempty(b)==0    

b_sum=0  ;
bs=1  ;

while  bs<size(b_area,1)
    
b_sum=b_area(bs,1)+b_sum   ;
bs=bs+1    ;

end
%2000
if b_sum>=2000


        B_top=max(b(:,1)) ; %�W�U
        B_down=min(b(:,1)); %�W�U
        B_right=max(b(:,2));%���k
        B_left =min(b(:,2));%���k
    %�e��    
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
               
      % C_top=max(c(:,1))  %�W�U
      % C_down=min(c(:,1)) %�W�U
      % C_right=max(c(:,2))%���k
     %  C_left =min(c(:,2))%���k
   
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
               
               
      % D_top=max(d(:,1))  %�W�U
     %  D_down=min(d(:,1)) %�W�U
      % D_right=max(d(:,2))%���k
    %   D_left =min(d(:,2))%���k
       
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
               
     %            E_top=max(e(:,1))  %�W�U
    %             E_down=min(e(:,1)) %�W�U
   %              E_right=max(e(:,2))%���k
  %               E_left =min(e(:,2))%���k
    
    
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
              
  

question(:,:,:,gundam) = singleFrame%�O���v����
       
  
      
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
