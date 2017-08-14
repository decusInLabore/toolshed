###############################################################################
## Function: (32) createSRAdownloadScript()                                       ##
createSRAdownloadScript <- function(
    sra.id.vector = "SRP014185",
    module.load.cmd = "module use /camp/stp/babs/working/software/modules/all;module load sratoolkit/2.8.2-1",
    fastqDir = "path/to/fastq/dir"
){
    sink(paste0(sra.id.vector, ".sra.download.instructions.sh"))
    cat("#!/bin/sh"); cat('\n');
    cat("## Change into download directory ##"); cat('\n');
    cat(paste0("cd ", fastqDir)); cat("\n");
    cat(module.load.cmd); cat('\n');
    
    ## Download by project ##
    wget.cmd <- paste0(
        "wget -m ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/",
        substr(sra.id.vector, 1, 6),
        "/",
        sra.id.vector,
        "/"
    )
    
    cat("## Download SRA library ##"); cat('\n');
    cat(wget.cmd); cat('\n');
    
    
    mv.cmd <- paste0(
        "mv ",
        fastqDir,
        "ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/",
        substr(sra.id.vector, 1, 6),
        "/",
        sra.id.vector,
        "/* ./"
    )
    
    rm.cmd <- paste0(
        "rm -r ftp-trace.ncbi.nlm.nih.gov"
    )
    
    cat("## Organize files ##"); cat('\n');
    cat(mv.cmd); cat('\n');
    cat(rm.cmd); cat('\n');
    
    ## Make list of folders ##
    
    
    # create an array with all the filer/dir inside ~/myDir
    arr.cmd <- paste0(
        "arr=(",
        "./",
        "*)"
    )
    
    cat("## Create sample array ##"); cat('\n');
    cat(arr.cmd); cat('\n');
    
    ## fastq-dump command ##
    fastq.dump.cmd <- paste0(
        '  fastq-dump --outdir ',
        fastqDir,
        ' --gzip --skip-technical  --readids --read-filter pass --dumpbase --split-files $directory.sra'
    )
    
    # iterate through array using a counter
    ## convert to FASTQ ##
    
    cat('for ((i=0; i<${#arr[@]}; i++)); do'); cat('\n');
    cat('  #do something to each element of array'); cat('\n');
    cat('  echo "Processing ${arr[$i]} ..."'); cat('\n');
    cat('  directory=${arr[$i]}'); cat('\n');
    cat('  mv $directory/* ./'); cat('\n');
    cat('  rm -r $directory'); cat('\n');
    cat('  ## fastq-dump cmd'); cat('\n');
    cat(fastq.dump.cmd); cat('\n');
    cat('  ## Estimating read length ##'); cat('\n');
    cat('filename=$directory__pass_1.fastq.gz'); cat('\n');
    cat('if [ -f "$filename" ];'); cat('\n');
    cat('then'); cat('\n');
    cat("zcat $filename | awk 'NR%2==0' | awk '{print length($1)}' | head"); cat('\n');
    cat(' fi'); cat('\n');
    
    cat('filename=$directory__pass_1.fastq.gz'); cat('\n');
    cat('if [ -f "$filename" ];'); cat('\n');
    cat('then'); cat('\n');
    cat("zcat $filename | awk 'NR%2==0' | awk '{print length($1)}' | head"); cat('\n');
    cat('fi'); cat('\n');
    
    
    cat('done'); cat('\n');
    cat('## Output files will be named like SRR2979627_pass_1.fastq.gz'); cat('\n');
    
    
    
    sink()
    
    ## create documentation
    sra.docu.vec <- c(
        paste0("SRA project id:", sra.id.vector),
        paste0("Download date/time:" , date())
    )
    
    print("If this shell script was generated on a windows computer run:")
    print(paste0("tr -d '\r' <",paste0(sra.id.vector, ".sra.download.instructions.sh"),"> conv.",paste0(sra.id.vector, ".sra.download.instructions.sh")))
    
    return(sra.docu.vec)
}

## End of function: createSRAdownloadScript()                                ##
###############################################################################