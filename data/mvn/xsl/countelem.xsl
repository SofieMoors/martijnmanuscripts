<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:key name="gis" match="*" use="name()"/>
    
    <xsl:template match="node()">
        <tagsDecl>
            <xsl:for-each select="//*[generate-id(.)=generate-id(key('gis',name(.))[1])]">
                <xsl:sort select="name()"/>
                <xsl:if test="not(ancestor-or-self::tei:teiHeader)">
                    <tagUsage gi="{name(.)}"><xsl:value-of select="count(key('gis', name(.)))" /></tagUsage>
                </xsl:if>
            </xsl:for-each>
        </tagsDecl>
    </xsl:template>
</xsl:stylesheet>