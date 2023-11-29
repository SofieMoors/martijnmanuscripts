<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <link href="mvnhtml.css" rel="stylesheet" type="text/css"/>
                <link href="http://www.huygensinstituut.knaw.nl/projecten/mvn/webfiles/mvnhtml.css" rel="stylesheet" type="text/css"/>
                <title>Character declarations</title>
            </head>
            <body>
                <h1>Character declarations</h1>
                
                <p>Op volgorde van id:</p>  
                <table>
                    <tr>
                        <td><b>Id</b></td>
                        <td><b>Mapping(s)</b></td>
                        <td><b>Name</b></td>
                        <td><b>note(s)</b></td>
                    </tr>
                    <xsl:apply-templates select="//tei:char">
                        <xsl:sort select="@xml:id"/>
                    </xsl:apply-templates>
                </table>
                <p>Op volgorde van naam:</p>  
                <table>
                    <tr>
                        <td><b>Id</b></td>
                        <td><b>Mapping(s)</b></td>
                        <td><b>Name</b></td>
                        <td><b>note(s)</b></td>
                    </tr>
                    <xsl:apply-templates select="//tei:char">
                        <xsl:sort select="tei:charName/text()"/>
                    </xsl:apply-templates>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:char">
        <tr>
            <td style="vertical-align:top"> 
                <xsl:value-of select="@xml:id"/>
            </td>
            <td style="vertical-align:top">
                <xsl:apply-templates select="tei:mapping"/>
            </td>
            <td style="vertical-align:top">
                <xsl:apply-templates select="tei:charName"/>
            </td>
            <td style="vertical-align:top">
                <xsl:apply-templates select="tei:note"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:mapping">
        <xsl:value-of select="@type"/>
        <xsl:text>:&#xA0;&#xA0;&#xA0;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA0;&#xA0;&#xA0;(</xsl:text>
        <xsl:value-of select="string-to-codepoints(text())"></xsl:value-of>
        <xsl:text>)</xsl:text>
        <br/>
    </xsl:template>
</xsl:stylesheet>
