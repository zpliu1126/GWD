rule geneBody_windows:
    input:
        #* Chr
        #* Start
        #* End
        #* Strand
        #* gene Id
        geneBedFile=config['geneBed'],
    output:
        geneBody_window=temp("{}_body_window.bed".format(config['outPutPrefix'])),
    params:
        windowCount=config['params']['geneWindowCount']
    shell:
        """
        #* + strand
        cat {input.geneBedFile}|awk '$4=="+"{{print $1"\\t"$2"\\t"$3"\\t"$5}}' \
            |windowMaker -b - -n {params.windowCount}  -i srcwinnum \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]}}' >{output.geneBody_window}

        #* - strand
        cat {input.geneBedFile}|awk '$4=="-"{{print $1"\\t"$2"\\t"$3"\\t"$5}}' \
            |windowMaker -b - -n {params.windowCount}  -reverse -i srcwinnum \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]}}' >>{output.geneBody_window}
        """
