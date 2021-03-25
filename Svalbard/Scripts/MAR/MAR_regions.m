function MAR_regions(nR)
    time=[];
    lat= ncread(['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_2001.nc'],'lat')
    lon= ncread(['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_2001.nc'],'lon')
    x=0;
    for r=1:6
        [a,m] = readfile(['/home/s1423313/Documents/Svalbard/Regions/Region_Masks/07_rgi60_Svalbard_corr_land_R',num2str(nR),'.tif']);
    
        for i=0:1
            SMB = ncread(['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+i+1),'.nc'],'smb');
            RF = ncread(['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+i+1),'.nc'],'rf');
            t= ncread(['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+i+1),'.nc'],'time');
            time=[time ;t];
       
            for j=1:length(t)
                x=x+1;
                smb = SMB(:,:,j);
                SMB_r(:,:,x)= smb(m.data==1);
                rf = RF(:,:,j);
                RF_r(:,:,x)= rf(m.data==1);
                j
            end
            i
        end
    file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Svalbard_LR',num2str(r),'.nc'];

    nx = 487;
    nccreate(file,'lon','Dimensions',{'lon',1,nx},'DeflateLevel',7) ;
    ny = 430;
    nccreate(file,'lat','Dimensions',{'lat',1,ny},'DeflateLevel',7) ;
    nccreate(file,'smb_r','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
    nccreate(file,'rf_r','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;

    ncwrite(file,'lon',lon);
    ncwrite(file,'lat',lat);
    ncwrite(file,'smb_r',SMB_r);
    ncwrite(file,'rf_r',RF_r);
    end
    
 end