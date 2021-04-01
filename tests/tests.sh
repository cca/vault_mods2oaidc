#!/usr/bin/env bash
# https://github.com/cca/vault_mods2oaidc/issues/5
runtest () {
    TEST=$1
    echo "Running $TEST test..."
    xsltproc --output tests/$TEST.dc vault_mods_2_oai_dc.xsl tests/$TEST.xml
    # cmp comes from Gnu diff utils, not sure if it's stock OS X
    cmp --quiet tests/$TEST.dc tests/$TEST.expected.xml
    if [[ $? -eq 0 ]]
        then echo 'Successful.'
    else
        echo "$TEST test failed; output does not match expectations. Diff:"
        git diff --no-index --color-words tests/$TEST.dc tests/$TEST.expected.xml
        exit 1
    fi
}

runtest datewrapper
