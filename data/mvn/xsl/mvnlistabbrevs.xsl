<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:func="http://exslt.org/functions" 
    xmlns:mvn="http://www.huygensinstituut.knaw.nl/projecten/mvn/"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0"
     exclude-result-prefixes="mvn func tei"
     extension-element-prefixes="func mvn">
	<xsl:key name="chars" match="tei:char" use="@xml:id"/>
	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:text>Lijst van afkortingen</xsl:text></title>
			</head>
		</html>
		<body style="font-family:junicode;font-size:xx-large">
		    <h2><xsl:apply-templates select="//tei:titleStmt"/></h2>
		    <xsl:text>Lijst van afkortingen</xsl:text>
		<table>
		    <tr>
		        <td>afkorting</td>
		        <td>oplossing</td>
		        <td>regel</td>
		    </tr>
			<xsl:apply-templates select="//tei:choice">
			    <xsl:sort select="mvn:expan(.)"/>
			</xsl:apply-templates>
		</table>
		</body>
	</xsl:template>
	<xsl:template match="tei:choice">
		<tr>
			<td style="vertical-align:top"><xsl:apply-templates select="tei:abbr"/></td>
		    <td style="vertical-align:top"><xsl:apply-templates select="tei:expan"/></td>
		    <td style="vertical-align:top"><xsl:value-of select="preceding::tei:lb[1]/@xml:id"/></td>
		</tr>
	</xsl:template>
	<xsl:template match="tei:g">
		<xsl:variable name="key">
			<xsl:value-of select="substring-after(@ref,'#')"/>
		</xsl:variable>
		<xsl:apply-templates select="key('chars',$key)"/>
	</xsl:template>
	<xsl:template match="tei:char">
	    <xsl:choose>
	        <xsl:when test="tei:mapping[@type='standard']">
	            <xsl:apply-templates select="tei:mapping[@type='standard']"/>
	        </xsl:when>
	        <xsl:when test="tei:mapping[@type='junicode']">
	            <xsl:apply-templates select="tei:mapping[@type='junicode']"/>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:text>[??]</xsl:text>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

    <func:function name="mvn:expan">
        <xsl:param name="choice"/>
        <func:result>
            <xsl:apply-templates select="tei:expan"/>
        </func:result>
    </func:function>
    
</xsl:stylesheet>
