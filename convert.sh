#!/usr/bin/env bash
# run all XML files in this folder through the XSLT conversion
for file in *.xml; do
    xsltproc --output $file.dc vault_mods_2_oai_dc.xsl $file
done
