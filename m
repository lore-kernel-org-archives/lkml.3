Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922AbaLPJNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:13:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46013 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaLPJNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:13:33 -0500
Date: Tue, 16 Dec 2014 11:13:23 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, ninox@posteo.net, tapaswenipathak@gmail.com,
        gdonald@gmail.com, cmroliv@gmail.com, asaf.vertz@tandemg.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: fixing "foo * bar" should be
 "foo *bar"
Message-ID: <20141216091323.GA28072@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, "foo * bar" should be "foo *bar"

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 81960e7..0e64d12 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -328,12 +328,12 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
 
 void
 EFUSE_Write1Byte(
-	struct rtw_adapter *	Adapter,
+	struct rtw_adapter *Adapter,
 	u16		Address,
 	u8		Value);
 void
 EFUSE_Write1Byte(
-	struct rtw_adapter *	Adapter,
+	struct rtw_adapter *Adapter,
 	u16		Address,
 	u8		Value)
 {
@@ -636,7 +636,7 @@ Efuse_ReadAllMap(struct rtw_adapter *pAdapter, u8 efuseType, u8 *Efuse)
  *---------------------------------------------------------------------------*/
 static void
 efuse_ShadowRead1Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u8		*Value)
 {
@@ -648,7 +648,7 @@ efuse_ShadowRead1Byte(
 /* Read Two Bytes */
 static void
 efuse_ShadowRead2Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u16		*Value)
 {
@@ -661,7 +661,7 @@ efuse_ShadowRead2Byte(
 /* Read Four Bytes */
 static void
 efuse_ShadowRead4Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u32		*Value)
 {
@@ -723,7 +723,7 @@ void EFUSE_ShadowMapUpdate23a(struct rtw_adapter *pAdapter, u8 efuseType)
  *---------------------------------------------------------------------------*/
 void
 EFUSE_ShadowRead23a(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u8		Type,
 	u16		Offset,
 	u32		*Value)
-- 
1.7.0.4

