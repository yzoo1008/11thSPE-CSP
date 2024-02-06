clc; clear;
j = 99:-1:0;
v = j*50;
z = 0 + 150*(1-((v-2500)/2500).^2)+v/500;
z = max(z, [], 'all') - z;
%%
fid = fopen('./SPE11C_GRID_SIMPLE.GRDECL','w');
fprintf(fid, 'TOPS\n');
line = "";
for jdx = 1:100
    line = line + "280*" + num2str(z(jdx)) + " ";
    if mod(jdx, 10) == 0
        fprintf(fid, '%s\n', line);
        line = "";
    end
end
fprintf(fid, '/\n');

fprintf(fid, 'DX\n');
fprintf(fid, '3360000*30\n');
fprintf(fid, '/\n');

fprintf(fid, 'DY\n');
fprintf(fid, '3360000*50\n');
fprintf(fid, '/\n');

fprintf(fid, 'DZ\n');
fprintf(fid, '3360000*10\n');
fprintf(fid, '/\n');

fclose(fid);
%%
