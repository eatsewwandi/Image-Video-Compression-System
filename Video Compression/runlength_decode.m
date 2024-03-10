function decoded_data = runlength_decode(encoded_data)
    % Initialize variables
    count_values = [];
    symbol_values = [];
    decoded_data = [];
    
    for i = 1:2:length(encoded_data)
        count_values = [count_values encoded_data(i)];
    end

    for i = 2:2:length(encoded_data)
        symbol_values = [symbol_values encoded_data(i)];
    end

    for i = 1:length(count_values)
        count = count_values(i);
        symbol = symbol_values(i);
        for j = 1:count
            decoded_data = [decoded_data symbol];
        end
    end
end