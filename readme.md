# VAULT MODS to OAI Dublin Core

An XSLT stylesheet for converting from our (highly localized) MODS schema to the Dublin Core values that OAI-PMH expects, so that we can expose VAULT metadata publicly in a more consumable manner than the default configuration.

VAULT OAI feed URL for the "Libraries" collection: https://vault.cca.edu/oai?verb=ListRecords&metadataPrefix=oai_dc&set=6b755832-4070-73d2-77b3-3febcc1f5fad

You can test out this XSLT on Mac OS X using the builtin `xsltproc` with the provided "convert.sh" script. Example MODS documents from the Libraries and Faculty Research collections are provided.

## Application

- open the VAULT admin console https://vault.cca.edu/jnlp/admin.jnlp
- select **Metadata Schemas**
- select **MODS**
- under the **Transformations** tab add this repository's XSLT stylesheet under the _Export Transformations_ section

## Notes & Links

- [Metadata Harvesting Scheme and Crosswalk - Calisphere](https://registry.cdlib.org/documentation/docs/registry/metadata-harvest.1.html)
- [DCMI Types mapping](https://sites.google.com/a/cca.edu/libraries/home/vault/calisphere-dcmi-types) (libraries' private wiki)
- [MODS to Dublin Core Mapping](http://www.loc.gov/standards/mods/mods-dcsimple.html) by LoC
- [VAULT Schema](https://github.com/cca/vault_schema)
- [USC's ContentDM OAI feed](http://digitallibrary.usc.edu/oai/oai.php?verb=ListSets) (good example)
