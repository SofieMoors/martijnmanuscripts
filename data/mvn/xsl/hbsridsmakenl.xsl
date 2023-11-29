<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    exclude-result-prefixes="xs xi tei" version="2.0">

    <xsl:template match="/">
        <xsl:variable name="numberedxml">
            <xsl:apply-templates mode="copy"/>
        </xsl:variable>
        <xsl:result-document href="numbered.xml">
            <xsl:copy-of select="$numberedxml"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:encodingDesc" mode="copy">
        <xsl:copy>
            <xsl:element name="xi:include">
                <xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
                <xsl:attribute name="href">charDecl.xml</xsl:attribute>
            </xsl:element>
            <xsl:text>
        </xsl:text>
            <tei:editorialDecl><tei:p>Voor alle andere opmerkingen: zie de inleiding bij de editie.</tei:p></tei:editorialDecl>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:l" mode="copy">
        <xsl:copy>
            <xsl:variable name="num">
                <xsl:number level="any" count="tei:l" from="tei:body"/>
            </xsl:variable>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="ancestor::tei:text[1]/@xml:id"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$num"/>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="$num"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(local-name()='n') and not(name()='xml:id')]" mode="copy"/>
            <xsl:apply-templates select="node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
