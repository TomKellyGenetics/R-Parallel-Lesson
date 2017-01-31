#! \bin\bash

echo "arguments passed to bash"
echo $@
echo "1st argument"
echo $1 "cores"
echo "remaining arguments"
echo "${@:2}" "samples"

for ii in ${@:2}
    do
    Rscript loop_script_Rstudio_generic.R $1 $ii
    done