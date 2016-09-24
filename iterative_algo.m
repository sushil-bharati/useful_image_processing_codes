img1 = imread('sal_screenshot_24.09.2016.png'); %load an image
img_g = rgb2gray(img1); %convert to gray
[count] = imhist(img_g,256); %extract values from histogram
t_otsu = otsuthresh(count); %to compare with OTSU's threshold
t = round(mean(img_g(:)));
flag = true;  num_pix=0; m1_old = 0; m2_old =0;
while(flag)
    m1 = 0; m2 = 0;
    for i = 1:t
     m1 = m1 + count(i)*i;
     num_pix = num_pix + count(i);
    end
    mean1 = m1/num_pix;
    num_pix = 0;
    for j = t:256
         m2 = m2 + count(j)*j;
         num_pix = num_pix + count(j);
    end
    mean2 = m2/num_pix;
    num_pix = 0;
if (mean1==m1_old && mean2==m2_old) break; end
m1_old = mean1;
m2_old = mean2;
t = round((mean1 + mean2) / 2);
end
t = t/255;
fprintf('Ours -> %g\n Otsu -> %g\n',t,t_otsu);
img_thresh = imbinarize(img_g,t);
figure,
subplot(2,1,1),imshow(img1),title('Original image');
subplot(2,1,2),imshow(img_thresh),title('Thresholded Image');
