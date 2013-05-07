Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3EGGEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:04:24 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39697 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3EGGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:04:23 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] of/base: fix typos
Date: Tue,  7 May 2013 11:34:11 +0530
Message-Id: <1367906651-5058-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

the function of_property_read_u8/16/32_array() has a parameter
out_values, but the description mentioned it as out_value. This
patch fixes this typo.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/of/base.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..418985f 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -750,7 +750,7 @@ EXPORT_SYMBOL(of_find_node_by_phandle);
  *
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
- * @out_value:	pointer to return value, modified only if return value is 0.
+ * @out_values:	pointer to return value, modified only if return value is 0.
  * @sz:		number of array elements to read
  *
  * Search for a property in a device node and read 8-bit value(s) from
@@ -761,7 +761,7 @@ EXPORT_SYMBOL(of_find_node_by_phandle);
  * dts entry of array should be like:
  *	property = /bits/ 8 <0x50 0x60 0x70>;
  *
- * The out_value is modified only if a valid u8 value can be decoded.
+ * The out_values is modified only if a valid u8 value can be decoded.
  */
 int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz)
@@ -788,7 +788,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u8_array);
  *
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
- * @out_value:	pointer to return value, modified only if return value is 0.
+ * @out_values:	pointer to return value, modified only if return value is 0.
  * @sz:		number of array elements to read
  *
  * Search for a property in a device node and read 16-bit value(s) from
@@ -799,7 +799,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u8_array);
  * dts entry of array should be like:
  *	property = /bits/ 16 <0x5000 0x6000 0x7000>;
  *
- * The out_value is modified only if a valid u16 value can be decoded.
+ * The out_values is modified only if a valid u16 value can be decoded.
  */
 int of_property_read_u16_array(const struct device_node *np,
 			const char *propname, u16 *out_values, size_t sz)
@@ -827,7 +827,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u16_array);
  *
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
- * @out_value:	pointer to return value, modified only if return value is 0.
+ * @out_values:	pointer to return value, modified only if return value is 0.
  * @sz:		number of array elements to read
  *
  * Search for a property in a device node and read 32-bit value(s) from
@@ -835,7 +835,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u16_array);
  * -ENODATA if property does not have a value, and -EOVERFLOW if the
  * property data isn't large enough.
  *
- * The out_value is modified only if a valid u32 value can be decoded.
+ * The out_values is modified only if a valid u32 value can be decoded.
  */
 int of_property_read_u32_array(const struct device_node *np,
 			       const char *propname, u32 *out_values,
-- 
1.7.4.1

