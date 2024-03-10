%%% Image Coding %%%

clear all;
clc;
%% Source image data

original_image = imread('Lenna_(test_image).png');
% figure, 
% imshow(original_image);
% title('Original Image');

gray_image = rgb2gray(original_image);
% figure
% imshow(gray_image);
% title('Gray Image');

% The size of the grayscale image
[h, w] = size(gray_image);
r = h/8;
c = w/8;

% Set the target bit rate (in kbps)
% E/17/326 -> 326 + 300 = 626 kbps
target_bit_rate = 626;

%% Apply DCT & quantization

% Set the multiplication factor to achieve the desired bit rate
% mf = (target_bit_rate * 1000) / (8 * numel(gray_image));

% Multiplication factor
mf = 1;
% Standard quantization matrix used in JPEG compression
base_matrix = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
% Quantization matrix
quant = mf * base_matrix;

% Call the quantized_dct function
Q = quantized_dct(gray_image,quant);

quantized_image = uint8(Q);
% figure;
% imshow(quantized_image);
%title('Quantized Image');

%% Entropy encoding

% The intensity values of the compressed image 
[g,~,intensity_val] = grp2idx(Q(:));
% The frequency of occurrence for each intensity value
frequency = accumarray(g,1);
% The probabilities of each intensity value
probability = frequency./(h*w); 
% T = table(intensity_val,frequency,probability);
% Create the Huffman codebook
code = huffmandict(intensity_val,probability);
% Encode the compressed image 
encode = huffmanenco(Q(:),code);

% Calculate the actual bit rate
actual_bit_rate = numel(encode) / numel(gray_image) * 8;

% Calculate the compression ratio
compression_ratio = (h * w * 8) / numel(encode);
    
%% Store compressed image data

% The encoded image is saved to a text file
text1 = 'encode.txt';
% Read the text file and the encoded bits are converted to a numerical array
fid = fopen(text1,'w');
fprintf(fid,num2str(encode));
fclose(fid);

f = fopen(text1); % Open the text file
data = textscan(f,'%s');% Read the contents of the text file
fclose(f);% Close the text file
bits = char(data{:});% Convert the cell array of strings into a character array

test = [];
len = size(encode);
for q = 1:len(1)
    test(q) = bits(q)-48; % Convert character into numerical value by subtracting 48 from ASCII value
end

%% Entropy decoding

% The numerical array is passed to 'huffmandeco'along with the Huffman codebook to decode the image
decode = huffmandeco(test',code);
% The decoded image is reshaped
image1 = reshape(decode,h,w);

%% Apply dequantization & IDCT

% Call the dequantized_idct function
image2 = dequantized_idct(image1,quant);

%% Reconstructed image data

reconstructed_image = uint8(image2);

% Calculate PSNR value
psnr_val = psnr(reconstructed_image, gray_image);

% figure;
% imshow(reconstructed_image);
%title('Output Image');
imwrite(gray_image, 'input.jpg');
imwrite(quantized_image, 'quantized image.jpg');
imwrite(uint8(image2), 'output.jpg');
