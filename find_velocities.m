function [VT, LV, AV] = find_velocities(t, L, R)
LV = (L+R)./2;
AV = R-L./.235;
VT = t(1:length(LV));
end