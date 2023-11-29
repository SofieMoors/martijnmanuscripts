<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:func="http://exslt.org/functions"
	xmlns:mvn="http://www.huygensinstituut.knaw.nl/projecten/mvn/"
	xmlns:math="http://exslt.org/math"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	extension-element-prefixes="func math">
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:lb">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:variable name="mb" select="preceding::*[local-name()='cb' or local-name()='pb' or local-name()='qb'][1]"/>
			<xsl:variable name="mbpos" select="mvn:number($mb)"/>
			<xsl:variable name="n">
				<xsl:variable name="pos" select="mvn:number(.)"/>
				<xsl:choose>
					<xsl:when test="preceding::tei:lb[@n and (mvn:number(.) &gt; $mbpos)]">
						<xsl:variable name="mblb" select="preceding::tei:lb[@n and (mvn:number(.) &gt; $mbpos)][1]"/>
						<xsl:variable name="mblbpos" select="mvn:number($mblb)"/>
						<xsl:variable name="mblbn" select="$mblb/@n"/>
						<xsl:value-of select="$mblbn + count(preceding::tei:lb[mvn:number(.) &gt; $mblbpos]) + 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(preceding::tei:lb[mvn:number(.) &gt; $mbpos]) + 1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(@n)">
				<xsl:attribute name="n">
					<xsl:value-of select="$n"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@xml:id)">
				<xsl:attribute name="xml:id">
					<xsl:value-of select="$mb/@xml:id"/>
					<xsl:choose>
						<xsl:when test="@n">
							<xsl:value-of select="@n"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$n"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<func:function name="mvn:number">
		<xsl:param name="node"/>
		<func:result>
			<xsl:value-of select="count($node/preceding::*)"/>
<!--			<xsl:for-each select="$node">
				<xsl:number/>
			</xsl:for-each>
-->		</func:result>
	</func:function>
<!--	<func:function name="mvn:namesok">
		<xsl:param name="tag"/>
		<xsl:param name="name"/>
		<func:result>
			<xsl:choose>
				<xsl:when test="$name='lb' or $name='cb' or $name='pb' or $name='qb'">
					<func:result select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<func:result select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</func:result>
	</func:function>
--></xsl:stylesheet>
