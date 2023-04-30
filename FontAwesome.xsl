<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wbt="myWebTemplater.1.0" 
    exclude-result-prefixes="xs wbt"
    version="1.0">

    <xsl:template match="Fa | Fa2x | Fa3x | Fa4x" mode="identity-translate">
        <xsl:variable name="class">
            <xsl:text>fa fa-</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:choose>
                <xsl:when test="self::Fa2x">
                    <xsl:text> fa-2x</xsl:text>
                </xsl:when>
                <xsl:when test="self::Fa3x">
                    <xsl:text> fa-3x</xsl:text>
                </xsl:when>
                <xsl:when test="self::Fa4x">
                    <xsl:text> fa-4x</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@class">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@class"/>
            </xsl:if>
        </xsl:variable>
        <i class="{$class}"/>
    </xsl:template>
    
    <xsl:template match="ChevronLeft2" mode="identity-translate">
        <i class="fa fa-angle-double-left"/>
    </xsl:template>
    
    <xsl:template name="ChevronLeft" match="ChevronLeft" mode="identity-translate">
        <i class="fa fa-chevron-left"/>
    </xsl:template>
    
    <xsl:template match="ChevronRight2" mode="identity-translate">
        <i class="fa fa-angle-double-right"/>
    </xsl:template>
    
    <xsl:template name="ChevronRight" match="ChevronRight" mode="identity-translate">
        <i class="fa fa-chevron-right"/>
    </xsl:template>
    
    
</xsl:stylesheet>