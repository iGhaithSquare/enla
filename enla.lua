    function init(plugin)
        if plugin.preferences.last_output_path == nil then
            plugin.preferences.last_output_path = ""
        end
        plugin:newCommand{
            id="enla",
            title="Export Nes-Like Assembly",
            group="file_export",
            onenabled=function()
                return app.activeSprite~=nil and app.activeCel~=nil
            end,
            onclick=function()
                local dlg = Dialog("ENLA")
                dlg
                    :file{
                        id="output_dir",
                        label="Output Directory",
                        title="Output Directory",
                        filename=plugin.preferences.last_output_path,
                        entry=true,
                        open=true,
                        save=false
                    }
                    :separator{}
                    :button{
                        text="Export",
                        onclick=function()
                            local sprite=app.activeSprite
                            local export_dir=dlg.data.output_dir
                            plugin.preferences.last_output_path=export_dir
                            if export_dir=="" then
                                export_dir=sprite.filename
                            end
                            local cel=app.activeCel
                            local img=cel.image
                            local pal=sprite.palettes[1]
                            if sprite.width%8~=0 or sprite.height%8~=0 then
                                app.alert("Tilemap should be made of 8 by 8 sprites (width and height should be multiple of 8)")
                                return
                            end
                            local f=io.open(string.format("%s.inc",export_dir),"w")
                            if not f then
                                app.alert("Couldnt open output file.")
                                return 
                            end
                            f:write(string.format("%s:\n",app.fs.fileTitle(sprite.filename)))
                            f:write("\n; Palette 0")
                            for i=1,3 do
                                local c=pal:getColor(i)
                                if c then
                                    local col = (c.red)|(c.green<<8)|(c.blue<<16)|(c.alpha<<24)
                                    f:write(string.format("\ndd\t0x%08X",col))
                                else
                                    f:write("\ndd\t0")
                                end
                            end
                            for i=1,3 do
                                f:write(string.format("\n; Palette %d",i))
                                for j=1,3 do
                                    f:write("\ndd\t0")
                                end
                            end
                            f:write("\n\n;Sprites")
                            local tilewidth=sprite.width/8
                            local tileheight=sprite.height/8
                            for ty=0,tileheight-1 do
                                for tx=0,tilewidth-1 do
                                    f:write("\ndb\t")
                                    local first=true
                                    for y=0,6,2 do
                                        for x=0,6,2 do
                                            local py=ty*8+y
                                            local px=tx*8+x
                                            local a=img:getPixel(px,py)
                                            local b=img:getPixel(px+1,py)
                                            local c=img:getPixel(px,py+1)
                                            local d=img:getPixel(px+1,py+1)
                                            local byte = a|(b<<2)|(c<<4)|(d<<6)
                                            if not first then
                                                f:write(",")
                                            end
                                            first=false
                                            f:write(string.format("0x%02X",byte))
                                        end
                                    end
                                    f:write(string.format("\t;Sprite: %d,%d",tx,ty))
                                end
                            end
                            f:close()
                            dlg:close()
                            app.alert("Exporting done!") 
                        end       
                    }
                dlg:show()
            end
        }
    end