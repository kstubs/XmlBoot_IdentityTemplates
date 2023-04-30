<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:include href="Alerts.xsl"/>
    <xsl:include href="Buttons.xsl"/>
    <xsl:include href="Cards.xsl"/>
    <xsl:include href="Forms.xsl"/>
    <xsl:include href="Layout.xsl"/>
    <xsl:include href="Modal.xsl"/>
    <xsl:include href="Tables.xsl"/>
    <xsl:include href="Navs.xsl"/>
    <xsl:include href="FontAwesome.xsl"/>
    
    <xsl:template match="Dynamic" mode="identity-translate">
        <div>
            <xsl:attribute name="id">
                <xsl:call-template name="helper-dynamic.id">
                    <xsl:with-param name="name" select="@name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>dynamic </xsl:text>
                <xsl:apply-templates select="@class" mode="identity-translate"/>
            </xsl:attribute>
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>
    
    <xsl:template match="A | Link" mode="identity-translate">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="@link | @href">
                        <xsl:value-of select="@link | @href"/>                        
                    </xsl:when>
                    <xsl:when test="contains(., '|')">
                        <xsl:value-of select="substring-after(., '|')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:value-of select="@class"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(., '|')">
                    <xsl:value-of select="substring-before(., '|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@* " mode="identity-translate"/>
                    <xsl:attribute name="href"><xsl:value-of select="text()"/></xsl:attribute>                    
                    <xsl:apply-templates select="node()" mode="identity-translate"/>                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Lead" mode="identity-translate">
        <xsl:element name="p">
            <xsl:attribute name="class">
                <xsl:text>card-text lead</xsl:text>
                <xsl:value-of select="concat(' ', @class)"/>
            </xsl:attribute>
            <xsl:apply-templates mode="identity-translate"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Strong" mode="identity-translate">
        <xsl:element name="strong">
            <xsl:apply-templates select="node() | @*" mode="identity-translate"/>
        </xsl:element>        
    </xsl:template>
    
    <xsl:template match="ImgShadow" mode="identity-translate">
        <xsl:call-template name="img">
            <xsl:with-param name="shadow" select="true()"/>
        </xsl:call-template>
    </xsl:template>
    
        <xsl:template name="img" match="Img | Image" mode="identity-translate">
            <xsl:param name="shadow" select="false()"/>
        <xsl:param name="responsive"/>
        <xsl:choose>
            <xsl:when test="@link">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@link"/>
                    </xsl:attribute>
                    <xsl:call-template name="Img.Translate">
                        <xsl:with-param name="responsive" select="$responsive"/>
                        <xsl:with-param name="shadow" select="$shadow"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Img.Translate">
                    <xsl:with-param name="responsive" select="$responsive"/>
                        <xsl:with-param name="shadow" select="$shadow"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ImgLg    d-md-none d-lg-block -->
    <xsl:template match="ImgWeb | ImgMobile" mode="identity-translate">
        
        <xsl:choose>
            <xsl:when test="self::ImgWeb">
                <xsl:call-template name="img">
                    <xsl:with-param name="responsive">web</xsl:with-param>
                </xsl:call-template>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="img">
                    <xsl:with-param name="responsive">mobile</xsl:with-param>
                </xsl:call-template>                                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="Img.Translate">
        <xsl:param name="shadow" select="false()"/>
        <xsl:param name="responsive"/>
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="text()"/>
            </xsl:attribute>
            <xsl:variable name="class">
                <xsl:text>img-fluid</xsl:text>
                <xsl:value-of select="concat(' ', @class)"/>
                <xsl:if test="$responsive='web'">
                    <xsl:text>d-none d-lg-block</xsl:text>
                </xsl:if>
                <xsl:if test="$responsive='mobile'">
                    <xsl:text>d-lg-none</xsl:text>
                </xsl:if>
                <xsl:if test="$shadow">
                    <xsl:text> shadow</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            <xsl:apply-templates select="@*[local-name()!='class']" mode="identity-translate"></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="no-wrap" mode="identity-translate">
        <span class="nowrap">
            <xsl:apply-templates mode="identity-translate"></xsl:apply-templates>
        </span>
    </xsl:template>
    
    <xsl:template match="ChevronLeft2" mode="identity-translate">
        <i class="fa fa-angle-double-left"/>
    </xsl:template>
    
    <xsl:template name="ChevronLeft" match="ChevronRight" mode="identity-translate">
        <i class="fa fa-chevron-left"/>
    </xsl:template>
    
    <xsl:template match="ChevronRight2" mode="identity-translate">
        <i class="fa fa-angle-double-right"/>
    </xsl:template>
    
    <xsl:template name="ChevronRight" match="ChevronRight" mode="identity-translate">
        <i class="fa fa-chevron-right"/>
    </xsl:template>

    <xsl:template match="P" mode="identity-translate">
        <p>
            <xsl:attribute name="class">
                <xsl:text>p-1  mt-1 </xsl:text>
                <xsl:apply-templates select="@class"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(@class)] | node()" mode="identity-translate"/>
        </p>
    </xsl:template>
    
    <xsl:template match="Badge" mode="identity-translate">
        <div class="d-flex justify-content-end">
            <xsl:if test="@class">
                <xsl:text>d-flex justify-content-end </xsl:text>
                <xsl:value-of select="@class"/>
            </xsl:if>
            <xsl:apply-templates select="@*[local-name()!='class']" mode="identity-translate"/>
            <h3 class="badge bg-success">
                <xsl:apply-templates mode="identity-translate"/>
            </h3>            
        </div>
    </xsl:template>
    
    <xsl:template match="italic | Italic" mode="identity-translate">
        <span class="italic">
            <xsl:if test="@class">
                <xsl:text>italic </xsl:text>
                <xsl:value-of select="@class"/>
            </xsl:if>
            <xsl:apply-templates select="@*[not(@class)] | node()" mode="identity-translate"/>
        </span>
    </xsl:template>
    
    <xsl:template match="small | Small" mode="identity-translate">
        <span style="font-size: .7em">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:if test="@style">
                <xsl:text>font-size: .7em; </xsl:text>
                <xsl:value-of select="@style"/>
            </xsl:if>
            <xsl:apply-templates mode="identity-translate"/>
        </span>
    </xsl:template>
    
    <xsl:template name="helper.name">
        <xsl:choose>
            <xsl:when test="not(@name) and *">
                <xsl:value-of select="concat('genid__', generate-id())"/>
            </xsl:when>
            <xsl:when test="@name">
                <xsl:value-of select="@name"/>
            </xsl:when>
            <xsl:when test="contains(., '|')">
                <xsl:value-of select="substring-before(., '|')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="helper-dynamic.id">
        <xsl:param name="name"/>
        <xsl:variable name="node-name" select="local-name()"/>
        <xsl:variable name="count" select="count(preceding::node()[@name=$name] | 
            preceding::node()[local-name()=$node-name][substring-before(.,'|') = $name])"/>        
        <xsl:choose>
            <xsl:when test="$count &gt; 0">
                <xsl:value-of select="concat('__', translate($name, '-', '_'), $count)"/>                            
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('__', translate($name, '-', '_'))"/>                            
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="helper.id">
        <xsl:param name="name"/>
        <xsl:param name="name-prefix"/>
        <xsl:param name="leading-id-text">__</xsl:param>
        <xsl:variable name="node-name" select="local-name()"/>
        <xsl:variable name="count" select="
            count(preceding::node()[@name = $name][ancestor::client] |
            preceding::node()[local-name() = $node-name][substring-before(., '|') = $name][ancestor::client])"/>
        <xsl:variable name="name2">
            <xsl:choose>
                <xsl:when test="$name-prefix">
                    <xsl:value-of select="concat($name-prefix, '_', $name)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$count &gt; 0">
                <xsl:value-of select="concat($leading-id-text, translate($name2, '-', '_'), $count)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($leading-id-text, translate($name2, '-', '_'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>