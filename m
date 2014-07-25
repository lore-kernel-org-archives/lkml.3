Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbaGYPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:34:46 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54651 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaGYPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:34:45 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCHv2] Staging: vt6655: remove redundant comments from card.h
Date: Fri, 25 Jul 2014 18:34:23 +0300
Message-Id: <1406302463-30850-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from card.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
v2 changes: fixed diffstat output and fixed the
   diff itself.

 drivers/staging/vt6655/card.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 829be92..443461d 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -32,7 +32,6 @@
 #include "ttype.h"
 #include <linux/types.h>
 
-/*---------------------  Export Definitions -------------------------*/
 //
 // Loopback mode
 //
@@ -48,7 +47,7 @@
 #define DEFAULT_MGN_LIFETIME_RES_64us   125  // 64us
 
 #define CB_MAX_CHANNEL_24G      14
-#define CB_MAX_CHANNEL_5G       42 //[20050104] add channel9(5045MHz), 41==>42
+#define CB_MAX_CHANNEL_5G       42
 #define CB_MAX_CHANNEL          (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
 
 typedef enum _CARD_PHY_TYPE {
@@ -78,12 +77,6 @@ typedef enum _CARD_OP_MODE {
 	OP_MODE_UNKNOWN
 } CARD_OP_MODE, *PCARD_OP_MODE;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void CARDvSetRSPINF(void *pDeviceHandler, CARD_PHY_TYPE ePHYType);
 void vUpdateIFS(void *pDeviceHandler);
 void CARDvUpdateBasicTopRate(void *pDeviceHandler);
@@ -101,7 +94,6 @@ unsigned char CARDbyGetPktType(void *pDeviceHandler);
 void CARDvSafeResetTx(void *pDeviceHandler);
 void CARDvSafeResetRx(void *pDeviceHandler);
 
-//xxx
 bool CARDbRadioPowerOff(void *pDeviceHandler);
 bool CARDbRadioPowerOn(void *pDeviceHandler);
 bool CARDbIsShortPreamble(void *pDeviceHandler);
-- 
1.7.9.5

