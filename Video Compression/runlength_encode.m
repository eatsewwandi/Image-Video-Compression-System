function encoded_data = runlength_encode(quant_matrix)
    % Initialize variables
    encoded_data = [];
    count = 1;
    for i = 1:length(quant_matrix)-1
        % If an item is repeated, increase the count
        if(quant_matrix(i)== quant_matrix(i+1))
            count = count+1;
        else
            encoded_data = [encoded_data,count,quant_matrix(i),];
        count = 1;  % Reset count
        end
    end
    % Encode the last count and the item
    encoded_data = [encoded_data,count,quant_matrix(length(quant_matrix))];
end