function MAR_tmsrtest
    for r=2:6
        [a,m] = readfile(['/home/s1423313/Documents/Sense_EDI/Svalbard/Regions/Region_Masks/07_rgi60_Svalbard_corr_marine_R',num2str(r),'.tif']);
        time=[];
        x=0;
        SMB_tmsr = zeros(6939,1);
        RF_tmsr = zeros(6939,1);
        SF_tmsr = zeros(6939,1);
        SH_tmsr = zeros(6939,1);
        RU_tmsr = zeros(6939,1);
        SU_tmsr = zeros(6939,1);
        ME_tmsr = zeros(6939,1);
        for i=0:18
            file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+i+1),'.nc']
            SMB = ncread(file,'smb');
            %RF = ncread(file,'rf');
            %SF = ncread(file,'sf');
            %RU = ncread(file,'ru');
            %SU = ncread(file,'su');
            %SH = ncread(file,'sh');
            %ME = ncread(file,'me');
            t= ncread(file,'time');
            i
            time=[time ;t];
            for j=1:length(t)
                x=x+1;
                smb = SMB(:,:,j);
                %rf = RF(:,:,j);
                %sf = SF(:,:,j);
                %sh = SH(:,:,j);
                %ru = RU(:,:,j);
                %su = SU(:,:,j);
                %me = ME(:,:,j);
                SMB_tmsr(x)= mean(smb(m.data==1));
                %RF_tmsr(x)= mean(rf(m.data==1));
                %SF_tmsr(x)= mean(sf(m.data==1));
                %SH_tmsr(x)= mean(sh(m.data==1));
                %RU_tmsr(x)= mean(ru(m.data==1));
                %SU_tmsr(x)= mean(su(m.data==1));
                %ME_tmsr(x)= mean(me(m.data==1));
            end

        end
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Svalbard_MR',num2str(r),'.nc'];
        nt = length(time)
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        %nccreate(file,'sf_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        %nccreate(file,'ru_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        %nccreate(file,'su_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        %nccreate(file,'sh_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        %nccreate(file,'me_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        
        ncwrite(file,'smb_mean',SMB_tmsr);
        ncwrite(file,'rf_mean',RF_tmsr);
        ncwrite(file,'ru_mean',RU_tmsr);
        ncwrite(file,'su_mean',SU_tmsr);
        ncwrite(file,'me_mean',ME_tmsr);
        ncwrite(file,'sf_mean',SF_tmsr);
        ncwrite(file,'sh_mean',SH_tmsr);
        ncwrite(file,'time',time);
    end
 end

   
     