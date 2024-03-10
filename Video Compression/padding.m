function frame1 = padding(frame,N)
    if N > 0
      frame(end+2*N,end+2*N) = 0 ;
      frame1 = frame([end-N+1:end 1:end-N], [end-N+1:end 1:end-N]) ;
    end
end