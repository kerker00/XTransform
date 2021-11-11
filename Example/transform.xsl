<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
  <h2>My Stuff</h2>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th>What</th>
      <th>Color</th>
    </tr>
    <xsl:for-each select="//ROOM/ITEM">
    <tr>
      <td><xsl:value-of select="@type"/></td>
      <td><xsl:value-of select="COLOUR"/></td>
    </tr>
    </xsl:for-each>
  </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>