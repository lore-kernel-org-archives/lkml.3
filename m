Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3BAJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:47:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62270 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3BAJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:47:10 -0500
From: Garrick He <garrickhe@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Garrick He <ghe@calpoly.edu>, Garrick He <garrickhe@gmail.com>
Subject: [PATCH] Staging: wlan-ng: Fix tab coding style issue in hfa384x.h
Date: Fri,  1 Feb 2013 01:45:16 -0800
Message-Id: <1359711916-29259-1-git-send-email-garrickhe@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Garrick He <ghe@calpoly.edu>

Fix all 'please, no space before tabs' warning found by checkpatch.pl

Signed-off-by: Garrick He <garrickhe@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 5631ad0..04c0433 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -81,8 +81,8 @@
 #define		HFA384x_WEPFLAGS_EXCLUDE		((u16)BIT(1))
 #define		HFA384x_WEPFLAGS_DISABLE_TXCRYPT	((u16)BIT(4))
 #define		HFA384x_WEPFLAGS_DISABLE_RXCRYPT	((u16)BIT(7))
-#define 	HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
-#define 	HFA384x_PORTSTATUS_DISABLED		((u16)1)
+#define		HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
+#define		HFA384x_PORTSTATUS_DISABLED		((u16)1)
 #define		HFA384x_RATEBIT_1			((u16)1)
 #define		HFA384x_RATEBIT_2			((u16)2)
 #define		HFA384x_RATEBIT_5dot5			((u16)4)
@@ -164,7 +164,7 @@
 #define		HFA384x_CMDCODE_DOWNLD		((u16)0x22)
 
 /*--- Debugging Commands -----------------------------*/
-#define 	HFA384x_CMDCODE_MONITOR		((u16)(0x38))
+#define		HFA384x_CMDCODE_MONITOR		((u16)(0x38))
 #define		HFA384x_MONITOR_ENABLE		((u16)(0x0b))
 #define		HFA384x_MONITOR_DISABLE		((u16)(0x0f))
 
@@ -275,15 +275,15 @@ API ENHANCEMENTS (NOT ALREADY IMPLEMENTED)
 #define		HFA384x_RID_CNFAUTHENTICATION	((u16)0xFC2A)
 #define		HFA384x_RID_CNFROAMINGMODE	((u16)0xFC2D)
 #define		HFA384x_RID_CNFAPBCNint		((u16)0xFC33)
-#define		HFA384x_RID_CNFDBMADJUST  	((u16)0xFC46)
-#define		HFA384x_RID_CNFWPADATA       	((u16)0xFC48)
+#define		HFA384x_RID_CNFDBMADJUST	((u16)0xFC46)
+#define		HFA384x_RID_CNFWPADATA		((u16)0xFC48)
 #define		HFA384x_RID_CNFBASICRATES	((u16)0xFCB3)
 #define		HFA384x_RID_CNFSUPPRATES	((u16)0xFCB4)
 #define		HFA384x_RID_CNFPASSIVESCANCTRL	((u16)0xFCBA)
-#define		HFA384x_RID_TXPOWERMAX        	((u16)0xFCBE)
+#define		HFA384x_RID_TXPOWERMAX		((u16)0xFCBE)
 #define		HFA384x_RID_JOINREQUEST		((u16)0xFCE2)
 #define		HFA384x_RID_AUTHENTICATESTA	((u16)0xFCE3)
-#define		HFA384x_RID_HOSTSCAN          	((u16)0xFCE5)
+#define		HFA384x_RID_HOSTSCAN		((u16)0xFCE5)
 
 #define		HFA384x_RID_CNFWEPDEFAULTKEY_LEN	((u16)6)
 #define		HFA384x_RID_CNFWEP128DEFAULTKEY_LEN	((u16)14)
@@ -311,7 +311,7 @@ PD Record codes
 #define HFA384x_PDR_HFA3861_IFRF	((u16)0x0204)
 #define HFA384x_PDR_HFA3861_CHCALSP	((u16)0x0300)
 #define HFA384x_PDR_HFA3861_CHCALI	((u16)0x0301)
-#define HFA384x_PDR_MAX_TX_POWER  	((u16)0x0302)
+#define HFA384x_PDR_MAX_TX_POWER	((u16)0x0302)
 #define HFA384x_PDR_MASTER_CHAN_LIST	((u16)0x0303)
 #define HFA384x_PDR_3842_NIC_CONFIG	((u16)0x0400)
 #define HFA384x_PDR_USB_ID		((u16)0x0401)
@@ -322,10 +322,10 @@ PD Record codes
 #define HFA384x_PDR_USB_POWER_TYPE      ((u16)0x0407)
 #define HFA384x_PDR_USB_MAX_POWER	((u16)0x0409)
 #define HFA384x_PDR_USB_MANUFACTURER	((u16)0x0410)
-#define HFA384x_PDR_USB_PRODUCT  	((u16)0x0411)
-#define HFA384x_PDR_ANT_DIVERSITY   	((u16)0x0412)
-#define HFA384x_PDR_HFO_DELAY       	((u16)0x0413)
-#define HFA384x_PDR_SCALE_THRESH 	((u16)0x0414)
+#define HFA384x_PDR_USB_PRODUCT		((u16)0x0411)
+#define HFA384x_PDR_ANT_DIVERSITY	((u16)0x0412)
+#define HFA384x_PDR_HFO_DELAY		((u16)0x0413)
+#define HFA384x_PDR_SCALE_THRESH	((u16)0x0414)
 
 #define HFA384x_PDR_HFA3861_MANF_TESTSP	((u16)0x0900)
 #define HFA384x_PDR_HFA3861_MANF_TESTI	((u16)0x0901)
@@ -383,7 +383,7 @@ typedef struct hfa384x_caplevel {
 /*-- Configuration Record: cnfAuthentication --*/
 #define HFA384x_CNFAUTHENTICATION_OPENSYSTEM	0x0001
 #define HFA384x_CNFAUTHENTICATION_SHAREDKEY	0x0002
-#define HFA384x_CNFAUTHENTICATION_LEAP     	0x0004
+#define HFA384x_CNFAUTHENTICATION_LEAP		0x0004
 
 /*--------------------------------------------------------------------
 Configuration Record Structures:
@@ -575,8 +575,8 @@ Information Types
 #define		HFA384x_IT_AUTHREQ			((u16)0xF202UL)
 #define		HFA384x_IT_PSUSERCNT			((u16)0xF203UL)
 #define		HFA384x_IT_KEYIDCHANGED			((u16)0xF204UL)
-#define		HFA384x_IT_ASSOCREQ    			((u16)0xF205UL)
-#define		HFA384x_IT_MICFAILURE  			((u16)0xF206UL)
+#define		HFA384x_IT_ASSOCREQ			((u16)0xF205UL)
+#define		HFA384x_IT_MICFAILURE			((u16)0xF206UL)
 
 /*--------------------------------------------------------------------
 Information Frames Structures
-- 
1.7.9.5

