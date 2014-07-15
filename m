Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbaGOVYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:24:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62985 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGOVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:23:54 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 4/4] staging: vt6556: Cleanup coding style: indentation
Date: Tue, 15 Jul 2014 23:23:27 +0200
Message-Id: <1405459407-9311-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
References: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup the follwoing coding style issues:
 - indentation style
 - new line after declaration

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V4:
 - Splitted [PATCH V4 1/6] in 4 smaller patches

 drivers/staging/vt6656/main_usb.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d103df1..ba5c8a9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -62,7 +62,7 @@
 #include "int.h"
 
 /* static int msglevel = MSG_LEVEL_DEBUG; */
-static int          msglevel                =MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO;
 
 /*
  * define module options
@@ -177,13 +177,12 @@ static struct usb_device_id vt6656_table[] = {
 /* frequency list (map channels to frequencies) */
 /*
 static const long frequency_list[] = {
-    2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
-    4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
-    5035, 5040, 5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
-    5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680,
-    5700, 5745, 5765, 5785, 5805, 5825
-	};
-
+	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467,
+	2472, 2484, 4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980, 5035, 5040,
+	5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
+	5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640,
+	5660, 5680, 5700, 5745, 5765, 5785, 5805, 5825
+};
 */
 
 static int vt6656_probe(struct usb_interface *intf,
@@ -206,16 +205,16 @@ static void usb_device_reset(struct vnt_private *pDevice);
 
 static void
 device_set_options(struct vnt_private *pDevice) {
-    pDevice->cbTD = TX_DESC_DEF0;
-    pDevice->cbRD = RX_DESC_DEF0;
-    pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
-    pDevice->byLongRetryLimit = LONG_RETRY_DEF;
-    pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-    pDevice->byBBType = BBP_TYPE_DEF;
-    pDevice->byPacketType = pDevice->byBBType;
-    pDevice->byAutoFBCtrl = AUTO_FB_0;
-    pDevice->byPreambleType = 0;
-    pDevice->bExistSWNetAddr = false;
+	pDevice->cbTD = TX_DESC_DEF0;
+	pDevice->cbRD = RX_DESC_DEF0;
+	pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
+	pDevice->byLongRetryLimit = LONG_RETRY_DEF;
+	pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
+	pDevice->byBBType = BBP_TYPE_DEF;
+	pDevice->byPacketType = pDevice->byBBType;
+	pDevice->byAutoFBCtrl = AUTO_FB_0;
+	pDevice->byPreambleType = 0;
+	pDevice->bExistSWNetAddr = false;
 }
 
 /*
@@ -837,6 +836,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		u32 changed)
 {
 	struct vnt_private *priv = hw->priv;
+
 	priv->current_aid = conf->aid;
 
 	if (changed & BSS_CHANGED_BSSID)
-- 
1.9.3

