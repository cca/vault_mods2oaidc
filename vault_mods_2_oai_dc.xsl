<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />
    <!-- NOTE: we cannot start at /xml/mods because we use certain pieces of the
    /xml/item system-generated metadata -->
    <xsl:template match="/xml">
        <oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

            <dc:title>
                <xsl:value-of select="mods/titleInfo/title"/>
            </dc:title>

            <!-- @TODO note & tableOfContents also map here -->
            <dc:description>
                <xsl:value-of select="mods/abstract" />
            </dc:description>

            <dc:identifier>
                <!-- question: include version in identifier? use URL? -->
                <xsl:value-of select="item/@id" />/<xsl:value-of select="item/@version" />
            </dc:identifier>
            <!-- @TODO if we don't have dateCreated, what about another date?
            DC only has one date field for all -->
            <!-- Libraries collection -->
            <xsl:if test="mods/origininfo/dateCreatedWrapper/dateCreated">
                <dc:date>
                    <xsl:value-of select="mods/origininfo/dateCreatedWrapper/dateCreated" />
                </dc:date>
            </xsl:if>
            <!-- Faculty Research -->
            <xsl:if test="mods/relatedItem/part/date">
                <dc:date>
                    <xsl:value-of select="mods/relatedItem/part/date" />
                </dc:date>
            </xsl:if>

            <!-- @TODO is this the best way to separate creator from contributor? -->
            <xsl:for-each select="mods/name[@usage='primary']">
                <dc:creator>
                    <xsl:value-of select="namePart" />
                </dc:creator>
            </xsl:for-each>
            <xsl:for-each select="mods/name[@usage='secondary']">
                <dc:contributor>
                    <xsl:value-of select="namePart" />
                </dc:contributor>
            </xsl:for-each>

            <!-- for Faculty Research collection, which follows MODS more closely -->
            <xsl:for-each select="mods/name">
                <xsl:if test="contains(role/roleTerm, 'author')">
                    <dc:creator>
                        <xsl:value-of select="namePart" />
                    </dc:creator>
                </xsl:if>
                <xsl:if test="contains(role/roleTerm, 'editor')">
                    <dc:contributor>
                        <xsl:value-of select="namePart" />
                    </dc:contributor>
                </xsl:if>
            </xsl:for-each>

            <!-- MODS subject/name & subject/topic => dc:subject
            we don't use subject/occupation -->
            <xsl:for-each select="mods/subject">
                <xsl:for-each select="name">
                    <dc:subject>
                        <xsl:value-of select="text()" />
                    </dc:subject>
                </xsl:for-each>

                <xsl:for-each select="topic">
                    <dc:subject>
                        <xsl:value-of select="text()" />
                    </dc:subject>
                </xsl:for-each>
            </xsl:for-each>

            <dc:publisher>
                <xsl:value-of select="mods/originInfo/publisher" />
            </dc:publisher>

            <!-- typeOfResource & genre collapse to dc:type

            @TODO should be convert to DC terms for type? a choose/when/otherwise
            block would be the way to accomplish this, see
            http://www.w3schools.com/xsl/xsl_choose.asp -->
            <xsl:for-each select="mods/typeOfResourceWrapper">
                <xsl:for-each select="typeOfResource">
                    <dc:type>
                        <xsl:value-of select="text()" />
                    </dc:type>
                </xsl:for-each>
            </xsl:for-each>

            <xsl:for-each select="mods/genreWrapper">
                <xsl:for-each select="genre">
                    <dc:type>
                        <xsl:value-of select="text()" />
                    </dc:type>
                </xsl:for-each>
            </xsl:for-each>

            <!-- regardless of the physicalDescription child node, put it in format -->
            <xsl:for-each select="mods/physicalDescription/*">
                <dc:format>
                    <xsl:value-of select="text()" />
                </dc:format>
            </xsl:for-each>

            <dc:language>
                <xsl:value-of select="mods/language" />
            </dc:language>

            <!-- MODS subject/geographic & subject/temporal => dc:coverage
            & we don't use cartographics or hierarchicalGeographic -->
            <xsl:for-each select="mods/subject">
                <xsl:for-each select="temporal">
                    <dc:coverage>
                        <xsl:value-of select="text()" />
                    </dc:coverage>
                </xsl:for-each>

                <xsl:for-each select="geographic">
                    <dc:coverage>
                        <xsl:value-of select="text()" />
                    </dc:coverage>
                </xsl:for-each>
            </xsl:for-each>

            <dc:rights>
                <xsl:value-of select="mods/accessCondition" />
            </dc:rights>
        </oai_dc:dc>
    </xsl:template>
</xsl:transform>
