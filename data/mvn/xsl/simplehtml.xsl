<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei func mvn"
xmlns:func="http://exslt.org/functions" 
xmlns:mvn="http://www.huygensinstituut.knaw.nl/projecten/mvn/"
extension-element-prefixes="func">
    
<xsl:param name="greyabbr">yes</xsl:param>    
    <xsl:param name="process">yes</xsl:param>    
    <xsl:param name="expand">no</xsl:param>    
    <xsl:param name="newline">yes</xsl:param>    
    <xsl:variable name="sigle" select="/tei:MVN/tei:text/@xml:id"/>
    <xsl:variable name="allversenums">
        <xsl:value-of select="false()"/>
    </xsl:variable>
    
    <xsl:key name="char" match="tei:char" use="@xml:id"/>
    
    <xsl:template match="/">

        <html>
            <head>
                <title>
                    <xsl:apply-templates select="//tei:titleStmt/tei:title"/>
                    <xsl:text> - </xsl:text>
                    <xsl:apply-templates select="//tei:titleStmt/tei:editor"/>
                </title>
                <link href="https://xmlschema.huygens.knaw.nl/mvnhtml.css" rel="stylesheet" type="text/css"/>
                <link href="mvnhtml.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <h2>
                    <xsl:apply-templates select="//tei:titleStmt/tei:title"/>
                    <xsl:text> - </xsl:text>
                    <xsl:apply-templates select="//tei:titleStmt/tei:editor"/>
                </h2>
                <div>
                    Teksten: 
                    <xsl:apply-templates select="/tei:MVN/tei:text[1]/tei:group[1]//*[local-name() = 'text' or local-name() = 'group']" mode="link"/>
                    <hr/>
                    Foliumzijden: 
                    <xsl:apply-templates select="//tei:pb" mode="link"/>
                    
                </div>
                <div>
                    <xsl:apply-templates select="/tei:MVN/tei:text/tei:group//tei:text"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:abbr[not(parent::tei:choice)]">
        <span>
            <xsl:attribute name="title">
                <xsl:text>Abbreviation (no expansion available)</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:add">
        <span class="add">
            <xsl:attribute name="title">
                <xsl:text>add </xsl:text>
                <xsl:text>place=</xsl:text>
                <xsl:value-of select="@place"/>
                <xsl:text> rend=</xsl:text>
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:char">
        <xsl:choose>
            <xsl:when test="tei:mapping[@type='standard']">
                <xsl:apply-templates select="tei:mapping[@type='standard']"/>
            </xsl:when>
            <xsl:when test="tei:mapping[@type='temp']">
                <xsl:apply-templates select="tei:mapping[@type='temp']"/>
            </xsl:when>
            <xsl:when test="tei:mapping[@type='junicode']">
                <span>
                    <xsl:attribute name="class">
                        <xsl:text>junicode</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="tei:mapping[@type='junicode']"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="problem">[no mapping available for char <xsl:apply-templates select="tei:charName"/>]</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:choice[tei:abbr and tei:expan]">
        <span>
            <xsl:if test="$greyabbr='yes'">
                <xsl:attribute name="class">
                    <xsl:text>choice</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$expand='yes'">
                    <xsl:attribute name="title">
                        <xsl:text>Abbreviation was </xsl:text>
                        <xsl:apply-templates select="tei:abbr" mode="text"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="tei:expan"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="title">
                        <xsl:text>Abbreviation expansion = </xsl:text>
                        <xsl:apply-templates select="tei:expan" mode="text"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="tei:abbr"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:damage">
        <span class="damage">
            <xsl:attribute name="title">
                <xsl:text>damage agent=</xsl:text>
                <xsl:value-of select="@agent"/>
                <xsl:text> extent=</xsl:text>
                <xsl:value-of select="@extent"/>
                <xsl:text> degree=</xsl:text>
                <xsl:value-of select="@degree"/>
            </xsl:attribute>
            <xsl:text>*</xsl:text>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:del">
        <xsl:if test="$process='yes'">
            <span class="del">
                <xsl:attribute name="title">
                    <xsl:text>del </xsl:text>
                    <xsl:text>type=</xsl:text>
                    <xsl:value-of select="@type"/>
                    <xsl:text> rend=</xsl:text>
                    <xsl:value-of select="@rend"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ex">
        <span class="ex">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:expan[not(parent::tei:choice)]">
        <span>
            <xsl:attribute name="title">
                <xsl:text>Expansion (no abbreviation available)</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
                <span>
                    <xsl:attribute name="class">
                        <xsl:text>foreign-</xsl:text>
                        <xsl:value-of select="@xml:lang"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
    </xsl:template>
    
    <xsl:template match="tei:fw">
        <xsl:choose>
            <xsl:when test="@type='header'">
                <span class="fwheader">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="problem">[no rendering available for non-header fw elements]</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:g">
        <xsl:apply-templates select="key('char',substring-after(@ref,'#'))"/>
    </xsl:template>

    <xsl:template match="tei:gap">
        <span class="gap">
            <xsl:attribute name="title">
                <xsl:text>gap unit=</xsl:text>
                <xsl:value-of select="@unit"/>
                <xsl:text> extent=</xsl:text>
                <xsl:value-of select="@extent"/>
            </xsl:attribute>
            <xsl:text>*</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:head[not(ancestor::tei:p or ancestor::tei:lg)]">
        <xsl:choose>
            <xsl:when test="ancestor::tei:p or ancestor::tei:lg">
                <seg title="head">
                    <xsl:apply-templates/>
                </seg>
            </xsl:when>
            <xsl:otherwise>
                <p title="head">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:hi">
        <span class="{@rend}" title="{@rend}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:choose>
            <xsl:when test="$newline='yes'">
                <br />
                <span class="linenumnewline">
                    <xsl:choose>
