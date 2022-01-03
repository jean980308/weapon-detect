
clear all;
clc;
t1=clock; 
fallout = VideoReader('fallout4.mp4');

for gundam=52;
   
videoFrames_19=read(fallout,gundam); 
videoFrames_20=read(fallout,gundam+1); 
    

 num=2; 
  num_loop=10;
   sum=0 ; 


  video_rgb=abs(videoFrames_19-videoFrames_20); 

rimg = video_rgb(:,:,1);
gimg = video_rgb(:,:,2);
bimg = video_rgb(:,:,3);
resultr = adapthisteq(rimg);
resultg = adapthisteq(gimg);
resultb = adapthisteq(bimg);
video_rgb = cat(3, resultr, resultg, resultb);

   video_gray=rgb2gray(video_rgb); 
    level=graythresh(video_gray);   
    video_binarize=imbinarize(video_gray,level);
      %video_binarize(1:100,1:1280)=false


video_binarize=bwareaopen(video_binarize,10,8); 
 L=bwlabeln(video_binarize,8); 
  Area=regionprops(video_binarize,'Area');
   Area_cell=struct2cell(Area);
    Area_double=cell2mat(Area_cell);    
     Area_double=Area_double';   
      Centroid=regionprops(L,'Centroid'); 
       Centroid_cell=struct2cell(Centroid);
        Centroid_double=cell2mat(Centroid_cell);   
         Centroid_double=reshape(Centroid_double,2,size(Centroid,1));


for i=1:size(Centroid_double,2);
     t(1,i)=Centroid_double(1,i);   

        l(1,i)=Centroid_double(2,i);
          Centroid_double(1,i)=l(1,i);
              Centroid_double(2,i)=t(1,i);
end


                 DOT=Centroid_double';



    yo=1 ;
     go=1;
     
while yo==1;
    
    
    while go==1;
        must_inequal=ceil(rand(1,num)*length(Centroid_cell));
       if must_inequal(1)~=must_inequal(2); 
           go=2;
       end;
       
    end
   
  Cent=Centroid_cell(must_inequal)                             ;
    Cent=cell2mat(Cent)                                         ; 
      Cent=reshape(Cent,2,num)                                   ;  
        Cent_minus=Cent(1,:)-Cent(2,:)                            ;  
          Cent_dist=sqrt(Cent_minus(1,1)^2+Cent_minus(1,2)^2)      ;  
          ;
if Cent_dist>=200 

    yo=2;
end
   
go=1;
end
%Cent=cell2mat(Cent)                                          
%Cent=reshape(Cent,2,num)                                     

for i=1:size(Cent,2)
t(1,i)=Cent(1,i);
  l(1,i)=Cent(2,i); 
    Cent(1,i)=l(1,i);
      Cent(2,i)=t(1,i);
end

Cent=Cent' ;

count_A=0,count_B=0, count_C=0,count_D=0,count_E=0 ; 
            
o=0,p=0,q=0,w=0,r=0 ;

                          
                          
loop=1               ;         
                         
while loop<=num_loop 
    
    a=[0 0]; 
    b=[0 0];
    c=[0 0];
    d=[0 0];
    e=[0 0];
     
    
    
       j=1
       while j<=size(Centroid,1) 
             i=1;
          while i<=num 
              
              dal(i,:)=DOT(j,:)-Cent(i,:) ;
               i=i+1;
               
           end
       
       
       m=1;
      while m<=num 
          
             
         distance(m,1)=sqrt(dal(m,1)^2+dal(m,2)^2)  ; 
        m=m+1;
          
      end
                
      
          minmum=min(distance); 
              special=find(distance==minmum); 
      
      
      
      if special==1        
          
          
            count_A=count_A+1         ; 
             a(count_A,1:2)=DOT(j,:)  ; 
               a_area(count_A,1)=Area_double(j,1); 
                 o=1                  ; 
                    end
      
      if special==2  
         
          count_B=count_B+1          ; 
            b(count_B,1:2)=DOT(j,:)   ;     
              b_area(count_B,1)=Area_double(j,1);
                 p=1                  ; 
       end
       
       if special==3 
           
          
          count_C=count_C+1           
           c(count_C,:)=DOT(j,:)       ;
            c(count_C,3)=Area_double(j,1);
             q=1                   ;
           
      end
       
       
       if special==4 
        
          count_D=count_D+1         ; 
             d(count_D,:)=DOT(j,:)   ;   
               w=1                   ;
       end
       
        if special==5  
       
           count_E=count_E+1          ;
               e(count_E,:)=DOT(j,:)   ;   
                 r=1                  ; 
        end
                   
          j=j+1;
       end
      





if isempty(o)==0   
     if size(a,1)>=2
         mean_A=mean(a);    
           end
     if size(a,1)==1
         mean_A=a;         
           end
end

if isempty(p)==0  
    if size(b,1)>=2
        mean_B=mean(b) ;   
                    end
    
    if size(b,1)==1
        mean_B=b;          
                    end
  
end
    
if isempty(q)==0  
    
    mean_C=mean(c) ;   
    
    
      end
        
if isempty(w)==0  
    
   mean_D=mean(d)   ; 
    
       end


if isempty(r)==0  
    
   mean_E=mean(e)    ;
    
end

sum=o+p+q+w+r   ;   


if sum==1      
   
    
    mean_mean=mean_A;
       
      end


if sum==2    

   mean_mean=cat(1,mean_A,mean_B);

     end

if sum==3   
    
    mean_mean=cat(1,mean_A,mean_B,mean_C);
     
     end

