rule intersected_with_gene:
    input: 
        geneBedFile=config['geneBed'],
        chromLengthFile=config['Chrlength']
    output: 
        geneIntersect_Chr=temp('{}_intersected_Chr.bed'.format(config['outPutPrefix'])),
    shell: 
        '''
        cat {input.chromLengthFile}|awk '{{print $1"\\t0\\t"$2}}'|intersectBed  \
             -a {input.geneBedFile} -b stdin -loj >{output.geneIntersect_Chr}
        '''