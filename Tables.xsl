<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"

exclude-result-prefixes="xs" version="1.0">

<xsl:template match="Table | TableBordered | TableSmall" mode="identity-translate">
    <table class="table">
      <xsl:if test="self::TableBordered">
        <xsl:attribute name="class">table table-bordered</xsl:attribute>
      </xsl:if>
      <xsl:if test="self::TableSmall">
        <xsl:attribute name="class">table table-sm</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*" mode="identity-translate"/>
      <xsl:if test="not(@id) and @name">
        <xsl:attribute name="id">
          <xsl:call-template name="helper.id">
            <xsl:with-param name="name" select="@name"/>
            <xsl:with-param name="name-prefix">table</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="HEAD | Head | BODY | Body | Caption" mode="identity-translate.tables"/>
      <xsl:apply-templates select="tbody | tr" mode="identity-translate"/>
      <!--      <xsl:apply-templates select="*[not(HEAD | Head | BODY | Body | TR | Tr | tr)]" mode="identity-translate"/>      -->
    </table>
  </xsl:template>

<xsl:template match="Caption" mode="identity-translate.tables">
    <caption class="caption-top fs-2">
      <xsl:apply-templates mode="identity-translate"/>
    </caption>
  </xsl:template>

<xsl:template match="caption" mode="identity-translate">
    <caption class="caption-top fs-2">
      <xsl:value-of select="."/>
    </caption>
  </xsl:template>

<xsl:template match="Head | HEAD" mode="identity-translate.tables">
    <thead>
      <tr>
        <xsl:apply-templates select="TD | Td | td | TH | Th | th" mode="identity-translate.tables"/>
      </tr>
    </thead>
  </xsl:template>

<xsl:template match="TBODY | Tbody | Body | BODY" mode="identity-translate.tables">
    <tbody>
      <xsl:apply-templates select="@*" mode="identity-translate"/>
      <xsl:apply-templates select="TR | Tr" mode="identity-translate.tables"/>
      <xsl:apply-templates select="*" mode="identity-translate"/>
      <xsl:if test="not(TR | Tr | tr)">
        <xsl:element name="tr"/>
      </xsl:if>
    </tbody>
  </xsl:template>

<xsl:template match="*" mode="identity-translate.tables">
    <xsl:apply-templates mode="identity-translate"/>
  </xsl:template>

<xsl:template match="TR | Tr" mode="identity-translate"/>

<xsl:template match="TR | Tr" mode="identity-translate.tables">
    <xsl:variable name="name" select="translate(local-name(), $ABC, $abc)"/>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*" mode="identity-translate"/>
      <xsl:apply-templates select="TD | Td | td | TH | Th | th" mode="identity-translate.tables"/>
    </xsl:element>
  </xsl:template>

<xsl:template match="TD | Td | td | TH | Th | th" mode="identity-translate.tables">
    <xsl:variable name="name" select="translate(local-name(), $ABC, $abc)"/>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*" mode="identity-translate"/>
      <xsl:apply-templates select="Data" mode="identity-translate.tables"/>
      <xsl:apply-templates select="node()" mode="identity-translate"/>
    </xsl:element>
  </xsl:template>

<xsl:template match="Data[ancestor::Table]" mode="identity-translate"/>

<xsl:template match="Data" mode="identity-translate.tables">
    <xsl:element name="span">
      <xsl:attribute name="class">data-field</xsl:attribute>
      <xsl:attribute name="data-field">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>