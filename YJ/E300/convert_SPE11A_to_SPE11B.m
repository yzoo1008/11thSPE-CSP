clc; clear; close all;
rt_fld = 'H:\11thSPE-CSP\YJ\E300';
cd(rt_fld);
%% MRST Settingsc
deck = readEclipseDeck(fullfile(rt_fld, 'SPE11A\SPE11A.DATA'));
deck = convertDeckUnits(deck);

G = initEclipseGrid(deck);

G.nodes.coords(:, 1) = G.nodes.coords(:, 1) * 3000;
G.nodes.coords(:, 2) = G.nodes.coords(:, 2) * 1000;
G.nodes.coords(:, 3) = G.nodes.coords(:, 3) * 1000;

G = mcomputeGeometry(G);
rock  = initEclipseRock(deck);

G.cells.inv_indexMap = sparse( ...
    double(G.cells.indexMap), ...
    ones(G.cells.num,1), ...
    transpose(1:G.cells.num), ...
    prod(G.cartDims), ...
    1 ...
    );
G.cells.ijk = cell(3, 1);
[G.cells.ijk{1:3}] = ind2sub(G.cartDims, G.cells.indexMap);
G.cells.ijk = [G.cells.ijk{:}];

figure;
[i, j, k] = ind2sub(G.cartDims, 1:G.cells.num);
plotCellData(G, deck.GRID.PERMX * meter^2 / (milli * darcy), 'FaceAlpha', 0.5, 'EdgeAlpha', 0.3)
view(0, 0)
daspect([1 1 1])
grid on; box on; 
colormap jet;
set(gca,'ColorScale','log')
colorbar;
axis tight;
%% Change Properties
rock_SPE11B = rock;
rock_SPE11B.poro(rock.regions.saturation == 1) = 0.1;
rock_SPE11B.poro(rock.regions.saturation == 2) = 0.2;
rock_SPE11B.poro(rock.regions.saturation == 3) = 0.2;
rock_SPE11B.poro(rock.regions.saturation == 4) = 0.2;
rock_SPE11B.poro(rock.regions.saturation == 5) = 0.25;
rock_SPE11B.poro(rock.regions.saturation == 6) = 0.35;
rock_SPE11B.poro(rock.regions.saturation == 7) = 0;

rock_SPE11B.perm(rock.regions.saturation == 1, 1:2) = 1.0*10^-16;
rock_SPE11B.perm(rock.regions.saturation == 1, 3) = 1.0*10^-16 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 2, 1:2) = 1.0*10^-13;
rock_SPE11B.perm(rock.regions.saturation == 2, 3) = 1.0*10^-13 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 3, 1:2) = 2.0*10^-13;
rock_SPE11B.perm(rock.regions.saturation == 3, 3) = 2.0*10^-13 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 4, 1:2) = 5.0*10^-13;
rock_SPE11B.perm(rock.regions.saturation == 4, 3) = 5.0*10^-13 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 5, 1:2) = 1.0*10^-13;
rock_SPE11B.perm(rock.regions.saturation == 5, 3) = 1.0*10^-13 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 6, 1:2) = 2.0*10^-12;
rock_SPE11B.perm(rock.regions.saturation == 6, 3) = 2.0*10^-12 * 0.1;
rock_SPE11B.perm(rock.regions.saturation == 7, 1:2) = 0;
rock_SPE11B.perm(rock.regions.saturation == 7, 3) = 0;

grdecl.PORO = rock_SPE11B.poro;
grdecl.PERMX = rock_SPE11B.perm(:,1)/(milli * darcy);
grdecl.PERMY = rock_SPE11B.perm(:,2)/(milli * darcy);
grdecl.PERMZ = rock_SPE11B.perm(:,3)/(milli * darcy);
writeGRDECL(grdecl, './SPE11B_PROPS.GRDECL')
%%
clearvars grdecl
GRDECL = readGRDECL(fullfile(rt_fld, 'SPE11A\SPE11A.DATA'));

X_idx = 1:3:3372;
Y_idx = 2:3:3372;
Z_idx = 3:3:3372;
GRDECL.COORD(X_idx) = GRDECL.COORD(X_idx) * 3000;
GRDECL.COORD(Y_idx) = GRDECL.COORD(Y_idx) * 1000;
GRDECL.COORD(Z_idx) = GRDECL.COORD(Z_idx) * 1000;

grdecl.COORD = GRDECL.COORD;
grdecl.ZCORN = GRDECL.ZCORN*1000;
grdecl.ACTNUM = GRDECL.ACTNUM;
writeGRDECL(grdecl, './SPE11B_GRID.GRDECL')
%%
clearvars grdecl
GRDECL = readGRDECL(fullfile(rt_fld, 'SPE11A\SPE11A.DATA'));
grdecl.SATNUM = GRDECL.SATNUM;
writeGRDECL(grdecl, './SPE11B_SATNUM.GRDECL')