coordinates=de.tudarmstadt.ukp.dkpro.core_de.tudarmstadt.ukp.dkpro.core.opennlp-asl_1.9.0-SNAPSHOT 
className=de.tudarmstadt.ukp.dkpro.core.opennlp.OpenNlpSegmenter
inD=../testOutput_de.tudarmstadt.ukp.dkpro.core.io.pdf.PdfReader/
otD=../testOutput_$className/

bash ../Linux_runUIMA.sh $coordinates $className -input $inD -output $otD
