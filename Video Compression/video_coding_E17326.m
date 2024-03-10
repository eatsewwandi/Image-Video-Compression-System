%%% Video Coding %%%

clear all;
clc;

%% Read the original video file and extract 30 frames (1s duration) from the video

video = VideoReader('squirrel.mp4');    % Read the video file
num_frames = 30;    % Number of frames to extract 

% Read and save the specified number of frames from the video
for frame_count = 1:num_frames
     frame_file = strcat('frame',num2str(frame_count),'.jpg'); % Save the frame as a JPG image 
     frame = read(video, frame_count);   % Read the next frame
     gray_frame = rgb2gray(frame);  % Convert the frame to grayscale
     rs_frame = imresize(gray_frame, [720,1280]); % Resize the image 
     imwrite(rs_frame, frame_file); % Save frames
end

% Frame height and width
[rows , cols] = size(rs_frame); 

% Save frame names
for i = 1 : num_frames
   frame_names{1,i} = strcat('frame',num2str(i),'.jpg'); 
end

% Save frame matrices
for j = 1 : num_frames
   frames{1,j} = imread(frame_names{1,j}); 
end

%% Rewrite the original video using extracted frames

original_vid = VideoWriter('original.mp4');
original_vid.FrameRate = video.FrameRate;
open(original_vid);
for j = 1:num_frames
    frame_count = uint8(frames{1,j});
    writeVideo(original_vid,frame_count);
end
% Close the original video file
close(original_vid);

%% Padding

% The padding technique is used to ensure that frames can be divided into 8x8 macroblocks without any remainder
for p = 1 : num_frames
    padd_frames{1,p} = padding(frames{1,p},8);
end

[r,c] = size(padd_frames{1,1});

%% Divide padded image into 8x8 macroblocks

for num = 1:num_frames
    macro{1,num} = divide_into_macroblocks(padd_frames{1,num});
end

%% Motion estimation -> Motion vector calculation

[predict, motion_vec] = motion_vectors(macro);

%% Motion compensation -> Predicted frames

for i = 1:num_frames-1
    predict_img = combine_macroblocks(predict{1,i} ,rows , cols );
    predicted_frames{1,i}= predict_img;
%   frame_file = strcat('predicted_frame',num2str(i+1),'.jpg');
%   imwrite(predict_img, frame_file); 
end


%% Quantization

% Standard quantization matrix used in JPEG compression
quant = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
   
%% Apply image compression algorithm to referance frame (I frame)

ref_frame = frames{1,1};
Q = quantized_dct(ref_frame,quant); % Call quantized_dct function
quan{1,1} = Q;
I_frame = dequantized_idct(Q,quant);    % Call dequantized_idct function
reconstructed_img{1,1} = I_frame;


%% Apply run length encoding for I frame

matrix = quan{1,1};
B = matrix';
C = reshape(B,1,[]);
D = runlength_encode(C);    % Call runlength_encode function
rl_array_I{1,1} = D;

%% Residual calculation -> Current macroblock - Predicted macroblock

for i = 1:num_frames-1
    residual_img{1,i} = double(frames{1,i+1}) - double(predicted_frames{1,i});
%   frame_file = strcat('residual', num2str(i+1), '.jpg');
%   imwrite(uint8(residual_img), frame_file);
end

%% Apply DCT and quantization for each residual image

for i = 1: num_frames-1
    Q = quantized_dct(residual_img{1,i},quant);  % Call quantized_dct function
    encoded{1,i} = Q;
end

%% Apply run length encoding for each residual image

for i = 1:num_frames-1
   matrix = encoded{1,i};
   B = matrix';
   C = reshape(B,1,[]);
   D = runlength_encode(C); % Call runlength_encode function
   rl_array{i,1} = D;
end

%% Apply run length decoding for each residual image

for i = 1:num_frames-1
   D = runlength_decode(rl_array{i,1}); % Call runlength_decode function
   A = reshape(D,cols,rows)';
   rl_decode_array{1,i} = A;
end

%% Apply inverse DCT and dequantization for each residual image

for i = 1: num_frames-1
    Q1 = dequantized_idct(double(rl_decode_array{1,i}),quant);  % Call dequantized_idct function
    inv_DFT{1,i} = Q1;
end

%% Reconstructed frames

for i = 1: num_frames-1
    reconstructed_img{1,i+1} = double(inv_DFT{1,i})+ double(predicted_frames{1,i});
end

% Save reconstructed frames as JPG images
for i = 1:num_frames
 frame_file = strcat('reconstructed_frame',num2str(i),'.jpg');
 frame = uint8(reconstructed_img{1,i});
 imwrite(frame,frame_file);
end


%% Save the reconstructed video

reconstructed_vid = VideoWriter('reconstructed video.mp4');
reconstructed_vid.FrameRate = video.FrameRate;
open(reconstructed_vid);
for j = 1:num_frames
 fram_num = uint8(reconstructed_img{1,j});
 writeVideo(reconstructed_vid,fram_num);
end
% Close the compressed video file
close(reconstructed_vid);


%% Save the output as text file
text1 = fopen('reconstructed video.txt','w');
fprintf(text1, num2str(rl_array_I{1,1}));
fprintf(text1,',');


for i = 1 : num_frames-1
 fprintf(text1, num2str(rl_array{i,1}));
 fprintf(text1,',');
end
fclose(text1);
