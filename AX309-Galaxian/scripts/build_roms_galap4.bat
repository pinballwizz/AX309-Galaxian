@echo off

REM SHA1 sums of files required
REM xxxx *galx_4c1.rom
REM xxxx *galx_4c2.rom
REM f382ad5a34d282056c78a5ec00c30ec43772bae2 *6l.bpr
REM xxxx *galnamco.u
REM xxxx *galnamco.v
REM xxxx *galnamco.w
REM xxxx *galnamco.y
REM xxxx *galnamco.z

set rom_path_src=..\roms\galap4
set rom_path=..\build
set romgen_path=..\romgen_source

REM concatenate consecutive ROM regions
copy /b/y %rom_path_src%\galx_4c1.rom + %rom_path_src%\galx_4c2.rom %rom_path%\gfx1.bin > NUL
copy /b/y %rom_path_src%\galnamco.u + %rom_path_src%\galnamco.v + %rom_path_src%\galnamco.w + %rom_path_src%\galnamco.y + %rom_path_src%\galnamco.z %rom_path%\main.bin > NUL

REM generate RTL code for small PROMS
REM %romgen_path%\romgen %rom_path_src%\6l.bpr    GALAXIAN_6L  5 c     > %rom_path%\galaxian_6l.vhd
%romgen_path%\romgen %rom_path_src%\6l.bpr    GALAXIAN_6L  5 l r e     > %rom_path%\galaxian_6l.vhd

REM generate RAMB structures for larger ROMS
%romgen_path%\romgen %rom_path%\gfx1.bin        GFX1      12 l r e > %rom_path%\gfx1.vhd
%romgen_path%\romgen %rom_path%\main.bin        ROM_PGM_0 14 l r e > %rom_path%\rom0.vhd

%romgen_path%\romgen %rom_path_src%\galx_4c1.rom    GALAXIAN_1H 11 l r e > %rom_path%\galaxian_1h.vhd
%romgen_path%\romgen %rom_path_src%\galx_4c2.rom    GALAXIAN_1K 11 l r e > %rom_path%\galaxian_1k.vhd

REM %romgen_path%\romgen %rom_path_src%\mc_wav_2.bin GALAXIAN_WAV 18 l r e > %rom_path%\galaxian_wav.vhd

echo done
pause
