p = mfilename('fullpath');
p=strrep(p,'Run_Gui','');
cd(p)
clear p

javaaddpath('20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
javaaddpath('20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
javaaddpath('20130227_xlwrite/poi_library/dom4j-1.6.1.jar');

if exist('data') ~= 1
    data = bfopen;
    
    dimensions = dimensionchange(data);
    
end

imageanalysisui(data,dimensions)