<!--                        <xsl:when test="@n mod 5 = 0">
-->                        <xsl:when test="@n">
                                <xsl:value-of select="@n"/>
                        </xsl:when>
                        <xsl:otherwise>&#xA0;</xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:when test=" ancestor::tei:p or ancestor::tei:head">
                <span class="linenumrunning">
                    <xsl:text> / </xsl:text>
                    <xsl:if test="@n mod 5 = 0">
                        <xsl:value-of select="@n"/>
                        <xsl:text> / </xsl:text>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="$allversenums">
                <span class="verseline">
                    <xsl:value-of select="@n"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@n mod 4 = 0">
                    <span class="verseline">
                        <xsl:value-of select="@n"/>
                    </span>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:lg">
        <p class="lg">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <span class="note">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="following-sibling::*[1][local-name()='note']">
            <br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:note[@type='ms' or @resp='scribe']">
        <span class="note">
            <xsl:if test="contains(@place,'left')">
                <xsl:attribute name="style">position:absolute;left:-30px;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:num[@type='roman']">
        <span class='romannumber' title="roman number">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <br />
        <span class="pagenum">
            <xsl:if test="not(ancestor::tei:p or ancestor::tei:head)">
                <xsl:attribute name="class">
                    <xsl:text>moveleft</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="name">
                    <xsl:text>pb</xsl:text>
                    <xsl:value-of select="@n"/>
                </xsl:attribute>
            </a>
            [<xsl:value-of select="@n"/>]
        </span>
    </xsl:template>

    <xsl:template match="tei:restore">
        <span class="restore" title="restore">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:subst">
        <span class="subst" title="subst">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:text[count(ancestor::tei:text)=1]">
        <div class="text">
            <a name="{@xml:id}"/>
            <xsl:apply-templates select="." mode="nextprev"/>
            Tekst
            <xsl:choose>
                <xsl:when test="contains(@xml:id, $sigle)">
                    <xsl:value-of select="substring-after(@xml:id,$sigle)"/> 
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@n"/> 
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:text[count(ancestor::tei:text)&gt;1]">
        <div class="text">
            <a name="{@xml:id}"/>
            Tekst  
            <xsl:choose>
                <xsl:when test="contains(@xml:id, $sigle)">
                    <xsl:value-of select="substring-after(@xml:id,$sigle)"/> 
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@n"/> 
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:text" mode="nextprev">
        <div class="nextprev">
            <xsl:choose>
                <xsl:when test="preceding-sibling::tei:text">
                    <a href="{mvn:textlink(preceding-sibling::tei:text[1])}">
                        <xsl:text>&lt;==</xsl:text>
                    </a>
                </xsl:when>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="following-sibling::tei:text">
                    <a href="{mvn:textlink(following-sibling::tei:text[1])}">
                        <xsl:text>==></xsl:text>
                    </a>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <span class="unclear" title="unclear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <func:function name="mvn:textlink">
        <xsl:param name="text"/>
        <func:result>
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$text/@xml:id"/>
        </func:result>
    </func:function>
    
    <func:function name="mvn:textlinkid">
        <xsl:param name="text"/>
        <func:result>
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$text"/>
        </func:result>
    </func:function>
    
    <func:function name="mvn:linelink">
        <xsl:param name="page"/>
        <xsl:param name="line"/>
        <func:result>not implemented</func:result>
    </func:function>
    
    <func:function name="mvn:pagelink">
        <xsl:param name="page"/>
        <func:result>
            <xsl:text>#pb</xsl:text>
            <xsl:value-of select="$page/@n"/>
        </func:result>
    </func:function>
    
    <func:function name="mvn:pagelinkn">
        <xsl:param name="page"/>
        <func:result>
            <xsl:text>#pb</xsl:text>
            <xsl:value-of select="$page"/>
        </func:result>
    </func:function>
    
    <func:function name="mvn:wordlink">
        <xsl:param name="word"/>
        <func:result>not implemented</func:result>
    </func:function>
    
    <func:function name="mvn:letterlink">
        <xsl:param name="letter"/>
        <func:result>not implemented</func:result>
    </func:function>
    
    <func:function name="mvn:imagelink">
        <xsl:param name="n"/>
        <xsl:variable name="pageside" select="$n"/>
        <xsl:variable name="page" select="substring($pageside,1,string-length($pageside)-1)"/>
        <xsl:variable name="side" select="substring($pageside,string-length($pageside))"/>
        <xsl:variable name="pageformat" select="format-number($page,'000')"/>
        <xsl:variable name="pagesideformat" select="concat($pageformat,$side)"/>
            <func:result>not implemented</func:result>
    </func:function>
    
    <xsl:template match="tei:text|tei:group" mode="link">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mvn:textlink(.)"/>
            </xsl:attribute>
            <xsl:value-of select="@n"/>
        </a>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:pb" mode="link">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mvn:pagelink(.)"/>
            </xsl:attribute>
            <xsl:value-of select="@n"/>
        </a>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="text">
        <xsl:apply-templates mode="text"/>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="text">
        <xsl:apply-templates select="."/>
    </xsl:template>
    
</xsl:stylesheet>
