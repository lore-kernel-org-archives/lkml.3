Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaJZQR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:17:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60476 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:17:58 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, cmroliv@gmail.com, gdonald@gmail.com,
        standby24x7@gmail.com, ninox@posteo.net, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: [PATCH 1/2] staging: rtl8723au: core: pointer issue
Date: Sun, 26 Oct 2014 16:17:46 +0000
Message-Id: <1414340266-4502-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "foo *	bar" should be "foo *bar"

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 9f6ce7d..c44051d 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -333,12 +333,12 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
 
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
@@ -641,7 +641,7 @@ Efuse_ReadAllMap(struct rtw_adapter *pAdapter, u8 efuseType, u8 *Efuse)
  *---------------------------------------------------------------------------*/
 static void
 efuse_ShadowRead1Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u8		*Value)
 {
@@ -653,7 +653,7 @@ efuse_ShadowRead1Byte(
 /* Read Two Bytes */
 static void
 efuse_ShadowRead2Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u16		*Value)
 {
@@ -666,7 +666,7 @@ efuse_ShadowRead2Byte(
 /* Read Four Bytes */
 static void
 efuse_ShadowRead4Byte(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u16		Offset,
 	u32		*Value)
 {
@@ -728,7 +728,7 @@ void EFUSE_ShadowMapUpdate23a(struct rtw_adapter *pAdapter, u8 efuseType)
  *---------------------------------------------------------------------------*/
 void
 EFUSE_ShadowRead23a(
-	struct rtw_adapter *	pAdapter,
+	struct rtw_adapter *pAdapter,
 	u8		Type,
 	u16		Offset,
 	u32		*Value)
-- 
1.9.1

