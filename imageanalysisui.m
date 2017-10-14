function imageanalysisui(nd_file)
%%%accepts an input of a bfopen file and opens a gui to quantify various
%%%aspects
close all
screendim=get(0,'screensize');
figsize=[screendim(3)*0.8 screendim(4)*0.8];
screenpos=[screendim(3)*0.1 screendim(4)*0.1];
pts=0;
pix_size=0.105;
figure
set(gcf,'Position',[screenpos figsize])
cyan = [0.152941176470588 0.658823529411765 0.878431372549020];
orange =  [0.956862745098039,0.498039215686275,0.215686274509804];

%%%sets position and size of figure adjusted to monitor settings

metadata=nd_file{1,4};
xdim = metadata.getPixelsSizeX(0).getValue(); % image width, pixels
ydim = metadata.getPixelsSizeY(0).getValue(); % image height, pixels
num_z = metadata.getPixelsSizeZ(0).getValue(); % number of Z slices
num_c = metadata.getPixelsSizeC(0).getValue(); % number of wavelengths
num_t = metadata.getPixelsSizeT(0).getValue(); % number of timepoints
num_p = metadata.getImageCount(); %number of stage positions

%%%Pulls metadata from OME format. useful because it does not change
%%%between file formats and acquisition programs




dimensions=[num_c num_z num_p];

pixeldim=[ydim xdim];

alldim=[pixeldim dimensions];

megastack=zeros(alldim);
 

for i=1:num_p
    if num_c < 4
        for j=1:num_c
            for q=1:num_z
                megastack(:,:,j,q,i)=nd_file{i,1}{q+(j-1)*num_z};
                %disp(q+(j-1)*num_z)
            end
        end
    else
        colors= [1 2 3 4];
        drop=input('Too many colors! Please chose which channel to drop (1-4) ');
        colors(colors==drop)=[];
        for j=1:num_c
            for q=1:num_z
                megastack(:,:,j,q,i)=nd_file{i,1}{q+(colors(j)-1)*num_z};
            end
        end
    end
end



%builds one gigantic stack to pull data from: X x Y x C x Z x P

displayimage=megastack(:,:,1:num_c,1,1);

imageToDisplay=getMulticolorImageforUI(displayimage,num_c);

%builds a single RGB stack (X x Y x 3) for display

img=imagesc(imageToDisplay(:,:,1));
imAX=img.Parent;
imageposition=[.2 .2 .75 .7];
imAX.Position=imageposition;



%set(gca,'XTick','none')
%gca.XTickLabel='none';
%%%
zsliderpos=[figsize(1)*.2 figsize(2)*.05 figsize(1)*.75 figsize(2)*.025];

if num_z>1
    z = uicontrol('Style', 'slider',...
            'Min',1,'Max',num_z,'Value',1,...
            'Position', zsliderpos,...
            'SliderStep', [1, 1] / (num_z - 1),...
            'Callback', {@getsliderpos,pts});
else
    z.Value=1;
end




psliderpos=[figsize(1)*.2 figsize(2)*.1 figsize(1)*.75 figsize(2)*.025];

if num_p>1
    p = uicontrol('Style', 'slider',...
            'Min',1,'Max',num_p,'Value',1,...
            'Position', psliderpos,...
            'SliderStep', [1, 1] / (num_p - 1),...
            'Callback', {@getppos,pts});
else
        p.Value=1;
end
    
kpairbuttonpos=[figsize(1)*.05 figsize(2)*.9 figsize(1)*.1 figsize(2)*.025];
   
kpair = uicontrol('Style', 'pushbutton', 'String', 'Mark pairs',...
        'Position', kpairbuttonpos,...
        'Callback', {@setptstopairs,pts,pix_size});       

    %sets the callback function on the image to be "MarkKPairs"
    
savepairbuttonpos=[figsize(1)*.05 figsize(2)*.85 figsize(1)*.1 figsize(2)*.025];
   
savepair = uicontrol('Style', 'pushbutton', 'String', 'Save pair data',...
        'Position',savepairbuttonpos,...
        'Callback', {@savepairs,pts,pix_size});       

    %installs the button used to save pair data
    
