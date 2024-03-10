function Q = quantized_dct(gray_image,jpeg)
   
    % The size of the grayscale image
    [h, w] = size(gray_image);
    r = h/8;
    c = w/8;
    s = 1;
    
    for i=1:r
        e = 1;
        for j=1:c
            
            % Divide grayscale image into 8x8 macroblocks
            macroblock = gray_image(s:s+7,e:e+7);
            
            % Convert the pixel values in the current macroblocks to double and centre them by subtracting 128(Halfway between the minimum and maximum possible pixel values in an 8-bit grayscale image)
            centre = double(macroblock) - 128;
            
            % DCT(Discrete Cosine Transform)
            dc = dct2(centre);
            
            % Quantization
            Q(s:s+7, e:e+7) = round(dc ./ jpeg);
        
            e = e + 8;
        end
        s = s + 8;
    end

end