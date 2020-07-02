<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:repo="http://exist-db.org/xquery/repo"
    xmlns:col-config="http://exist-db.org/collection-config/1.0"
    
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="app-name" select="''"/>
    <xsl:param name="git-commit-id" select="''"/>
    <xsl:param name="git-commit-time" select="''"/>
    <xsl:param name="path" select="''"/>
    
    <xsl:variable name="xars" select="doc('xar.properties.xml')"/>
    
    <!-- BUILD.XML -->
    <xsl:template match="project" mode="ant-build-xml">
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() != 'name']"/>
            <xsl:attribute name="name" select="$app-name"/>
            <xsl:apply-templates select="node()" mode="ant-build-xml"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="ant-build-xml">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="ant-build-xml"/>
        </xsl:copy>
    </xsl:template>

    <!-- BUILD.PROPERTIES.XML -->
    <xsl:template match="name" mode="ant-build-properties">
        <xsl:copy>
            <xsl:value-of select="$xars//app[./name=$app-name]/name" />
        </xsl:copy>        
    </xsl:template>
    
    <xsl:template match="url" mode="ant-build-properties">
        <xsl:copy>
            <xsl:value-of select="$xars//app[./name=$app-name]/url" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="title" mode="ant-build-properties">
        <xsl:copy>
            <xsl:value-of select="$xars//app[./name=$app-name]/title" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="version" mode="ant-build-properties">
        <xsl:copy>
            <xsl:value-of select="$xars//app[./name=$app-name]/version" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="ant-build-properties">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="ant-build-properties"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- REPO.XML -->
    <xsl:template match="repo:meta" mode="ant-repo-xml">
        <xsl:copy>
            <xsl:attribute name="commit-id" select="$git-commit-id"/>
            <xsl:attribute name="commit-time" select="$git-commit-time"/>
            <xsl:apply-templates select="@* | node()" mode="ant-repo-xml"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="repo:description" mode="ant-repo-xml">
        <xsl:copy>
            <xsl:value-of select="$xars//app[./name=$app-name]/title" />
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="repo:target" mode="ant-repo-xml">
        <xsl:copy>
            <xsl:value-of select="$app-name" />
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="@* | node()" mode="ant-repo-xml">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="ant-repo-xml"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- COLLECTION.XCONF-->
    <xsl:template match="col-config:collection" mode="collection-xconf">
        <xsl:message>col-config:collection: <xsl:value-of select="$path"/></xsl:message>
        <xsl:for-each select="$xars//app[./name=$app-name]/col-config:index">
            <xsl:variable name="filename" select="if(exists(@name)) then (@name) else ('collection.xconf')"/>
            <xsl:result-document href="../{$path}/{$filename}" 
                exclude-result-prefixes="#all"
                indent="1">
                <collection xmlns="http://exist-db.org/collection-config/1.0">
                    <index>
                        <xsl:copy-of select="@*[local-name()  != 'name']" />
                        <xsl:copy-of select="*"/>
                    </index> 
                </collection>
            </xsl:result-document>            
        </xsl:for-each>
    </xsl:template>    
    
    <xsl:template match="@* | node()" mode="collection-xconf">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="collection-xconf"/>
        </xsl:copy>
    </xsl:template>    
        
</xsl:stylesheet>