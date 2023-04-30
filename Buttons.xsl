<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wbt="myWebTemplater.1.0" 
    exclude-result-prefixes="xs wbt"
    version="1.0">


<!--
        
 Button Containers
 
    <ButtonGroup/>
    <ButtonGroupJustify/>
    <ButtonGroupEnd/>
    <ButtonGroupRight/>
    <ButtonGroupLarge/>
    <ButtonGroupLargeJustify/>
    <ButtonGroupSDmallJustify/>
    <ButtonGroupVertical/>
    <ButtonToolbar/>
    
 
 Buttons
 
    <WarningButton/>
    <SuccessButton/>
    <DangerButton/>
    <PrimaryButton/>
    <InfoButton/>
    <WarningButton/>
    <SecondaryButton/>
    <DarkButton/>
    
    Add Outline to buttons above for outline effect 
 -->
    
    <xsl:template match="ButtonToolbar | ButtonToolbarEnd | ButtonToolbarRight |
                        ButtonToolbarSmall | ButtonToolbarSmallEnd | ButtonToolbarSmallRight" mode="identity-translate">
        <xsl:variable name="class">
            <xsl:text>btn-toolbar</xsl:text>
            <xsl:choose>
                <xsl:when test="self::ButtonToolbarEnd or self::ButtonToolbarSmallEnd">
                    <xsl:text>btn-toolbar float-end</xsl:text>
                </xsl:when>
                <xsl:when test="self::ButtonToolbarRight or self::ButtonToolbarSmallRight">
                    <xsl:text>btn-toolbar float-end</xsl:text>
                </xsl:when>                    
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="class2">
            <xsl:text>btn-group</xsl:text>
            <xsl:choose>
                <xsl:when test="self::ButtonToolbarSmall">
                    <xsl:text> btn-group-sm</xsl:text>
                </xsl:when>
                <xsl:when test="self::ButtonToolbarSmallEnd">
                    <xsl:text> btn-group-sm</xsl:text>
                </xsl:when>
                <xsl:when test="self::ButtonToolbarSmallRight">
                    <xsl:text> btn-group-sm</xsl:text>
                </xsl:when>                    
            </xsl:choose>            
        </xsl:variable>
        
        <div role="toolbar" class="{$class}">
            <div class="{$class2}">
                <xsl:apply-templates mode="identity-translate.buttongroup"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="ButtonGroup" mode="identity-translate"
    match="ButtonGroup | ButtonGroupJustify | ButtonGroupCenter|ButtonGroupEnd | ButtonGroupRight |
                ButtonGroupLarge | ButtonGroupLargeJustify |
                ButtonGroupSmall | ButtonGroupSmallJustify | ButtonGroupVertical |
                    ButtonGroupResponsive">
        <div role="group">
            <xsl:variable name="class">
                <xsl:text>mt-2 </xsl:text>
                <xsl:choose>
                    <xsl:when test="self::ButtonGroupEnd">
                        <xsl:text>btn-group float-end</xsl:text>                    
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupLarge">
                        <xsl:text>btn-group btn-group-lg</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupLargeJustify">
                        <xsl:text>btn-group btn-group-lg d-flex</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupSmall">
                        <xsl:text>btn-group btn-group-sm</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupSmallJustify">
                        <xsl:text>btn-group btn-group-sm d-flex</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupResponsive">
                        <xsl:text>d-grid gap-2 d-lg-flex justify-content-center</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupJustify">
                        <xsl:text> d-flex gap-2 justify-content-between</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupCenter">
                        <xsl:text> d-flex gap-2 justify-content-center</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonGroupVertical">
                        <xsl:text>btn-group-vertical</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::ButtonToolbar">
                        <xsl:text>btn-toolbar</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> btn-group</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
                <xsl:value-of select="concat(' ', @class)"/>
            </xsl:variable>
            <xsl:attribute name="class">
                <xsl:value-of select="$class"/>
            </xsl:attribute>
            <xsl:apply-templates mode="identity-translate.buttongroup"/>
        </div>
    </xsl:template>
    
    <xsl:template match="ButtonBlock" mode="identity-translate">
        <div class="d-grid gap-2">
            <xsl:apply-templates mode="identity-translate.buttongroup"/>
        </div>    
    </xsl:template>
    
    <xsl:template match="@class" mode="identity-translate.buttongroup"/>
    
    <xsl:template match="@link" mode="identity-translate">
        <xsl:attribute name="href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template name="getButtonHtmlTag">
        <xsl:choose>
            <xsl:when test="self::a">
                <xsl:text>a</xsl:text>
            </xsl:when>
            <xsl:when test="not(starts-with(@href, '#'))">
                <xsl:text>a</xsl:text>
            </xsl:when>
            <xsl:otherwise>button</xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template match="a | button | Button" mode="identity-translate.buttongroup">
        <xsl:variable name="element-tag">
            <xsl:call-template name="getButtonHtmlTag"/>
        </xsl:variable>
        <xsl:element name="{$element-tag}">
            <xsl:if test="$element-tag = 'button'">
                <xsl:attribute name="type">button</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:call-template name="identity-translate.make-link"/>
            <xsl:attribute name="class">btn btn-primary <xsl:value-of select="@class"/></xsl:attribute>
            <xsl:apply-templates mode="identity-translate.buttongroup"/>
            <xsl:apply-templates select="*" mode="identity-translate"/>
        </xsl:element>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>
    
    <xsl:template match="BackButton | ButtonBack | BackButtonInline" mode="identity-translate.buttongroup">
        <xsl:apply-templates select="." mode="identity-translate"/>
    </xsl:template>
    
    <xsl:template match="BackButton | ButtonBack | BackButtonInline" mode="identity-translate">
        <a class="btn btn-secondary back-button" href="#back">
            <xsl:if test="self::BackButtonInline">
                <xsl:attribute name="class">btn back-button</xsl:attribute>
            </xsl:if>
            <xsl:if test="@href">
                <xsl:attribute name="href">
                    <xsl:value-of select="@href"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@target">
                <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>            
            <xsl:variable name="name">
                <xsl:choose>
                    <xsl:when test="@name">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>back_button</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="id">
                <xsl:call-template name="helper-buttons.id">
                    <xsl:with-param name="name" select="$name"/>
                    <xsl:with-param name="id" select="@id"/>
                </xsl:call-template>
            </xsl:attribute>
            <i class="fa fa-chevron-left"/> 
            <xsl:if test="not(self::BackButtonInline)">
                <span> Back</span>                
            </xsl:if>
        </a>
    </xsl:template>

    <xsl:template match="NextButton" mode="identity-translate">
        <a role="button" href="#next" class="btn btn-secondary"><span class="nowrap">Next</span></a>
    </xsl:template>
    
    <xsl:template mode="identity-translate"
        match="WarningButton | WarningButtonOutline | 
        SuccessButton | SuccessOutlineButton | 
        SuccessButtonLG | SuccessOutlineButtonLG | 
        DangerButton | DangerOutlineButton | 
        PrimaryButton | PrimaryOutlineButton |
        InfoButton | InfoButtonSmall | InfoOutlineButton |
        SecondaryButton | SecondaryOutlineButton |
        DarkButton | DarkOutlineButton">        
        <xsl:apply-templates select="." mode="identity-translate.buttongroup"/>    
    </xsl:template>
    
    <xsl:template mode="identity-translate.buttongroup"
        match="WarningButton | WarningOutlineButton | 
        SuccessButton | SuccessOutlineButton | SuccessButtonSmall |
        SuccessButtonLG | SuccessOutlineButtonLG | 
        DangerButton | DangerOutlineButton | 
        PrimaryButton | PrimaryOutlineButton |
        InfoButton | InfoButtonSmall | InfoOutlineButton |
        SecondaryButton | SecondaryOutlineButton |
        DarkButton | DarkOutlineButton">        
        <xsl:variable name="element-tag">
            <xsl:call-template name="getButtonHtmlTag"/>
        </xsl:variable>
        <xsl:element name="{$element-tag}">
            <xsl:if test="$element-tag='button'">
                <xsl:attribute name="role">button</xsl:attribute>                
            </xsl:if>
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:call-template name="identity-translate.make-link"/>
            <xsl:variable name="name">
                <xsl:choose>
                    <xsl:when test="@name">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="id">
                <xsl:call-template name="helper-buttons.id">
                    <xsl:with-param name="name" select="$name"/>
                    <xsl:with-param name="id" select="@id"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:variable name="class">
                <xsl:text>btn </xsl:text>
                <xsl:choose>
                    <xsl:when test="self::WarningButton">
                        <xsl:text>btn-warning</xsl:text>                        
                    </xsl:when>
                    <xsl:when test="self::WarningOutlineButton">
                        <xsl:text>btn-outline-warning</xsl:text>                        
                    </xsl:when>
                    <xsl:when test="self::DangerButton">
                        <xsl:text>btn-danger</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::DangerOutlineButton">
                        <xsl:text>btn-outline-danger</xsl:text>                        
                    </xsl:when>
                    <xsl:when test="self::SuccessButton | self::SuccessButtonSmall | self::SuccessButtonLG">
                        <xsl:text>btn-success</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::SuccessOutlineButton | self::SuccessOutlineButtonLG">
                        <xsl:text>btn-outline-success</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::PrimaryButton">
                        <xsl:text>btn-primary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::PrimaryOutlineButton">
                        <xsl:text>btn-outline-primary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::InfoButton">
                        <xsl:text>btn-info</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::InfoButtonSmall">
                        <xsl:text>btn-info btn-sm</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::InfoOutlineButton">
                        <xsl:text>btn-outline-info</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::SecondaryButton">
                        <xsl:text>btn-secondary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::SecondaryOutlineButton">
                        <xsl:text>btn-outline-secondary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::DarkButton">
                        <xsl:text>btn-dark</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::DarkOutlineButton">
                        <xsl:text>btn-outline-dark</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="substring(local-name(), string-length(local-name()) -1) = 'LG'">
                    <xsl:text> btn-lg</xsl:text>
                </xsl:if>
                <xsl:if test="@class">
                    <xsl:value-of select="concat(' ', @class)"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@query-value=key('wbt:key_QueryVars', ancestor::ButtonGroup/@query)">
                        <xsl:text> active</xsl:text>
                    </xsl:when>
                    <xsl:when test="not(key('wbt:key_QueryVars', ancestor::ButtonGroup/@query)) and ancestor::ButtonGroup/@query and position()=1">
                        <xsl:text> active</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="class">
                <xsl:value-of select="$class"/>
            </xsl:attribute>
            <xsl:if test="@target">
                <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>
            <span class="nowrap">
                <xsl:if test="@Wrap='ok'">
                    <xsl:attribute name="style">white-space:normal</xsl:attribute>
                </xsl:if>
                <xsl:apply-templates select="node()" mode="identity-translate.buttongroup"/>
            </span>
            <xsl:apply-templates select="*" mode="identity-translate"/>
        </xsl:element>
        <xsl:text>&#13;</xsl:text>        
    </xsl:template>
    
    <xsl:template match="Fa" mode="identity-translate.buttongroup"/>
    <xsl:template match="text()" mode="identity-translate.buttongroup">
        <xsl:choose>
            <xsl:when test="contains(.,'|')">
                <xsl:value-of select="substring-before(., '|')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ancestor::node()/@target='_blank'">
            <i class="fa fa-external-link ms-1"/>   
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="identity-translate.make-link">
        <xsl:choose>
            <xsl:when test="substring-after(text(), '|')">
                <xsl:attribute name="href">
                    <xsl:value-of select="substring-after(text(), '|')"/>
                </xsl:attribute>                
            </xsl:when>
            <xsl:when test="ancestor::ButtonGroup/@query and @query-value">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('?', ancestor::ButtonGroup/@query, '=', @query-value)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="@query-value">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('?query=', @query-value)"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="helper-buttons.id">
        <xsl:param name="name"/>
        <xsl:param name="id"/>
        <xsl:variable name="node-name" select="local-name()"/>
        <xsl:variable name="count" select="count(preceding::node()[@name=$name] | 
            preceding::node()[local-name()=$node-name][substring-before(.,'|') = $name])"/>        
        <xsl:choose>
            <xsl:when test="$id">
                <xsl:value-of select="$id"/>
            </xsl:when>
            <xsl:when test="$count &gt; 0">
                <xsl:value-of select="concat('__', translate($name, '-', '_'), $count)"/>                            
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('__', translate($name, '-', '_'))"/>                            
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
</xsl:stylesheet>