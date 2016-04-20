<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />
    <!-- NOTE: we cannot start at /xml/mods because we use certain pieces of the
    /xml/item system-generated metadata -->
    <xsl:template match="/xml">
        <oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

            <xsl:if test="mods/titleInfo/title != ''">
                <dc:title>
                    <xsl:value-of select="mods/titleInfo/title"/>
                </dc:title>
            </xsl:if>

            <!-- @TODO note & tableOfContents also map here -->
            <xsl:if test="mods/abstract != ''">
                <dc:description>
                    <xsl:value-of select="mods/abstract" />
                </dc:description>
            </xsl:if>

            <!-- use item's URL, seems to be best practice -->
            <dc:identifier>https://vault.cca.edu/items/<xsl:value-of select="item/@id" />/<xsl:value-of select="item/@version" />/</dc:identifier>

            <!-- @TODO if we don't have dateCreated, what about another date?
            DC only has one date field for all -->
            <!-- Libraries collection -->
            <xsl:if test="mods/origininfo/dateCreatedWrapper/dateCreated != ''">
                <dc:date>
                    <xsl:value-of select="mods/origininfo/dateCreatedWrapper/dateCreated" />
                </dc:date>
            </xsl:if>
            <!-- Faculty Research -->
            <xsl:if test="mods/relatedItem/part/date != ''">
                <dc:date>
                    <xsl:value-of select="mods/relatedItem/part/date" />
                </dc:date>
            </xsl:if>

            <!-- @TODO is this the best way to separate creator from contributor? -->
            <xsl:for-each select="mods/name[@usage='primary']">
                <xsl:if test="namePart != ''">
                    <dc:creator>
                        <xsl:value-of select="namePart" />
                    </dc:creator>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="mods/name[@usage='secondary']">
                <xsl:if test="namePart != ''">
                    <dc:contributor>
                        <xsl:value-of select="namePart" />
                    </dc:contributor>
                </xsl:if>
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

            <!-- we also map mods/genreWrapper/genre to subject
            so that we can reserve dc:type (where genre would normally go)
            for DCMI Type terms to comply with Calisphere standards
            -->
            <xsl:for-each select="mods/genreWrapper">
                <xsl:for-each select="genre">
                    <xsl:if test="text() != ''">
                        <dc:subject>
                            <xsl:value-of select="text()" />
                        </dc:subject>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>

            <!-- Libraries collection -->
            <xsl:if test="mods/originInfo/publisher != ''">
                <dc:publisher>
                    <xsl:value-of select="mods/originInfo/publisher" />
                </dc:publisher>
            </xsl:if>
            <!-- Faculty Research, this is actually the journal/book
            which is not so great, but it's as close as we can get -->
            <xsl:if test="mods/relatedItem/title != ''">
                <dc:publisher>
                    <xsl:value-of select="mods/relatedItem/title" />
                </dc:publisher>
            </xsl:if>

            <!-- typeOfResource maps to dc:type

            We convert our vocabulary to DCMI Type terms, see
            https://sites.google.com/a/cca.edu/libraries/home/vault/calisphere-dcmi-types -->
            <xsl:for-each select="mods/typeOfResourceWrapper">
                <xsl:for-each select="typeOfResource">
                    <!-- caching text in variable makes this faster -->
                    <xsl:variable name="text" select="text()" />
                    <xsl:choose>
                        <xsl:when test="$text = 'cartographic'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'notated music'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'mixed material'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'moving image'">
                            <dc:type>MovingImage</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'software, multimedia'">
                            <dc:type>Software</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'still image'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <!-- this cover 3 values:
                        sound recording, sound recording-musical, sound recording-nonmusical -->
                        <xsl:when test="starts-with($text, 'sound recording')">
                            <dc:type>Sound</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'text'">
                            <dc:type>Text</dc:type>
                        </xsl:when>
                        <xsl:when test="$text = 'three dimensional object'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <!-- we do not supply an xsl:otherwise fallback -->
                    </xsl:choose>
                </xsl:for-each>
            </xsl:for-each>

            <!-- regardless of the physicalDescription child node, put it in format -->
            <xsl:for-each select="mods/physicalDescription/*">
                <dc:format>
                    <xsl:value-of select="text()" />
                </dc:format>
            </xsl:for-each>

            <xsl:if test="mods/language != ''">
                <dc:language>
                    <xsl:value-of select="mods/language" />
                </dc:language>
            </xsl:if>

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

            <xsl:if test="mods/accessCondition != ''">
                <dc:rights>
                    <xsl:value-of select="mods/accessCondition" />
                </dc:rights>
            </xsl:if>

        </oai_dc:dc>
    </xsl:template>
</xsl:transform>
