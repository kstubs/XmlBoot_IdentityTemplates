<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wbt="myWebTemplater.1.0" 
    exclude-result-prefixes="xs wbt"
    version="1.0">

    <xsl:template match="Card | CardPrimary | CardShadow | CardSecondary | CardSuccess | CardDanger | CardWarning | CardInfo | CardLight | CardDark | CardDarkOutline" mode="identity-translate">
        <div>
            <xsl:attribute name="class">
                <xsl:text>card </xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:choose>
                    <xsl:when test="self::CardDark">
                        <xsl:text> card text-white bg-dark </xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardDarkOutline">
                        <xsl:text> card text-white bg-dark  border-white</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardLight">
                        <xsl:text> card text-dark bg-light</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardInfo">
                        <xsl:text> card text-white bg-dangercard text-dark bg-info</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardWarning">
                        <xsl:text> card text-white bg-dangercard text-dark bg-warning</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardDanger">
                        <xsl:text> card text-white bg-danger</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardSuccess">
                        <xsl:text> card text-white bg-success</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardSecondary">
                        <xsl:text> card text-white bg-secondary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardPrimary">
                        <xsl:text> card text-white bg-primary </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="self::CardShadow | Shadow">
                    <xsl:text> shadow</xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="self::CardSecondary">
                        <xsl:text> bg-secondary</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardSuccess">
                        <xsl:text> bg-success</xsl:text>
                        <xsl:text> text-white</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardDanger">
                        <xsl:text> bg-danger</xsl:text>
                        <xsl:text> text-white</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardWarning">
                        <xsl:text> bg-warning</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardInfo">
                        <xsl:text> bg-info</xsl:text>
                        <xsl:text> text-white</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardLight">
                        <xsl:text> bg-light</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::CardDark">
                        <xsl:text> bg-dark</xsl:text>
                        <xsl:text> text-white</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>            
            <xsl:apply-templates select="@*[not(local-name()='class')]" mode="identity-translate"/>
            <xsl:variable name="card-img" select="*[1][self::Img]"/>
            <xsl:if test="$card-img">
                <img src="{$card-img}" class="card-img-top"/>
            </xsl:if>
            <div class="card-body">
                <xsl:variable name="title" select="TitleXLG | TitleXL | TitleLG | Title"/>
                <xsl:variable name="titlex" select="SubTitle | TitleX"/>
                <xsl:if test="$title or $titlex">
                    <xsl:variable name="title-elm">
                        <xsl:choose>
                            <xsl:when test="TitleXL">h1</xsl:when>
                            <xsl:when test="TitleXLG">h1</xsl:when>
                            <xsl:when test="TitleLG">h3</xsl:when>
                            <xsl:otherwise>h5</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <div>
                        <xsl:if test="$titlex">
                            <xsl:attribute name="class">border-bottom border-2 mb-3</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$title or $titlex">
                            <xsl:element name="{$title-elm}">
                                <xsl:attribute name="class">card-title</xsl:attribute>
                                <xsl:if test="$title/@class">
                                    <xsl:attribute name="class">
                                        <xsl:text>card-title </xsl:text>
                                        <xsl:value-of select="$title/@class"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates select="$title/node()" mode="identity-translate"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$titlex">
                            <h6 class="card-subtitle mb-2">
                                <xsl:apply-templates select="$titlex/node()" mode="identity-translate"/>
                            </h6>
                        </xsl:if>
                    </div>
                </xsl:if>
                <xsl:apply-templates select="Text" mode="identity-translate.cards"/>
                <xsl:apply-templates select="Section" mode="identity-translate.cards"/>
                <xsl:apply-templates select="*[not(generate-id(.)=generate-id($card-img))]" mode="identity-translate"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="Title | TitleX | TitleXLG | TitleXL | TitleLG | SubTitle | Text" mode="identity-translate"/>
    
    <xsl:template match="Section"  mode="identity-translate"/>
    <xsl:template match="Section" mode="identity-translate.cards">
        <div>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:when test="@name">
                        <xsl:value-of select="concat('__section_', translate(@name, '-', '_'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('__section_', generate-id())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="Text" mode="identity-translate.cards"/>
            <xsl:apply-templates select="Section" mode="identity-translate.cards"/>
            <xsl:apply-templates mode="identity-translate"/>
        </div>    
    </xsl:template>
    
    <xsl:template match="Text" mode="identity-translate.cards">
        <p class="card-text">
            <xsl:apply-templates select="@* | node()" mode="identity-translate"/>
        </p>
    </xsl:template>
    
    
</xsl:stylesheet>