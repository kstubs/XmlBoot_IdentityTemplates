<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wbt="myWebTemplater.1.0" exclude-result-prefixes="xs wbt" version="1.0">

    <xsl:template match="Modal" mode="identity-translate">
        <div class="modal fade">
            <xsl:attribute name="id">
                <xsl:call-template name="helper.id">
                    <xsl:with-param name="name" select="@name"/>
                    <xsl:with-param name="leading-id-text" select="''"/>
                </xsl:call-template>
            </xsl:attribute>
            <div class="modal-dialog">
                <div class="modal-content">
                    <xsl:if test="@title">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <xsl:value-of select="@title"/>
                            </h5>
                        </div>
                    </xsl:if>
                    <div class="modal-body">
                        <xsl:apply-templates mode="identity-translate"/>
                    </div>
                    <div class="modal-footer">
                        <xsl:apply-templates select="WarningButton | WarningButtonOutline | 
                            SuccessButton | SuccessOutlineButton | 
                            SuccessButtonLG | SuccessOutlineButtonLG | 
                            DangerButton | DangerOutlineButton | 
                            PrimaryButton | PrimaryOutlineButton |
                            InfoButton | InfoButtonSmall | InfoOutlineButton |
                            SecondaryButton | SecondaryOutlineButton |
                            DarkButton | DarkOutlineButton" mode="identity-translate.buttongroup"/>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="Toggle" mode="identity-translate">
        <xsl:variable name="id">
            <xsl:call-template name="helper.id">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="leading-id-text" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <button type="button" class="btn btn-primary" data-toggle="collapse" data-target="{$id}">Info</button>
        <div id="{$id}" class="collapse">
            <xsl:apply-templates mode="identity-translate"/>
        </div>
    </xsl:template>

    <xsl:template mode="identity-translate"
        match="WarningButton[parent::Modal] | WarningButtonOutline[parent::Modal] | 
        SuccessButton[parent::Modal] | SuccessOutlineButton[parent::Modal] | 
        SuccessButtonLG[parent::Modal] | SuccessOutlineButtonLG[parent::Modal] | 
        DangerButton[parent::Modal] | DangerOutlineButton[parent::Modal] | 
        PrimaryButton[parent::Modal] | PrimaryOutlineButton[parent::Modal] |
        InfoButton[parent::Modal] | InfoButtonSmall[parent::Modal] | InfoOutlineButton[parent::Modal] |
        SecondaryButton[parent::Modal] | SecondaryOutlineButton[parent::Modal] |
        DarkButton[parent::Modal] | DarkOutlineButton[parent::Modal]"/>        
        
        
</xsl:stylesheet>