function w = tukeys_biweight(w, c)

for i=1:length(w)
    if (abs(w(i)) < c)
        w(i) = (c^2)/6*(1-(1-(w(i)/c)^2)^3);
    else
        w(i) = (c^2)/6;
    end
end
    