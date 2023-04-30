<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wbt="myWebTemplater.1.0" 
    exclude-result-prefixes="xs wbt"    
    version="1.0">
    
    <xsl:variable name="layout-ABC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="layout-abc" select="'abcdefghijklmnopqrstuvwxyz'"/>
    
    <xsl:template match="Row" mode="identity-translate">
        <div class="row">
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    <xsl:template match="Container" mode="identity-translate">
        <div class="container">
            <xsl:if test="not(@id)">
                <xsl:attribute name="id">__container</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    <xsl:template match="ContainerFluid" mode="identity-translate">
        <div class="container-fluid">
            <xsl:if test="not(@id)">
                <xsl:attribute name="id">__container</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="RowCentered" mode="identity-translate">
        <div class="row">
            <xsl:if test="@class">
                <xsl:attribute name="class">
                    <xsl:text>row </xsl:text>
                    <xsl:value-of select="@class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*[local-name()!='class']" mode="identity-translate"/>
            <xsl:call-template name="Centered"/>
        </div>    
    </xsl:template>
    
    <xsl:template match="Row | Row1 | Row1 | Row2 | Row3 | Row4 | Row5 | Row6 | Row7 | Row8 | Row9 | Row10 | Row11 | Row12" mode="identity-translate">
        <div>
            <xsl:attribute name="class">
                <xsl:text>row</xsl:text>
                <xsl:value-of select="concat(' ', @class)"/>                
            </xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class']" mode="identity-translate"/>
            <xsl:choose>
                <xsl:when test="local-name()='Row'">
                    <xsl:apply-templates mode="identity-translate"/>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="col" select="concat('Col', substring(local-name(), 4))"/>
                    <xsl:call-template name="Col">
                        <xsl:with-param name="local-name" select="$col"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template name="Col" match="Col | Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12" mode="identity-translate">
        <xsl:param name="local-name" select="local-name()"/>
        <xsl:param name="unit">
            <xsl:choose>
                <xsl:when test="@unit">
                    <xsl:value-of select="@unit"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>md</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <div>
            <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="$local-name='Col'">
                    <xsl:text>col</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('col-', $unit, '-', substring($local-name, 4))"/>
                </xsl:otherwise>
            </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@offset">
                        <xsl:value-of select="concat(' ', 'offset-', @offset)"/>
                    </xsl:when>
                    <xsl:when test="@offset-lg">
                        <xsl:value-of select="concat(' ', 'offset-lg-', @offset-lg)"/>
                    </xsl:when>
                    <xsl:when test="@offset-md">
                        <xsl:value-of select="concat(' ', 'offset-md-', @offset-md)"/>
                    </xsl:when>
                    <xsl:when test="@offset-sm">
                        <xsl:value-of select="concat(' ', 'offset-sm-', @offset-sm)"/>
                    </xsl:when>
                </xsl:choose>
                <!-- avoid duplicating class names from Row, Row1.. node type -->
                <xsl:if test="not(starts-with(local-name(), 'Row'))">
                    <xsl:value-of select="concat(' ', @class)"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class'][not(parent::node()[starts-with(local-name(), 'Row')])] | node()" mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="@offset | @offset-sm | @offset-md | @offset-lg" mode="identity-translate"/>
    
    <xsl:template match="Container" mode="identity-translate">
        <div class="container">
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template name="Centered" match="Centered" mode="identity-translate">
        <div>
            <xsl:attribute name="class">
                <xsl:text>col-md-6 offset-md-3 </xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="NoWrap" mode="identity-translate">
        <span class="nowrap"><xsl:apply-templates mode="identity-translate"/></span>
    </xsl:template>
    
    <xsl:template match="TabContent" mode="identity-translate">
        <div id="tab_content">
            <div class="tab-content">
                <xsl:apply-templates mode="identity-translate"/>
            </div>
        </div>    
    </xsl:template>
    
    <xsl:template match="TabPane" mode="identity-translate">
        <xsl:variable name="id" select="translate(translate(@name, $layout-ABC, $layout-abc), ' ', '_')"/>
        <div class="tab-pane fade" id="{$id}" role="tabpanel">
            <xsl:apply-templates mode="identity-translate"/>            
        </div>
    </xsl:template>
    <xsl:template match="TabLink" mode="identity-translate"/>
    
    <xsl:template match="Dynamic" mode="identity-translate">
        <xsl:element name="div">
            <xsl:attribute name="class">dynamic</xsl:attribute>
            <xsl:apply-templates mode="identity-translate"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="CenterText" mode="identity-translate">
        <div>
            <xsl:attribute name="class">
                <xsl:text>text-center</xsl:text>
                <xsl:value-of select="concat(' ', @class)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class'] | node()" mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="InlineEnd" mode="identity-translate">
        <span class="float-end">
                <xsl:value-of select="concat(' ', @class)"/>
            <xsl:apply-templates select="@*[local-name()!='class'] | node()" mode="identity-translate"/>
        </span>
    </xsl:template>
    
    <xsl:template match="End" mode="identity-translate">
        <div class="d-flex">
            <xsl:attribute name="class">
                <xsl:text>d-flex justify-content-end</xsl:text>
                <xsl:value-of select="concat(' ', @class)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class'] | node()" mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="Display1 | Display2 | Display3 | Display4 | Display5 | Display6" mode="identity-translate">
        <div>
        <xsl:attribute name="class">
            <xsl:value-of select="concat('display-', substring(local-name(), 8, 1))"/>
            <xsl:text>  p-3</xsl:text>
            <xsl:value-of select="concat(' ', @class)"/>
        </xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class'] | node()" mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template name="clear" match="Clear | clear" mode="identity-translate">
        <div class="clearfix"></div>
    </xsl:template>
</xsl:stylesheet>