clear all;
clc;

v = VideoReader('./TestVideos/CAM1-GOPR0333-21157.mp4');

duration = v.Duration;
height = v.Height;
width = v.Width;
rate = v.FrameRate;
format = v.VideoFormat;
bitsPerPixel = v.BitsPerPixel;

average = zeros(height, width, 3);
temp = average;
count = 1;

while hasFrame(v)
   video = readFrame(v);
   if count == 1
      average = video;
      count = count + 1;
   else
      temp = average;
      average = ((count-1)/count) * temp + (1/count) * video;
      count = count + 1;
   end
end

v = VideoReader('./TestVideos/CAM1-GOPR0333-21157.mp4');
numOfFrames = v.NumberOfFrames;

v = VideoReader('./TestVideos/CAM1-GOPR0333-21157.mp4');
firstFrame = read(v, 3);
firstExtract = firstFrame - average;
grayImage = rgb2gray(firstExtract);
grayImage = double(grayImage);
image_size = size(grayImage);
row = image_size(1);
col = image_size(2);
m = floor(row/7) - 1;
n = floor(row/7) - 1;
yIndex = 0;
xIndex = 0;
maxSum = 0;

for i = 1 : m
   for j = 1 : n
       sum = 0;
       for x = i * 7 - 6 : i * 7 + 6
          for y = j * 7 - 6 : j * 7 + 6
            sum = sum + grayImage(x, y);
          end
       end
       if sum > maxSum
          maxSum = sum;
          yIndex = i*7;
          xIndex = j*7;
       end
   end
end

xIndexes = zeros(1, numOfFrames);
yIndexes = zeros(1, numOfFrames);
xIndexes(1, 3) = xIndex;
yIndexes(1, 3) = yIndex;

for f = 4 : numOfFrames - 160
    currFrame = read(v, f);
    currExtract = currFrame - average;
    grayImage = rgb2gray(currExtract);
    grayImage = double(grayImage);
    maxSum = 0;
    hIndex = 0;
    vIndex = 0;

    for i = max([14, yIndex - 100]) : min([yIndex + 100, row])
       for j = max([14, xIndex - 100]) : min([xIndex + 100, col])
           sum = 0;
           for a = i - 13 : i
              for b = j - 13 : j
                  sum = sum + grayImage(a, b);
              end
           end
           if sum > maxSum
              maxSum = sum;
              hIndex = j - 6;
              vIndex = i - 6;
           end
       end
    end
    
    xIndexes(1, f) = hIndex;
    yIndexes(1, f) = vIndex;
    xIndex = hIndex;
    yIndex = vIndex;
end