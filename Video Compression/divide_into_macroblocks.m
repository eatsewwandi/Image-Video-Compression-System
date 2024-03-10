function macro = divide_into_macroblocks(frame)
        [r,c] = size(frame);

        s = 1;
        for i =1:r/8
            e = 1;
            for j=1:c/8
                  macro{i,j} = frame(s:s+7,e:e+7);
                  e = e + 8;
            end
              s = s + 8;
        end
end