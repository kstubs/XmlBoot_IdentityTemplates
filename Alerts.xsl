<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    
    
    <xsl:variable name="ABC">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="abc">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    
    <xsl:template match="Primary | Secondary | Success | Danger | Alert | Warning | Info | Light | Dark" mode="identity-translate">
        <xsl:call-template name="alert">
            <xsl:with-param name="type" select="local-name()"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="alert">
        <xsl:param name="type">info</xsl:param>
        <xsl:param name="message"/>
        <xsl:variable name="type2">
            <xsl:choose>
                <xsl:when test="$type='Alert'">info</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate($type, $ABC, $abc)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div role="alert">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:attribute name="id">
            <xsl:choose>
                <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat('__alert_', generate-id())"/></xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>alert alert-</xsl:text>
                <xsl:value-of select="$type2"/>
                <xsl:if test="@class">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@class"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="$message"/>
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>