if sum==4   
   
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D)
    
     end

if sum==5   
    
    mean_mean=cat(1,mean_A,mean_B,mean_C,mean_D,mean_E)
    
     end
  


Cent=mean_mean ; 
count_A=0    ; 
count_B=0    ; 
count_C=0    ;         
count_D=0    ;
count_E=0    ;


if(loop<num_loop)
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
count_A=0     ;
count_B=0     ;
count_C=0      ;       
count_D=0    ;
count_E=0    ;


end



    

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

         
singleFrame = read(fallout,gundam); 


if sum==1||sum==2||sum==3||sum==4||sum==5 
A_centroid(1,:)=Cent(1,:); 

           
        
       g=0
           while g<size(a,1)
             g=g+1 ;
              A_dal(g,:)=a(g,:)-A_centroid(1,:); 
              A_distance(g,1)=sqrt(A_dal(g,1)^2+A_dal(g,2)^2);
           
           end
           
           
            A_delete=find(A_distance>=150);
            a_isolate(:,:)=a(A_delete,:) ;
            
            
              l=1 ;
               while l<size(a_isolate,1)
                  
                   
                    s=1 ;
                    while s<size(a,1)             
                      
                   A_isolate_dal(s,:)=a(s,:)-a_isolate(l,:)
                  A_isolate_distance(s,1)=sqrt(A_isolate_dal(s,1).^2+A_isolate_dal(s,2).^2)
                          s=s+1
                    end
                    
                    
                    
                   a_area_sum=a_area(find(A_isolate_distance<=150),1)
                   a_area_sum_real=0 
                    
                   of=1
                    while of<size(a_area_sum,1)
                        a_area_sum_real=a_area_sum(of,1)+ a_area_sum_real; 
                        of=of+1 ;

                    end
                    
                  Area_sum(l)=a_area_sum_real  ; 
                    if  a_area_sum_real<=4500   
                            a(A_delete(l,1),:)=[]; 
                            a_area(A_delete(l,1))=[];
                            A_dal(A_delete(l,1),:)=[];
                            A_distance(A_delete(l,1))=[];
                            A_delete(l:end,1)=A_delete(l:end,1)-1  ;
                            
                    end
                    
                    l=l+1;
                   
                    if l<size(a_isolate,1)
                   clear a_area_sum_real ; 
                   clear A_isolate_dal;
                   clear A_isolate_distance;
                  clear a_area_sum;
                  
                    end
                   
                      
                    end 
               
if isempty(a)==0         
a_sum=0 ;


as=1   ; 
while as<=size(a_area,1)

a_sum=a_area(as,1)+a_sum ;
as=as+1 ;

end
         
      if a_sum>=2000                 
              
        A_top=max(a(:,1)) ; %下
        A_down=min(a(:,1)); %上
        A_right=max(a(:,2));%右
        A_left =min(a(:,2));%左
        
    
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

    
    B_centroid(1,:)=Cent(2,:) ;

            t=0 ;
           while t<size(b,1) 
              
              t=t+1;
              B_dal(t,:)=b(t,:)-B_centroid(1,:) ;
              B_distance(t,1)=sqrt(B_dal(t,1)^2+B_dal(t,2)^2) ; 
              
           end
            
            B_delete=find(B_distance>=150);
            B_isolate(:,:)=b(B_delete,:) ;
               l=1 ;
              while l<size(B_isolate,1)
                 
                    u=1 ;
                   while u<size(b,1)
                      
                    B_isolate_dal(u,:)=b(u,:)-B_isolate(l,:); 
                     
                    B_isolate_distance(u,1)=sqrt(B_isolate_dal(u,1).^2+B_isolate_dal(u,2).^2)  ;
                  
                    u=u+1;
                    end
                    
                    
                    b_area_sum=b_area(find(B_isolate_distance<=150),1) ;
                    b_area_sum_real=0  ;
                    
                    og=1
                    while og<=size(b_area_sum,1)
                      
                       
            
                         b_area_sum_real=b_area_sum(og,1)+ b_area_sum_real ;
                         og=og+1  ;
                        
                    end
                   ; 
                       if  b_area_sum_real<=4500
                            
                           b(B_delete(l,1),:)=[] ; 
                           b_area(B_delete(l,1))=[]; 
                            B_dal(B_delete(l,1),:)=[]; 
                            B_distance(B_delete(l,1))=[] ; 
                           B_delete(l:end,1)=B_delete(l:end,1)-1  ;
                           
                       end
                       
                       l=l+1  ;
                       
                  ;    
                    if l<size(B_isolate,1)
                       clear B_isolate_dal    ;
                       clear B_isolate_distance    ;
                       clear b_area_sum   ;
                       clear b_area_sum_real
                       
                    end
              end

            
        

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
   ; %畫圖    
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
               
      % C_top=max(c(:,1))  ;%上下
      % C_down=min(c(:,1)) ;%上下
      % C_right=max(c(:,2));%左右
     %  C_left =min(c(:,2));%左右
   
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
               
               
      % D_top=max(d(:,1))  
     %  D_down=min(d(:,1)) 
      % D_right=max(d(:,2))
    %   D_left =min(d(:,2))
       
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
               
     %            E_top=max(e(:,1))  ;
    %             E_down=min(e(:,1)) ;
   %              E_right=max(e(:,2));
  %               E_left =min(e(:,2));
    
    
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
              
  

question(:,:,:,gundam) = singleFrame;
       
  
      
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