openpairbuttonpos=[figsize(1)*.05 figsize(2)*.8 figsize(1)*.1 figsize(2)*.025];
   
openpair = uicontrol('Style', 'pushbutton', 'String', 'Open pair data',...
        'Position',openpairbuttonpos,...
        'Callback', {@openpairs,pix_size});
    %intalls the button to open pair data
   
   
    function ppos=getppos(source,event,pts)
        val=round(source.Value);
        h=findobj(gca,'Type','hggroup');
        delete(h);
        img.CData=getMulticolorImageforUI(megastack(:,:,1:num_c,z.Value,val),num_c);
        ppos=val;
        if isstruct(pts) == 1
            if pts(val).num_kin ~= 0
                K1check=find(pts(val).K1coord(:,3)==z.Value);
                K2check=find(pts(val).K2coord(:,3)==z.Value);
                if isempty(K1check) == 0
                    h=viscircles(pts(val).K1coord(K1check,1:2),4*ones(1,length(K1check)),'LineWidth',0.25);
                    h.Children(1).Color=cyan;
                end
                if isempty(K2check) == 0
                    h=viscircles(pts(val).K2coord(K2check,1:2),4*ones(1,length(K2check)),'LineWidth',0.25);
                    h.Children(1).Color=orange;
                end
            end
        end
        %Redraws circles if they have been tracked using the Kpair tracker
    end

%function that changes the stage position using the slider while maintaining the
%z position

    function zpos=getsliderpos(source,event,pts)
        val=round(source.Value);
        h=findobj(gca,'Type','hggroup');
        delete(h);
        img.CData=getMulticolorImageforUI(megastack(:,:,1:num_c,val,p.Value),num_c);
        zpos=val;
        if isstruct(pts) == 1
            if pts(p.Value).num_kin ~= 0
                K1check=find(pts(p.Value).K1coord(:,3)==val);
                K2check=find(pts(p.Value).K2coord(:,3)==val);
                if isempty(K1check) == 0
                    h=viscircles(pts(p.Value).K1coord(K1check,1:2),4*ones(1,length(K1check)),'LineWidth',0.25);
                    h.Children(1).Color=cyan;
                end
                if isempty(K2check) == 0
                    h=viscircles(pts(p.Value).K2coord(K2check,1:2),4*ones(1,length(K2check)),'LineWidth',0.25);
                    h.Children(1).Color=orange;
                end
            end
        end
        %Redraws circles if they have been tracked using the Kpair tracker
    end

%function that changes the zposition using the slider while maintaining the
%stage position

    function pts=setptstopairs(source, event,pts, pix_size)
       msgbox('You turned on The object pair marking option. Please click on an object, and then its complement (eg. a kinetochore and its sister). Please do not press this button again until you press the "Pairs Done" button.')
       
       for i=1:num_p
            s(i).num_kin=0;
            s(i).K1coord=[];
            s(i).K2coord=[];
            

       end
       pts=s;
       img.ButtonDownFcn={@MarkKPairs,pts, pix_size};
    end

