function img = combine_macroblocks(macro, row_img, col_img)
    img = cell2mat(macro);
    img = img(1:row_img, 1:col_img);
end
