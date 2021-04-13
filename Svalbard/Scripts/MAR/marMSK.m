function marMSK(tifname)
%marMSK (root tif (eg RGI mask for Svalbard))--> masks MAR data --> .nc file
%outputing 
    %Creates mesh for the RGI mask
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    %creates lat and lon arrays to become coordinates in .nc (and to help with xarray in python)
    %lat and lon in MAR are 2-d grids this converts to 1-d.
    xstart = 10.7139;
    ystart = 80.4708;
    Nx = 487;
    Ny = 430;
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    %Read in MAR files, loop through all years and picks out the wanted
    %variables. To see full list ncdisp and or go to Timeseries notebook.
    for nj =1:19
        MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.2-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        smb = ncread(MARf, 'SMB');
        rf = ncread(MARf, 'RF');
        sf = ncread(MARf, 'SF');
        me = ncread(MARf, 'ME');
        sh = ncread(MARf, 'ZN6');
        su = ncread(MARf,'SU');
        ru = ncread(MARf,'RU');
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        t = ncread(MARf, 'TIME');
        nt = length(t);
        %Preallocation of memory, increases speed of loop.
        SMB = zeros(430,487,nt);
        RF = zeros(430,487,nt);
        SF = zeros(430,487,nt);
        ME = zeros(430,487,nt);
        SH = zeros(430,487,nt);
        SU = zeros(430,487,nt);
        RU = zeros(430,487,nt);
        
        for ni = 1:nt
            ni
            %project variable on to the mesh of RGI mask(tifname),
            %interpolating to RGI resolution
            SMB(:,:,ni) =griddata(double(mlon),double(mlat),smb(:,:,1,ni),double(xx),double(yy),'linear');
            RF(:,:,ni) = griddata(double(mlon),double(mlat),rf(:,:,ni),double(xx),double(yy),'linear'); 
            SF(:,:,ni) = griddata(double(mlon),double(mlat),sf(:,:,ni),double(xx),double(yy),'linear');
            ME(:,:,ni) = griddata(double(mlon),double(mlat),me(:,:,1,ni),double(xx),double(yy),'linear');
            SH(:,:,ni) = griddata(double(mlon),double(mlat),double(sh(:,:,1,ni)),double(xx),double(yy),'linear');
            SU(:,:,ni) = griddata(double(mlon),double(mlat),su(:,:,1,ni),double(xx),double(yy),'linear');
            RU(:,:,ni) = griddata(double(mlon),double(mlat),ru(:,:,1,ni),double(xx),double(yy),'linear');
        end
        nj
        %creating .nc file,dimensions and then writing variables in
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/test/Svalbard_',num2str(2000+nj),'.nc'];
        nx = 487;
        nccreate(file,'lon','Dimensions',{'lon',1,nx},'DeflateLevel',7) ;
        ny = 430;
        nccreate(file,'lat','Dimensions',{'lat',1,ny},'DeflateLevel',7) ;
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'rf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'su','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'me','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sh','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'ru','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        ncwrite(file,'sh',SH);
        ncwrite(file,'ru',RU);
        ncwrite(file,'su',SU);
        ncwrite(file,'sf',SF);
        ncwrite(file,'me',ME);
        ncwrite(file,'smb',SMB);
        ncwrite(file,'rf',RF);
        ncwrite(file,'time',t);
        ncwrite(file,'lon',lon);
        ncwrite(file,'lat',lat);
    end
end
