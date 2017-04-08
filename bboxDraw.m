%make video
limit = 200;
ext = '.jpg';


images = cell(limit,1);



for i  = 1:limit
    img = sprintf('%05d',i);
    name = strcat(num2str(img),ext);
    images{i} = imread(name);
end

% create the video writer with 1 fps
 writerObj = VideoWriter('NUSdata.avi');
 writerObj.FrameRate = 30;
 
 % set the seconds per image
 secsPerImage =  1;
 % open the video writer
 open(writerObj);
 % write the frames to the video
 for u=1:length(images)
     % convert the image to a frame
     frame = im2frame(images{u});
     for v=1:secsPerImage
         writeVideo(writerObj, frame);
     end
 end
 % close the writer object
 close(writerObj);
    
    
    
