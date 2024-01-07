rule gene_windows:
    input:
        geneBody_window="{}_body_window.bed".format(config['outPutPrefix']),
        geneUpstream_window="{}_upstream_window.bed".format(config['outPutPrefix']),
        geneDownstream_window="{}_downstream_window.bed".format(config['outPutPrefix']),
        inupt_rest_picture="resources/test.png"
    output:
        all_window="{}_windows_Id.bed".format(config['outPutPrefix']),
        # #* test report
        # test_report=report(
        #     "{}_test.png".format(config['outPutPrefix']),
        #     caption="../report/gene_window.rst"
        # )
    params:
        upStreamWindowCount=config['params']['flankWindowCount'],
    shell:
        """
        cat {input.geneBody_window} |awk '{{print $1"\\t"$2"\\t"$3"\\t"$4"\\t"$5+{params.upStreamWindowCount}
            }}'|cat - {input.geneUpstream_window}  {input.geneDownstream_window} \
            |sort -k1,1 -k2,3n -k5,5n >{output.all_window}
        """
