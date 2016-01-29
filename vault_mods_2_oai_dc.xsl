<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
            <dc:title>
                <xsl:value-of select="/xml/mods/titleInfo/title"/>
            </dc:title>
            <dc:description>
                <xsl:value-of select="/xml/mods/abstract" />
            </dc:description>
            <dc:identifier>
                <!-- question: include version in identifier? -->
                <xsl:value-of select="/xml/item/@id" />/<xsl:value-of select="/xml/item/@version" />
            </dc:identifier>
            <dc:date>
                <xsl:value-of select="/xml/mods/origininfo/dateCreatedWrapper/dateCreated" />
            </dc:date>
            <!-- @TODO dc:creator -->
            <!-- @TODO what else can be added?
            see http://www.loc.gov/standards/mods/mods-dcsimple.html -->
        </oai_dc:dc>
    </xsl:template>
</xsl:transform>
