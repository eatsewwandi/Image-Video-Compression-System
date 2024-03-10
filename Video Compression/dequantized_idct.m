function Out = dequantized_idct(constructed_image,jpeg)

    % The size of the input constructed image
    [h, w] = size(constructed_image);
    r = h/8;
    c = w/8;
    s = 1;
    
    for i=1:r
        e = 1;
        for j=1:c
            qc = constructed_image(s:s+7, e:e+7);
            
            % Dequantization
            DQ = jpeg .* qc;
            
            % Inverse DCT(Inverse Discrete Cosine Transform)
            idc = idct2(DQ);
                
            % Output matrix
            Out(s:s+7, e:e+7) = idc + 128;
                
            e = e + 8;
        end
        s = s + 8;
    end

end
