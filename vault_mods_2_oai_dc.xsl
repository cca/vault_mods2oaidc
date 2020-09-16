<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />
    <!-- NOTE: we cannot start at /xml/mods because we use certain pieces of the
    /xml/item system-generated metadata -->
    <xsl:template match="/xml">
        <oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:dcterms="http://purl.org/dc/terms/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

            <!-- NOTE reference mapping here:
            https://www.loc.gov/standards/mods/mods-dcsimple.html -->

            <xsl:if test="mods/titleInfo/title != ''">
                <dc:title>
                    <xsl:value-of select="mods/titleInfo/title"/>
                </dc:title>
            </xsl:if>

            <xsl:if test="mods/abstract != ''">
                <dc:description>
                    <xsl:value-of select="mods/abstract" />
                </dc:description>
            </xsl:if>

            <xsl:if test="mods/tableOfContents != ''">
                <dcterms:tableOfContents>
                    <xsl:value-of select="mods/tableOfContents" />
                </dcterms:tableOfContents>
            </xsl:if>

            <!-- use item's URL as identifier, seems to be best practice
            magical EQUELLA hack: version 0 redirects to latest live version -->
            <dc:identifier>
                <xsl:text>https://vault.cca.edu/items/</xsl:text>
                <xsl:value-of select="item/@id" />
                <xsl:text>/0/</xsl:text>
            </dc:identifier>

            <!-- Libraries collection -->
            <xsl:if test="mods/origininfo/dateCreatedWrapper/dateCreated != ''">
                <dc:date>
                    <xsl:value-of select="mods/origininfo/dateCreatedWrapper/dateCreated" />
                </dc:date>
            </xsl:if>
            <xsl:if test="mods/origininfo/dateOtherWrapper/dateOther != ''">
                <dc:date>
                    <xsl:value-of select="mods/origininfo/dateOtherWrapper/dateOther" />
                </dc:date>
            </xsl:if>
            <!-- Faculty Research -->
            <xsl:if test="mods/relatedItem/part/date != ''">
                <dc:date>
                    <xsl:value-of select="mods/relatedItem/part/date" />
                </dc:date>
            </xsl:if>

            <!-- separate creator from contributor -->
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

            <!-- typeOfResource maps to dc:type
            We convert our vocabulary to DCMI Type terms, see
            sites.google.com/a/cca.edu/libraries/home/vault/calisphere-dcmi-types -->
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
                        <!-- this covers 3 values:
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

            <!-- for our more strictly MODS-adherent collections like Open Access
            Journal Articles. See also mods/genreWrapper/genre -> dc:subject above.
            MODS genre-> dc:type, NOT subject -->
            <xsl:for-each select="mods/genre">
                <xsl:if test="text() != ''">
                    <dc:type>
                        <xsl:value-of select="text()" />
                    </dc:type>
                </xsl:if>
            </xsl:for-each>

            <!-- for Artists' Books collection, Calisphere wants everything to have a "type"
            working around apostrophe in string, have to use entities for both the wrapping
            quotes and the apos in the string -->
            <xsl:if test="mods/physicalDescription/formBroad = &quot;artists&apos; books (books)&quot;">
                <dc:type>Image</dc:type>
            </xsl:if>

            <!-- specifically for Communications collection
            which sets local/communicationsWrapper/submissionType to one of
            press image, publication, or document -->
            <xsl:for-each select="local/communicationsWrapper">
                <xsl:if test="submissionType != ''">
                    <xsl:variable name="type" select="submissionType" />
                    <xsl:choose>
                        <xsl:when test="$type = 'document'">
                            <dc:type>Text</dc:type>
                        </xsl:when>
                        <xsl:when test="$type = 'press image'">
                            <dc:type>Image</dc:type>
                        </xsl:when>
                        <xsl:when test="$type = 'publication'">
                            <dc:type>Text</dc:type>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                <xsl:for-each select="photographer">
                    <dc:creator>
                        <xsl:value-of select="text()" />
                    </dc:creator>
                </xsl:for-each>
            </xsl:for-each>

            <!-- regardless of the physicalDescription child node, put it in format -->
            <xsl:for-each select="mods/physicalDescription/*">
                <xsl:if test="text() != ''">
                    <dc:format>
                        <xsl:value-of select="text()" />
                    </dc:format>
                </xsl:if>
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

            <!-- for Faculty Research collection
            must expose the host publication, especially for inclusion in Worldcat
            Libraries collection also uses relatedItem[type=host]
            so we need to check for an ISSN or ISBN -->
            <xsl:for-each select="mods/relatedItem[@type='host']">
                <xsl:if test="identifier/@type = 'issn'">
                    <xsl:if test="identifier != ''">
                        <dcterms:isPartOf>
                            <xsl:text>urn:ISSN:</xsl:text>
                            <xsl:value-of select="identifier" />
                        </dcterms:isPartOf>
                    </xsl:if>

                    <!-- fully formatted citation along the lines of
                    Library and Information Science Research 22(3), 311-338. (2000)
                    for some reason xsl:text is necessary to make the 1st space appear-->
                    <dcterms:bibliographicCitation>
                        <!-- we'll always have at least a title -->
                        <xsl:value-of select="titleInfo/title" />

                        <xsl:variable name="volume" select="part/detail[@type='volume']/number" />
                        <xsl:if test="$volume != ''">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$volume" />
                        </xsl:if>

                        <xsl:if test="part/detail[@type='number']/number != ''">
                            <xsl:text>(</xsl:text>
                            <xsl:value-of select="part/detail[@type='number']/number" />
                            <xsl:text>)</xsl:text>
                        </xsl:if>

                        <!-- only show comma if we have at least volume & start pg -->
                        <xsl:variable name="start" select="part/extent/start" />
                        <xsl:if test="$volume != '' and $start != ''">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="$start != ''">
                            <xsl:value-of select="$start" />
                        </xsl:if>

                        <xsl:if test="part/extent/end != ''">
                            <xsl:text>-</xsl:text><xsl:value-of select="part/extent/end" />
                        </xsl:if>

                        <xsl:text>.</xsl:text>

                        <xsl:if test="part/date != ''">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="part/date" />
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </dcterms:bibliographicCitation>
                </xsl:if>

                <!-- similar but for book chapters with associated ISBNs -->
                <xsl:if test="identifier/@type = 'isbn' and identifier !=''">
                    <dcterms:isPartOf>
                        <xsl:text>urn:ISBN:</xsl:text>
                        <xsl:value-of select="identifier" />
                    </dcterms:isPartOf>
                </xsl:if>

                <!-- per Summon Support putting journal title in dc:source
                is helpful, gets translated to PublicationTitle field.
                @TODO is this true for book chapters, too? Ask Support. -->
                <xsl:if test="titleInfo/title != ''">
                    <dc:source>
                        <xsl:value-of select="titleInfo/title" />
                    </dc:source>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="local/department">
                <dc:subject>
                    <xsl:value-of select="text()" />
                </dc:subject>
            </xsl:for-each>

            <xsl:if test="mods/accessCondition != ''">
                <dc:rights>
                    <xsl:value-of select="mods/accessCondition" />
                </dc:rights>
            </xsl:if>

            <xsl:if test="mods/accessCondition/@href != ''">
                <dc:rights>
                    <xsl:value-of select="mods/accessCondition/@href" />
                </dc:rights>
            </xsl:if>

        </oai_dc:dc>
    </xsl:template>
</xsl:transform>
