# VAULT MODS to OAI Dublin Core

An XSLT stylesheet for converting from our (highly localized) MODS schema to the Dublin Core values that OAI-PMH expects, so that we can expose VAULT metadata publicly in a more consumable manner than the default configuration.

VAULT OAI feed URL for the "Libraries" collection: https://vault.cca.edu/oai?verb=ListRecords&metadataPrefix=oai_dc&set=6b755832-4070-73d2-77b3-3febcc1f5fad

## Application

- open the VAULT admin console https://vault.cca.edu/jnlp/admin.jnlp
- select **Metadata Schemas**
- select **MODS**
- under the **Transformations** tab add this repository's XSLT stylesheet under the _Export Transformations_ section

## Notes & Links

- [MODS to Dubline Core Mapping](http://www.loc.gov/standards/mods/mods-dcsimple.html) by LoC
