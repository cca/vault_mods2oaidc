# Tests

To run tests: `./tests/tests.sh`

How to write a test:

- use a consistent, clear, single-word test name `$NAME`
- create a _minimal_ example of XML input & name it $NAME.xml
- create an example of the output to expect & name it $NAME.expected.xml
  + note the XSLT assumes an identifier is always present so you have to add `<dc:identifier>https://vault.cca.edu/items//0/</dc:identifier>` to all *.expected.xml files
  + you may also need to ensure LF and not CRLF line endings so the files match
- add a line `runtest $NAME` to the bottom of tests.sh

The test outputs a diff of the two files. When the XSLT works, it will just say "Successful." and exit.

## Setup

Requires: `bash`, `xsltproc`, `cmp`, and `git`. The first three should come preinstalled on Mac OS X and most Linux distributions. Could trivially be rewritten to use a different comparison/diff tool but this a way is simple and produces great colorized output.