%function that sets callback function on the image to be "MarkKPairs" and builds the struct "pts" that will hold all the data.

    function pts=MarkKPairs(source, eventdata,pts,pixsize)
        AX=source.Parent;
        coord = get(AX, 'CurrentPoint');
        coord = [coord(1,1) coord(1,2) z.Value];
        stgpos=p.Value;
        slcpos=z.Value;
        pts(stgpos).num_kin=pts(stgpos).num_kin+1;
        
        if rem(pts(stgpos).num_kin,2)==1
            pts(stgpos).K1coord = [pts(stgpos).K1coord; coord];
            h=viscircles(coord(1:2),4,'LineWidth',0.25);
            h.Children(1).Color=cyan;
            
        else
            pts(stgpos).K2coord = [pts(stgpos).K2coord; coord];
            h=viscircles(coord(1:2),4,'LineWidth',0.25);
            h.Children(1).Color=orange;
            
        end
        img.ButtonDownFcn={@MarkKPairs,pts};
        if num_z>1
            z = uicontrol('Style', 'slider',...
                'Min',1,'Max',num_z,'Value',z.Value,...
                'Position', zsliderpos,...
                'SliderStep', [1, 1] / (num_z - 1),...
                'Callback', {@getsliderpos,pts});
        end
        if num_p>1
            p = uicontrol('Style', 'slider',...
            'Min',1,'Max',num_p,'Value',p.Value,...
            'Position', psliderpos,...
            'SliderStep', [1, 1] / (num_p - 1),...
            'Callback', {@getppos,pts});
        end
        
        %Recalls all of the sliders to update the pts struct within them
        
        savepair = uicontrol('Style', 'pushbutton', 'String', 'Save pair data',...
        'Position',savepairbuttonpos,...
        'Callback', {@savepairs,pts,pix_size});  
    %updates the save function to save the newest data
        
    end

    function [pix_size]=savepairs(source, event, pts, pix_size)
        pix_size = WritePairDataToFile_ImAlGui( pts, pix_size );
        img.ButtonDownFcn={@MarkKPairs,pts, pix_size};
        savepair = uicontrol('Style', 'pushbutton', 'String', 'Save pair data',...
        'Position',savepairbuttonpos,...
        'Callback', {@savepairs,pts,pix_size}); 
    end

    function [pts]=openpairs(source,event,pix_size);
        check=questdlg('Proceeding will clear the currently tracked data on the UI. Continue?','Save data?','Yes','No','Yes');
        %makes sure you don't accidentally erase your progess on the figure
        if strcmp(check,'Yes')==1
            [ pts, data_matrix, column_labels ] = ReadPairDataFromFile_ImAlGui;
            %reads data from file. Might use the other inputs in a later
            %build.
            img.ButtonDownFcn={@MarkKPairs,pts, pix_size};
            savepair = uicontrol('Style', 'pushbutton', 'String', 'Save pair data',...
                'Position',savepairbuttonpos,...
                'Callback', {@savepairs,pts,pix_size});
            if num_z>1
                z = uicontrol('Style', 'slider',...
                    'Min',1,'Max',num_z,'Value',z.Value,...
                    'Position', zsliderpos,...
                    'SliderStep', [1, 1] / (num_z - 1),...
                    'Callback', {@getsliderpos,pts});
            end
            if num_p>1
                p = uicontrol('Style', 'slider',...
                    'Min',1,'Max',num_p,'Value',p.Value,...
                    'Position', psliderpos,...
                    'SliderStep', [1, 1] / (num_p - 1),...
                    'Callback', {@getppos,pts});
            end
        end
    end
            

if num_z>1
    ztextpos=[figsize(1)*.15 figsize(2)*.05 figsize(1)*.025 figsize(2)*.025];
    ztxt = uicontrol('Style','text',...
        'Position',ztextpos,...
        'String','z');
end
if num_p>1    
    ptextpos=[figsize(1)*.15 figsize(2)*.1 figsize(1)*.025 figsize(2)*.025];
    ptxt = uicontrol('Style','text',...
            'Position',ptextpos,...
            'String','p');
end    


end
    
    
% % % % % % % max_r=max(max(img.CData(:,:,1)));
% % % % % % % rsliderpos=[figsize(1)*.1 figsize(2)*.05 figsize(1)*.09 figsize(2)*.025];
% % % % % % % r = uicontrol('Style', 'slider',...
% % % % % % %         'Min',0,'Max',max_r,'Value',1,...
% % % % % % %         'Position', rsliderpos,...
% % % % % % %         'SliderStep', [.01, .01] / (max_r - 0),...
% % % % % % %         'Callback', @getRpos);
% % % % % % %     
% % % % % % %     function rlevel=getsliderpos(source,event)
% % % % % % %     val=round(source.Value);
% % % % % % %     img.CData=getMulticolorImageforUI(megastack(:,:,1:num_c,val,ppos),num_c);
% % % % % % %     zpos=val;
% % % % % % %     end
% % % % % % % 
