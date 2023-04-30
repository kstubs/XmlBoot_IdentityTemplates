<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wbt="myWebTemplater.1.0" exclude-result-prefixes="xs wbt" version="1.0">
    <!--
    <Form/>
    <FormPost/>
    <FormHorizontalPost/>
    <FormHorizontal/>
    <FormInline/>
    <FormInlinePost/>

-->

    <xsl:template match="FormPost | Form | FormHorizontalPost | FormHorizontal | FormInline | FormInlinePost" mode="identity-translate">
        <xsl:variable name="layout">
            <xsl:call-template name="helper.get-layout"/>
        </xsl:variable>
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="not(@id) and starts-with(@name, 'form')">
                    <xsl:call-template name="helper.id">
                        <xsl:with-param name="name" select="@name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="not(@id) and (@name or Name)">
                    <xsl:call-template name="helper.id">
                        <xsl:with-param name="name" select="@name | Name"/>
                        <xsl:with-param name="name-prefix">form</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@id"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="form">
            <xsl:attribute name="id">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <xsl:attribute name="method">
                <xsl:choose>
                    <xsl:when test="local-name() = 'FormPost' or local-name() = 'FormHorizontalPost'">
                        <xsl:text>POST</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>GET</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="Name">
                <xsl:attribute name="name">
                    <xsl:value-of select="Name"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="Action">
                <xsl:attribute name="action">
                    <xsl:value-of select="Action"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:if test="not(@id) and @name">
                <xsl:attribute name="id">
                    <xsl:choose>
                        <xsl:when test="starts-with(@name, 'form')">
                            <xsl:value-of select="concat('__', translate(@name, '-', '_'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('__form_', translate(@name, '-', '_'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>border border-2 rounded p-3 bg-light text-dark</xsl:text>
                <xsl:if test="@class">
                    <xsl:value-of select="concat(' ', @class)"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$layout = 'inline'">
                        <xsl:text> row gy-2 gx-3 align-items-center</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@autocomplete = 'off' and not(input[@autocomplete])">
                <input type="hidden" autocomplete="false"/>
            </xsl:if>
            <xsl:if test="Title">
                <h5 class="p-2 bg-primary text-white">
                    <xsl:apply-templates select="Title/* | Title/node()" mode="identity-translate">
                        <xsl:with-param name="stack">FormPost | Form | FormHorizontalPost | FormHorizontal | FormInline | FormInlinePost</xsl:with-param>
                    </xsl:apply-templates>
                </h5>
            </xsl:if>
            <xsl:if test="TitleX | Titlex">
                <h6 class="p-2 text-dark">
                    <xsl:attribute name="id">
                        <xsl:call-template name="helper.id">
                            <xsl:with-param name="name" select="Titlex/@name | TitleX/@name"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:apply-templates select="TitleX/* | Titlex/* | TitleX/node() | Titlex/node()" mode="identity-translate"/>
                </h6>
            </xsl:if>
            <xsl:apply-templates select="*" mode="identity-translate.forms">
                <xsl:with-param name="layout" select="$layout"> </xsl:with-param>
            </xsl:apply-templates>
            <xsl:call-template name="button-submit">
                <xsl:with-param name="layout" select="$layout"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ButtonSubmit | SubmitButton | ButtonBack | ButtonCancel" mode="identity-translate.forms"/>

    <xsl:template name="button-submit">
        <xsl:param name="layout"/>
        <xsl:if test="not(@hide-submit = 'true') or ButtonCancel or ButtonDismiss or ButtonBack">
            <div class="mt-3 d-flex flex-row-reverse">
                <xsl:if test="not(@hide-submit = 'true')">
                    <xsl:choose>
                        <xsl:when test="ButtonSubmit or SubmitButton">
                            <xsl:apply-templates select="ButtonSubmit | SubmitButton" mode="identity-translate.forms-buttons">
                                <xsl:with-param name="layout" select="$layout"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <button type="submit" class="btn btn-primary m-1">Submit Form</button>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="ButtonCancel">
                    <button type="button" href="#cancel" class="btn btn-warning m-1"><i class="fa fa-times"/> Cancel</button>
                </xsl:if>
                <xsl:if test="ButtonDismiss">
                    <button type="button" class="btn btn-secondary m-1" data-bs-dismiss="modal"><i class="fa fa-times"/> Close</button>
                </xsl:if>
                <xsl:if test="ButtonBack">
                    <button type="button" href="#back" class="btn btn-secondary m-1"><i class="fa fa-chevron-left me-1"/> Back</button>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ButtonSubmit | SubmitButton" mode="identity-translate.forms-buttons">
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:otherwise>submit-button</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <button type="submit" class="btn btn-primary m-1">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:attribute name="name">
                <xsl:value-of select="$name"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:call-template name="helper.id">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="text()">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Submit Form</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </button>
    </xsl:template>

    <xsl:template match="ButtonDismiss | ButtonCancel | ButtonSubmit" mode="identity-translate.forms"/>

    <xsl:template match="Name | Action | Title | TitleX | Titlex" mode="identity-translate.forms"/>

    <xsl:template match="Label[not(ancestor::FormPost | ancestor::Form | ancestor::FormHorizontalPost | ancestor::FormHorizontal | ancestor::FormInline | ancestor::FormInlinePost)]" mode="identity-translate">
        <xsl:param name="layout">
            <xsl:call-template name="helper.get-layout"/>
        </xsl:param>
        <xsl:call-template name="wbt:comment">
            <xsl:with-param name="comment">Label [identity-translate] forms.xsl</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="." mode="identity-translate.forms">
            <xsl:with-param name="style" select="@style"/>
            <xsl:with-param name="layout" select="$layout"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="Label" mode="identity-translate.forms">
        <xsl:param name="style"/>
        <xsl:param name="layout"/>
        <xsl:call-template name="wbt:comment">
            <xsl:with-param name="comment">Label [identity-translate.forms] forms.xsl --> style=<xsl:value-of select="$style"/>; layout=<xsl:value-of select="$layout"/></xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="ancestor" select="ancestor::FormPost | ancestor::Form | ancestor::FormHorizontalPost | ancestor::FormHorizontal | ancestor::FormInline | ancestor::FormInlinePost"/>
        <xsl:choose>
            <xsl:when test="$style = 'input-group'">
                <xsl:element name="label">
                    <xsl:attribute name="class">
                        <xsl:text>input-group-text bold</xsl:text>
                        <xsl:if test="@col">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@col"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="for">
                        <xsl:value-of select="@for | following-sibling::*[1]/@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()" mode="identity-translate"/>                                            
                </xsl:element>
                <xsl:if test="not($style = 'input-group')">
                    <xsl:apply-templates select="following-sibling::Input[1]" mode="identity-translate.forms">
                        <xsl:with-param name="style" select="$style"/>
                        <xsl:with-param name="layout" select="false()"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$layout = 'horizontal'">
                <div class="row mb-3">
                    <xsl:if test="$ancestor[@row-class]">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$ancestor/@row-class"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:element name="label">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="@col">
                                    <xsl:value-of select="concat('col-sm-', @col)"/>
                                    <xsl:text> col-form-label bold</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>col-sm-3 col-form-label bold</xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="@align = 'right'">
                                    <xsl:text> text-sm-end</xsl:text>
                                </xsl:when>
                                <xsl:when test="@align = 'center'">
                                    <xsl:text> text-sm-center</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="for">
                            <xsl:value-of select="@for | following-sibling::*[1]/@name"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="node()" mode="identity-translate"/>                                            
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="@col">
                                    <xsl:variable name="col" select="12 - @col"/>
                                    <xsl:value-of select="concat('col-sm-', $col)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>col-sm-9</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:variable name="following" select="following-sibling::Input[1] | following-sibling::Select[1]"/>
                        <xsl:apply-templates select="$following" mode="identity-translate.forms">
                            <xsl:with-param name="layout" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="label">
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="$layout = 'inline'">form-label bold p-2</xsl:when>
                            <xsl:otherwise>form-label bold mt-1</xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="@class">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@class"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="for">
                        <xsl:value-of select="@for | following-sibling::*[1]/@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()" mode="identity-translate"/>                                            
                </xsl:element>
                <xsl:if test="following-sibling::*[1][self::Range]">
                    <xsl:element name="span">
                        <xsl:attribute name="class">badge rounded-pill bg-dark float-end mt-2</xsl:attribute>
                        <xsl:text>Total: </xsl:text>
                        <xsl:choose>
                            <xsl:when test="following-sibling::*[1][local-name() = 'Range'][@value]">
                                <xsl:value-of select="following-sibling::Range/@value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Text" mode="identity-translate"/>

    <xsl:template match="Text" mode="identity-translate.forms">
        <xsl:param name="layout"/>
        <xsl:variable name="class">
            <xsl:text>form-text</xsl:text>
            <xsl:if test="@class">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@class"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="not($layout = 'horizontal')">
            <div class="{$class}">
                <xsl:apply-templates select="@*[local-name() != 'class']" mode="identity-translate"/>
                <xsl:apply-templates mode="identity-translate">
                    <xsl:with-param name="stack">Text [identity-translate.forms] Form.xsl</xsl:with-param>
                </xsl:apply-templates>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="Help" mode="identity-translate"/>
    <xsl:template match="Help" mode="identity-translate.forms"/>
    <xsl:template match="Help" mode="identity-translate.forms.help">
        <div class="form-text text-50-dark">
            <xsl:apply-templates mode="identity-translate">
                <xsl:with-param name="stack">Help [identity-translate.forms.help] Form.xsl</xsl:with-param>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="Range" name="range-forms" mode="identity-translate.forms">
        <xsl:param name="layout-horizontal"/>
        <xsl:param name="name">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(local-name(), 'R', 'r')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>

        <xsl:variable name="class">mb-1 p-1</xsl:variable>
        <div class="{$class} range-wrapper">
            <xsl:element name="input">
                <xsl:attribute name="name">
                    <xsl:value-of select="$name"/>
                </xsl:attribute>
                <xsl:if test="not(@id)">
                    <xsl:attribute name="id">
                        <xsl:call-template name="helper.id">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="class">form-range</xsl:attribute>
                <xsl:attribute name="type">range</xsl:attribute>
                <xsl:attribute name="min">
                    <xsl:value-of select="substring-before(., ',')"/>
                </xsl:attribute>
                <xsl:attribute name="max">
                    <xsl:value-of select="substring-after(., ',')"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="@value">
                            <xsl:value-of select="@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
        </div>
    </xsl:template>

    <xsl:template match="Input | Password | InputEmail | InputDate | InputWebsite | InputPhone | ReadOnly | TextArea" name="input-forms" mode="identity-translate.forms">
        <xsl:param name="style"/>
        <xsl:param name="layout"/>
        <xsl:param name="name">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="contains(text(), '|')">
                    <xsl:value-of select="substring-before(text(), '|')"/>
                </xsl:when>
                <xsl:when test="text()">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(local-name(), 'IP', 'ip')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="input-add-on" select="self::InputEmail | self::InputDate | self::InputWebsite | self::InputPhone"/>

        <xsl:choose>
            <xsl:when test="$style = 'input-group'">
                <xsl:call-template name="make-input">
                    <xsl:with-param name="name" select="$name"/>
                    <xsl:with-param name="style" select="$style"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$input-add-on">
                <div class="mb-1 p-1 input-group">
                    <xsl:choose>
                        <xsl:when test="$input-add-on/self::InputEmail">
                            <span class="input-group-text">@</span>
                        </xsl:when>
                        <xsl:when test="$input-add-on/self::InputDate">
                            <span class="input-group-text"><i class="fa fa-calendar"/></span>
                        </xsl:when>
                        <xsl:when test="$input-add-on/self::InputWebsite">
                            <span class="input-group-text"><i class="fa fa-link"/></span>
                        </xsl:when>
                        <xsl:when test="$input-add-on/self::InputPhone">
                            <span class="input-group-text"><i class="fa fa-phone"/></span>
                        </xsl:when>                        
                    </xsl:choose>
                    <xsl:call-template name="make-input">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="style" select="$style"/>
                        <xsl:with-param name="ignore-help-text" select="true()"/>
                    </xsl:call-template>
                </div>
                <xsl:apply-templates select="following-sibling::*[1][local-name() = 'Help']" mode="identity-translate.forms.help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="class">
                    <xsl:text>mb-1 p-1</xsl:text>
                    <xsl:if test="self::InputEmail">
                        <xsl:text> validate-email</xsl:text>
                    </xsl:if>
                </xsl:variable>
                <div class="{$class}">
                    <xsl:if test="not($layout = 'horizontal')">
                        <xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'AddOn']" mode="identity-translate.forms.addon">
                            <xsl:with-param name="for">
                                <xsl:value-of select="$name"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                        <xsl:if test="@addon">
                            <xsl:attribute name="class">
                                <xsl:value-of select="concat($class, ' input-group')"/>
                            </xsl:attribute>
                            <xsl:call-template name="addon">
                                <xsl:with-param name="value" select="@addon"/>
                                <xsl:with-param name="for" select="$name"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="local-name() = 'InputEmail'">
                            <xsl:attribute name="class">
                                <xsl:value-of select="concat($class, ' input-group')"/>
                            </xsl:attribute>
                            <span class="input-group-text">@</span>
                        </xsl:if>
                        <xsl:if test="local-name() = 'InputWebsite'">
                            <xsl:attribute name="class">
                                <xsl:value-of select="concat($class, ' input-group')"/>
                            </xsl:attribute>
                            <span class="input-group-text">
                                <i class="fa fa-link"/>
                            </span>
                        </xsl:if>
                        <xsl:if test="local-name() = 'InputPhone'">
                            <xsl:attribute name="class">
                                <xsl:value-of select="concat($class, ' input-group')"/>
                            </xsl:attribute>
                            <span class="input-group-text">
                                <i class="fa fa-phone"/>
                            </span>
                        </xsl:if>
                        <xsl:call-template name="make-input">
                            <xsl:with-param name="name" select="$name"/>
                            <xsl:with-param name="style" select="$style"/>
                        </xsl:call-template>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="make-input">
        <xsl:param name="name">
            <xsl:choose>
                <xsl:when test="self::Password and not(@name)">
                    <xsl:text>password</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputEmail and not(@name)">
                    <xsl:text>email</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputDate and not(@name)">
                    <xsl:text>date</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputPhone and not(@name)">
                    <xsl:text>phone</xsl:text>
                </xsl:when>
                <xsl:when test="self::TextArea and not(@name)">
                    <xsl:text>textarea</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        <xsl:param name="style"/>
        <xsl:param name="ignore-help-text" select="false()"/>
        <xsl:variable name="placeholder">
            <xsl:choose>
                <xsl:when test="self::Password and not(@placeholder)">
                    <xsl:text>*********</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputEmail and not(@placeholder)">
                    <xsl:text>youremail@somemail.com</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputDate and not(@placeholder)">
                    <xsl:text>YYYY/MM/DD</xsl:text>
                </xsl:when>
                <xsl:when test="self::InputPhone and not(@name)">
                    <xsl:text>999-999-9999</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@placeholder"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="self::TextArea">
                <textarea name="{$name}" class="form-control"/>
            </xsl:when>
            <xsl:otherwise>
                <input type="text" name="{$name}">
                    <xsl:apply-templates select="@*[local-name(.)!='required']" mode="identity-translate"/>
                    <xsl:attribute name="class">
                        <xsl:text>form-control</xsl:text>
                        <xsl:if test="@class">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@class"/>
                        </xsl:if>
                        <xsl:if test="@required='true'">
                            <xsl:text> required</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="self::InputEmail">
                                <xsl:text> validate-email</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::InputDate">
                                <xsl:text> date-control validate-date</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::InputWebsite">
                                <xsl:text> validate-url</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="not(@id)">
                        <xsl:attribute name="id">
                            <xsl:choose>
                                <xsl:when test="not(@id) and @name">
                                    <xsl:call-template name="helper.id">
                                        <xsl:with-param name="name" select="@name"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="form" select="ancestor-or-self::FormPost | ancestor-or-self::Form | ancestor-or-self::FormHorizontalPost | ancestor-or-self::FormHorizontal | ancestor-or-self::FormInline | ancestor-or-self::FormInlinePost"/>
                    <xsl:if test="$form/@autocomplete">
                        <xsl:attribute name="autocomplete">
                            <xsl:value-of select="$form/@autocomplete"/>
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:choose>
                        <xsl:when test="self::Password">
                            <xsl:attribute name="type">password</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="self::InputEmail">
                            <xsl:attribute name="type">email</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="self::ReadOnly">
                            <xsl:attribute name="aria-label">
                                <xsl:text>readonly input </xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="string($placeholder)">
                        <xsl:attribute name="placeholder">
                            <xsl:value-of select="$placeholder"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="wbt:input-value">
                        <xsl:with-param name="default-value">
                            <xsl:choose>
                                <xsl:when test="@value">
                                    <xsl:value-of select="@value"/>
                                </xsl:when>
                                <xsl:when test="contains(text(), '|')">
                                    <xsl:value-of select="substring-after(text(), '|')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </input>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not($style='input-group') and not($ignore-help-text)">
            <xsl:apply-templates select="following-sibling::*[1][local-name() = 'Help']" mode="identity-translate.forms.help"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="Hidden" mode="identity-translate.forms">
        <xsl:variable name="name">
            <xsl:call-template name="helper.name"/>
        </xsl:variable>
        <xsl:variable name="value">
            <xsl:call-template name="helper.value">
                <xsl:with-param name="name" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <input type="hidden" name="{$name}">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="not(@id) and @name">
                        <xsl:call-template name="helper.id">
                            <xsl:with-param name="name" select="@name"/>
                            <xsl:with-param name="name-prefix">hidden</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@wbt:query_lookup">
                    <xsl:call-template name="wbt:input-value">
                        <xsl:with-param name="default-value">
                            <xsl:choose>
                                <xsl:when test="@value">
                                    <xsl:value-of select="@value"/>
                                </xsl:when>
                                <xsl:when test="contains(text(), '|')">
                                    <xsl:value-of select="substring-after(text(), '|')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="value">
                        <xsl:call-template name="helper.value">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </input>
    </xsl:template>

    <xsl:template match="AddOn" mode="identity-translate.forms">
        <xsl:call-template name="addon"/>
    </xsl:template>
    
    <xsl:template name="addon" match="AddOn" mode="identity-translate.forms.addon">
        <xsl:param name="value" select="text()"/>
        <xsl:param name="for" select="@for | ../*/@name"/>
        <span class="input-group-text" for="{$for}">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:value-of select="$value"/>
        </span>
    </xsl:template>

    <xsl:template match="*" mode="identity-translate.forms">
        <xsl:apply-templates select="." mode="identity-translate">
            <xsl:with-param name="stack">* [identity-translate.forms] Forms.xsl</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="CheckBoxGroup" mode="identity-translate">
        <div class="btn-group" role="group" aria-label="Basic checkbox toggle button group">
            <xsl:if test="@class">
                <xsl:attribute name="class">
                    <xsl:text>btn-group </xsl:text>
                    <xsl:value-of select="@class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="identity-translate.forms">
                <xsl:with-param name="style">input-group</xsl:with-param>
                <xsl:with-param name="layout">
                    <xsl:call-template name="helper.get-layout"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="InputGroup" mode="identity-translate">
        <div class="input-group" role="group">
            <xsl:if test="@class">
                <xsl:attribute name="class">
                    <xsl:text>input-group </xsl:text>
                    <xsl:value-of select="@class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="*" mode="identity-translate.forms">
                <xsl:with-param name="style">input-group</xsl:with-param>
                <xsl:with-param name="layout">
                    <xsl:call-template name="helper.get-layout"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="CheckBox[not(parent::CheckBoxGroup)] | CheckBoxSmall[not(parent::CheckBoxGroup)]" mode="identity-translate">
        <xsl:call-template name="CheckBox"/>
    </xsl:template>

    <xsl:template name="CheckBox" match="CheckBox | CheckBoxSmall" mode="identity-translate.forms">
        <xsl:variable name="name" select="substring-before(., '|')"/>
        <xsl:variable name="value" select="substring-after(., '|')"/>
        <xsl:variable name="id">
            <xsl:call-template name="helper.id">
                <xsl:with-param name="name" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:choose>
                <xsl:when test="@label">
                    <xsl:value-of select="@label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <input type="checkbox" class="btn-check" id="{$id}" name="{$name}" value="{$value}" autocomplete="off"/>
        <label class="btn btn-outline-primary" for="{$id}">
            <xsl:value-of select="$label"/>
        </label>
    </xsl:template>

    <xsl:template match="Select[not(ancestor::FormPost | ancestor::Form | ancestor::FormHorizontalPost | ancestor::FormHorizontal | ancestor::FormInline | ancestor::FormInlinePost)]" mode="identity-translate">
        <xsl:call-template name="wbt:comment">
            <xsl:with-param name="comment">Select[not(ancestor::FormPost | ancestor::Form | ancestor::FormHorizontalPost | ancestor::FormHorizontal | ancestor::FormInline | ancestor::FormInlinePost)]</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="." mode="identity-translate.forms">
            <xsl:with-param name="layout">
                <xsl:call-template name="helper.get-layout"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="Select" mode="identity-translate.forms">
        <xsl:param name="layout"/>
        <xsl:variable name="name" select="@name"/>
        <xsl:call-template name="wbt:comment">
            <xsl:with-param name="comment">Select [identity-translate.forms] forms.xsl -> layout=<xsl:value-of select="$layout"/></xsl:with-param>
        </xsl:call-template>
        <xsl:if test="not($layout = 'horizontal')">
            <xsl:call-template name="wbt:comment">
                <xsl:with-param name="comment">Select [identity-translate.forms] not($layout = 'horizontal')</xsl:with-param>
            </xsl:call-template>
            <div class="input-group mb-1 p1">
                <xsl:if test="@title">
                    <lable class="input-group-text" for="{$name}">
                        <xsl:value-of select="@title"/>
                    </lable>
                </xsl:if>
                <select>
                    <xsl:attribute name="class">
                        <xsl:text>form-select</xsl:text>
                        <xsl:if test="@class">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@class"/>
                        </xsl:if>
                        <xsl:if test="@required='true'">
                            <xsl:text> </xsl:text>
                            <xsl:text> validate-selection</xsl:text>
                        </xsl:if>                    
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[local-name()!='class']" mode="identity-translate"/>
                    <xsl:attribute name="id">
                        <xsl:call-template name="helper.id">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:if test="not(@no-choose-option = 'true')">
                        <option selected="selected" disabled="disabled">Choose...</option>
                    </xsl:if>
                    <xsl:apply-templates mode="identity-translate">
                        <xsl:with-param name="stack">Select [identity-translate.forms] Forms.xsl</xsl:with-param>
                    </xsl:apply-templates>
                </select>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="Switch | SwitchEnd" mode="identity-translate.forms">
        <xsl:variable name="name">
            <xsl:call-template name="helper.name"/>
        </xsl:variable>
        <xsl:variable name="value">
            <xsl:value-of select="substring-before(., '|')"/>
        </xsl:variable>
        <xsl:variable name="id">
            <xsl:call-template name="helper.id">
                <xsl:with-param name="name" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <div class="form-check form-switch">
            <xsl:if test="self::SwitchEnd">
                <xsl:attribute name="class">form-check form-switch float-end</xsl:attribute>
            </xsl:if>
                <input name="{$name}" id="{$id}" value="{$value}" class="form-check-input" type="checkbox" role="switch"/>
                <label class="form-check-label" for="flexSwitchCheckDefault"><xsl:value-of select="substring-after(., '|')"/></label>
        </div>
    </xsl:template>
    
    <xsl:template match="Radio" mode="identity-translate.forms">
        <xsl:for-each select="Option">
            <div class="form-check">
                <xsl:apply-templates select="." mode="identity-translate.forms">
                    <xsl:with-param name="is-buttons" select="false()"/>
                </xsl:apply-templates>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="RadioHorizontal" mode="identity-translate.forms">
        <xsl:for-each select="Option">
            <div class="form-check form-check-inline">
                <xsl:apply-templates select="." mode="identity-translate.forms">
                    <xsl:with-param name="is-buttons" select="false()"/>
                </xsl:apply-templates>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="OptionDivider" mode="identity-translate">
        <option disabled="disabled">__________________</option>
    </xsl:template>
    
    <xsl:template match="OptionBoxGroup | OptionBoxGroupEnd" mode="identity-translate.forms">
        <div class="d-flex gap-1 option-group">
            <xsl:if test="local-name() = 'OptionBoxGroupEnd'">
                <xsl:attribute name="class">
                    <xsl:text>d-flex gap-1 option-group justify-content-end</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="identity-translate.forms"/>
        </div>
    </xsl:template>

    <xsl:template match="Option[not(parent::Radio) and not(parent::Select)]" mode="identity-translate">
        <div class="form-check">
            <xsl:call-template name="Option">
                <xsl:with-param name="is-buttons" select="false()"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <xsl:template match="Option" name="Option" mode="identity-translate.forms">
        <xsl:param name="is-buttons" select="true()"/>
        <xsl:variable name="name" select="substring-before(., '|')"/>
        <xsl:variable name="id">
            <xsl:call-template name="helper.id">
                <xsl:with-param name="name" select="$name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="@value">
                    <xsl:value-of select="@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., '|')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:choose>
                <xsl:when test="@label">
                    <xsl:value-of select="@label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., '|')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="temp-buttons"><xsl:value-of select="$is-buttons"/></xsl:attribute>
            <xsl:attribute name="class">
                <xsl:if test="@class">
                    <xsl:value-of select="@class"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$is-buttons">
                        <xsl:text>btn-check</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>form-check-input</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:value-of select="$name"/>
            </xsl:attribute>
            <xsl:attribute name="value">
                <xsl:value-of select="$value"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[local-name(.)!='class']" mode="identity-translate"/>
        </xsl:element>
        <xsl:element name="label">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$is-buttons">
                        <xsl:text>btn btn-secondary </xsl:text>
                        <xsl:value-of select="@class"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>form-check-label</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="for">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <xsl:value-of select="$label"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="Div" mode="identity-translate.forms">
        <xsl:variable name="id">
            <xsl:call-template name="helper.id">
                <xsl:with-param name="name" select="@name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:apply-templates select="@*[not(@name)]" mode="identity-translate"/>
            <xsl:attribute name="id">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <xsl:apply-templates mode="identity-translate"/>
            <xsl:apply-templates mode="identity-translate.forms"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="helper.value">
        <xsl:param name="name" select="@name"/>
        <xsl:choose>
            <xsl:when test="@value">
                <xsl:value-of select="@value"/>
            </xsl:when>
            <xsl:when test="string(substring-after(., '|'))">
                <xsl:value-of select="substring-after(., '|')"/>
            </xsl:when>
            <xsl:when test="@name and string(.)">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="key('wbt:key_FormVars', $name) | key('wbt:key_QueryVars', $name)"/>
                <xsl:apply-templates select="*" mode="identity-translate"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="helper.get-layout">
        <xsl:variable name="form" select="ancestor-or-self::FormPost | ancestor-or-self::Form | ancestor-or-self::FormHorizontalPost | ancestor-or-self::FormHorizontal | ancestor-or-self::FormInline | ancestor-or-self::FormInlinePost"/>
        <xsl:choose>
            <xsl:when test="not($form)">
                <xsl:value-of select="@layout"/>
            </xsl:when>
            <xsl:when test="local-name($form) = 'FormHorizontalPost' or local-name() = 'FormHorizontal'">
                <xsl:text>horizontal</xsl:text>
            </xsl:when>
            <xsl:when test="local-name($form) = 'FormInline' or local-name() = 'FormInlinePost'">
                <xsl:text>inline</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ClearButtonsEffect" mode="identity-translate">
        <style type="text/css">
            .form-group.position-relative input {
                padding-right: 32px;
            }
            .form-clear {
                align-items: center;
                border-radius: 50%;
                bottom: 8px;
                color: rgba(0, 0, 0, .54);
                cursor: pointer;
                display: flex;
                height: 24px;
                justify-content: center;
                position: absolute;
                right: 0;
                width: 24px;
                z-index: 10;
            }
            .form-text + .form-clear {
                bottom: calc(1rem + 18px);
            }
            .form-clear .fa-x {
                font-size: 16px;
                font-weight: 500;
            }</style>
        <script>
            document.observe('dom:loaded', function() {
                var funcFocus = function(e) {
                    var elm = e.findElement();
                    if ($(elm).getValue().length > 0 &amp;&amp; $(elm).next('.form-clear')) {
                        $(elm).next('.form-clear').removeClassName('d-none');
                    }
                    return true;
                };
                var funcBlur = function(e) {
                    var elm = e.findElement();
                    if ($(elm).getValue().length === 0 &amp;&amp; $(elm).next('.form-clear')) {
                        $(elm).next('.form-clear').addClassName('d-none');
                    }        
                    return true;
                };
                var funcClear = function(e) {
                    var elm = e.findElement('.form-clear');
                    $(elm).addClassName('d-none');
                    if($(elm).previous(':input'))
                        $(elm).previous(':input').setValue('').focus();
                        document.fire('forms:input-cleared', $(elm).previous(':input'));
                }
                $$('.position-relative :input').each(function(elm) {
                    $(elm).on('keydown', funcFocus);
                    $(elm).on('focus', funcFocus);
                    $(elm).on('blur', funcBlur);
                });
                $$('.form-clear').each(function(elm) {
                    $(elm).on('click', funcClear); 
                });
            });
        </script>
    </xsl:template>
    
    <xsl:template match="Section" mode="identity-translate.forms">
        <xsl:param name="layout"/>
        <xsl:variable name="name">
            <xsl:call-template name="helper.name"/>
        </xsl:variable>
        <xsl:element name="div">
            <xsl:apply-templates select="@*" mode="identity-translate"/>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="helper.id">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*" mode="identity-translate.forms">
                <xsl:with-param name="layout" select="$layout"/>
            </xsl:apply-templates>
            <xsl:if test="ButtonSubmit">
                <xsl:call-template name="button-submit">
                    <xsl:with-param name="layout" select="$layout"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
