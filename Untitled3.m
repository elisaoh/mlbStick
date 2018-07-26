 range_min = [100,500,1000];
 range_max = [1500,3500,4500];
        for c = 1:length(formants)
      
            if range_min(1)<formants(c)<range_max(1)
                formants_all(i,f) = formants(c);
            else
                formants_all(i,f) = formants_all(i-1,f);
            end
     
        end