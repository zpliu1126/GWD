flankWindowSize=config['params']['flankLength']/config['params']['flankWindowCount']
windowCount_init=config['params']['flankWindowCount']+config['params']['geneWindowCount']
rule geneDownStream_window:
    input:
        #* Chr
        #* Start
        #* End
        #* Strand
        #* gene Id
        geneBedFile=config['geneBed'],
        chromLengthFile=config['Chrlength'],
        geneIntersect_Chr='{}_intersected_Chr.bed'.format(config['outPutPrefix']),
    output:
        geneDownStream_window=temp("{}_downstream_window.bed".format(config['outPutPrefix'])),
    params:
        region=config['params']['flankLength'],
        windowCount=config['params']['flankWindowCount'],
        initWindowId=windowCount_init,
        windowSize=flankWindowSize
    shell:
        """
        #* + strand
        cat {input.geneIntersect_Chr}|awk '$8-$3>={params.region}&&$4=="+"{{ 
            print $1"\\t"$3+1"\\t"$3+{params.region}"\\t"$5
            }}'|windowMaker -b - -n {params.windowCount}  -i srcwinnum \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]+{params.initWindowId}
                    }}' >{output.geneDownStream_window}
        #? gene at the end of chromosome
        cat {input.geneIntersect_Chr}|awk '$8-$3<{params.region}&&$4=="+"{{ 
            print $1"\\t"$3+1"\\t"$8"\\t"$5
            }}'|windowMaker -b - -w {params.windowSize} -s {params.windowSize}  -i srcwinnum \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]+{params.initWindowId}
                    }}' >>{output.geneDownStream_window}
        #* - strand
        cat {input.geneIntersect_Chr}|awk '$2>={params.region}&&$4=="-"{{ 
                print $1"\\t"$2-{params.region}"\\t"$2-1"\\t"$5}}' \
            |windowMaker -b - -n {params.windowCount}  -i srcwinnum -reverse \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]+{params.initWindowId}
                    }}' >>{output.geneDownStream_window}
        #? gene at the end of chromosome
        cat {input.geneIntersect_Chr}|awk '$2<{params.region}&&$4=="-"{{ 
                print $1"\\t"1"\\t"$2-1"\\t"$5}}' \
            |windowMaker -b - -w {params.windowSize} -s {params.windowSize} -i srcwinnum -reverse \
            |awk '{{split($4,a,"_");a_len=length(a);print $1"\\t"$2"\\t"$3"\\t"$4"\\t"a[a_len]+{params.initWindowId}
                    }}' >>{output.geneDownStream_window}
        """
