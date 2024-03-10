function [predict, motion_vec] = motion_vectors(macro)
    num_frames = numel(macro);
    predict = cell(1, num_frames-1);
    motion_vec = cell(1, num_frames-1);
    
    for g = 2:num_frames
        frame_now = macro{1,g};
        frame_prev = macro{1,g-1};
        r = size(frame_now, 1) * 8;
        c = size(frame_now, 2) * 8;
        pred = cell(r/8-2, c/8-2);
        mv = cell(r/8-2, c/8-2);
        
        for p = 2:(r/8-1)
            for q = 2:(c/8-1)
                macro_now = frame_now{p,q};
                best_error = Inf;
                best_pred = [];
                best_mv = [];
                
                for a = (p-1:p+1)
                    for b = (q-1:q+1)
                        macro_prev = frame_prev{a,b};
                        SAD = sum(abs(macro_now(:) - macro_prev(:)));
                        
                        if SAD < best_error
                            best_error = SAD;
                            best_pred = macro_prev;
                            best_mv = [a,b];
                        end
                    end
                end
                
                pred{p-1,q-1} = best_pred;
                mv{p-1,q-1} = best_mv;
            end
        end
        
        predict{g-1} = pred;
        motion_vec{g-1} = mv;
    end
end