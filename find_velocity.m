function [Vt, VL, VR] = find_velocity(t, L, R)
i = 1;
j = 1;
%zero out data)
t = t - t(i);
L = L - L(i);
R = R - R(i);

while i < length(t)
    if i+1 <= length(t)
        vl(i) = (L(i+1) - L(i)) / (t(i+1) - t(i));
        vr(i) = (R(i+1) - R(i)) / (t(i+1) - t(i));
    end
    i = i+1;
end
while j <= 62
    if vl(j) > 0 
        t(j) = t(j);
        vl(j) = vl(j);
        vr(j) = vr(j);
        j = j+1;
    else 
        t = t(j+1:length(t));
        vl = vl(j+1:length(vl));
        vr = vr(j+1:length(vr));
    end
end  
Vt = t(1:length(vl))';
VL = vl;
VR = vr;
end