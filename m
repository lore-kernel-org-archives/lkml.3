Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaIDVDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:03:22 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:54019 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIDVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:03:21 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8821ae: Fix "space required before that '*'" errors
Date: Thu,  4 Sep 2014 16:01:04 -0500
Message-Id: <1409864464-1411-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space required before that '*'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h | 6 +++---
 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h  | 6 +++---
 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h | 8 ++++----
 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h | 6 +++---
 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h | 8 ++++----
 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h | 6 +++---
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
index 37bdab5..446fd68 100644
--- a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
@@ -23,7 +23,7 @@ typedef enum _BT_INFO_SRC_8812A_1ANT{
 	BT_INFO_SRC_8812A_1ANT_BT_RSP				= 0x1,
 	BT_INFO_SRC_8812A_1ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8812A_1ANT_MAX
-}BT_INFO_SRC_8812A_1ANT,*PBT_INFO_SRC_8812A_1ANT;
+} BT_INFO_SRC_8812A_1ANT, *PBT_INFO_SRC_8812A_1ANT;
 
 typedef enum _BT_8812A_1ANT_BT_STATUS{
 	BT_8812A_1ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
@@ -33,7 +33,7 @@ typedef enum _BT_8812A_1ANT_BT_STATUS{
 	BT_8812A_1ANT_BT_STATUS_SCO_BUSY				= 0x4,
 	BT_8812A_1ANT_BT_STATUS_ACL_SCO_BUSY			= 0x5,
 	BT_8812A_1ANT_BT_STATUS_MAX
-}BT_8812A_1ANT_BT_STATUS,*PBT_8812A_1ANT_BT_STATUS;
+} BT_8812A_1ANT_BT_STATUS, *PBT_8812A_1ANT_BT_STATUS;
 
 typedef enum _BT_8812A_1ANT_COEX_ALGO{
 	BT_8812A_1ANT_COEX_ALGO_UNDEFINED			= 0x0,
@@ -48,7 +48,7 @@ typedef enum _BT_8812A_1ANT_COEX_ALGO{
 	BT_8812A_1ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x9,
 	BT_8812A_1ANT_COEX_ALGO_HID_A2DP			= 0xa,
 	BT_8812A_1ANT_COEX_ALGO_MAX				= 0xb,
-}BT_8812A_1ANT_COEX_ALGO,*PBT_8812A_1ANT_COEX_ALGO;
+} BT_8812A_1ANT_COEX_ALGO, *PBT_8812A_1ANT_COEX_ALGO;
 
 typedef struct _COEX_DM_8812A_1ANT{
 	// fw mechanism
diff --git a/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h b/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
index 60992f5..ffd9ac8 100644
--- a/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
@@ -30,14 +30,14 @@ typedef enum _BT_INFO_SRC_8723A_1ANT{
 	BT_INFO_SRC_8723A_1ANT_BT_RSP				= 0x1,
 	BT_INFO_SRC_8723A_1ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8723A_1ANT_MAX
-}BT_INFO_SRC_8723A_1ANT,*PBT_INFO_SRC_8723A_1ANT;
+} BT_INFO_SRC_8723A_1ANT, *PBT_INFO_SRC_8723A_1ANT;
 
 typedef enum _BT_8723A_1ANT_BT_STATUS{
 	BT_8723A_1ANT_BT_STATUS_IDLE				= 0x0,
 	BT_8723A_1ANT_BT_STATUS_CONNECTED_IDLE	= 0x1,
 	BT_8723A_1ANT_BT_STATUS_NON_IDLE			= 0x2,
 	BT_8723A_1ANT_BT_STATUS_MAX
-}BT_8723A_1ANT_BT_STATUS,*PBT_8723A_1ANT_BT_STATUS;
+} BT_8723A_1ANT_BT_STATUS, *PBT_8723A_1ANT_BT_STATUS;
 
 typedef enum _BT_8723A_1ANT_COEX_ALGO{
 	BT_8723A_1ANT_COEX_ALGO_UNDEFINED			= 0x0,
@@ -51,7 +51,7 @@ typedef enum _BT_8723A_1ANT_COEX_ALGO{
 	BT_8723A_1ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x8,
 	BT_8723A_1ANT_COEX_ALGO_HID_A2DP			= 0x9,
 	BT_8723A_1ANT_COEX_ALGO_MAX
-}BT_8723A_1ANT_COEX_ALGO,*PBT_8723A_1ANT_COEX_ALGO;
+} BT_8723A_1ANT_COEX_ALGO, *PBT_8723A_1ANT_COEX_ALGO;
 
 typedef struct _COEX_DM_8723A_1ANT{
 	// fw mechanism
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
index a759b75..37a782f 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
@@ -22,7 +22,7 @@ typedef enum _BT_INFO_SRC_8192E_1ANT{
 	BT_INFO_SRC_8192E_1ANT_BT_RSP				= 0x1,
 	BT_INFO_SRC_8192E_1ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8192E_1ANT_MAX
-}BT_INFO_SRC_8192E_1ANT,*PBT_INFO_SRC_8192E_1ANT;
+} BT_INFO_SRC_8192E_1ANT, *PBT_INFO_SRC_8192E_1ANT;
 
 typedef enum _BT_8192E_1ANT_BT_STATUS{
 	BT_8192E_1ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
@@ -32,7 +32,7 @@ typedef enum _BT_8192E_1ANT_BT_STATUS{
 	BT_8192E_1ANT_BT_STATUS_SCO_BUSY				= 0x4,
 	BT_8192E_1ANT_BT_STATUS_ACL_SCO_BUSY			= 0x5,
 	BT_8192E_1ANT_BT_STATUS_MAX
-}BT_8192E_1ANT_BT_STATUS,*PBT_8192E_1ANT_BT_STATUS;
+} BT_8192E_1ANT_BT_STATUS, *PBT_8192E_1ANT_BT_STATUS;
 
 typedef enum _BT_8192E_1ANT_WIFI_STATUS{
 	BT_8192E_1ANT_WIFI_STATUS_NON_CONNECTED_IDLE				= 0x0,
@@ -42,7 +42,7 @@ typedef enum _BT_8192E_1ANT_WIFI_STATUS{
 	BT_8192E_1ANT_WIFI_STATUS_CONNECTED_IDLE					= 0x4,
 	BT_8192E_1ANT_WIFI_STATUS_CONNECTED_BUSY					= 0x5,
 	BT_8192E_1ANT_WIFI_STATUS_MAX
-}BT_8192E_1ANT_WIFI_STATUS,*PBT_8192E_1ANT_WIFI_STATUS;
+} BT_8192E_1ANT_WIFI_STATUS, *PBT_8192E_1ANT_WIFI_STATUS;
 
 typedef enum _BT_8192E_1ANT_COEX_ALGO{
 	BT_8192E_1ANT_COEX_ALGO_UNDEFINED			= 0x0,
@@ -57,7 +57,7 @@ typedef enum _BT_8192E_1ANT_COEX_ALGO{
 	BT_8192E_1ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x9,
 	BT_8192E_1ANT_COEX_ALGO_HID_A2DP			= 0xa,
 	BT_8192E_1ANT_COEX_ALGO_MAX				= 0xb,
-}BT_8192E_1ANT_COEX_ALGO,*PBT_8192E_1ANT_COEX_ALGO;
+} BT_8192E_1ANT_COEX_ALGO, *PBT_8192E_1ANT_COEX_ALGO;
 
 typedef struct _COEX_DM_8192E_1ANT{
 	// fw mechanism
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
index c07d373..7c929ab 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
@@ -17,14 +17,14 @@ typedef enum _BT_INFO_SRC_8723A_2ANT{
 	BT_INFO_SRC_8723A_2ANT_BT_RSP				= 0x1,
 	BT_INFO_SRC_8723A_2ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8723A_2ANT_MAX
-}BT_INFO_SRC_8723A_2ANT,*PBT_INFO_SRC_8723A_2ANT;
+} BT_INFO_SRC_8723A_2ANT, *PBT_INFO_SRC_8723A_2ANT;
 
 typedef enum _BT_8723A_2ANT_BT_STATUS{
 	BT_8723A_2ANT_BT_STATUS_IDLE				= 0x0,
 	BT_8723A_2ANT_BT_STATUS_CONNECTED_IDLE	= 0x1,
 	BT_8723A_2ANT_BT_STATUS_NON_IDLE			= 0x2,
 	BT_8723A_2ANT_BT_STATUS_MAX
-}BT_8723A_2ANT_BT_STATUS,*PBT_8723A_2ANT_BT_STATUS;
+} BT_8723A_2ANT_BT_STATUS, *PBT_8723A_2ANT_BT_STATUS;
 
 typedef enum _BT_8723A_2ANT_COEX_ALGO{
 	BT_8723A_2ANT_COEX_ALGO_UNDEFINED			= 0x0,
@@ -38,7 +38,7 @@ typedef enum _BT_8723A_2ANT_COEX_ALGO{
 	BT_8723A_2ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x8,
 	BT_8723A_2ANT_COEX_ALGO_HID_A2DP			= 0x9,
 	BT_8723A_2ANT_COEX_ALGO_MAX
-}BT_8723A_2ANT_COEX_ALGO,*PBT_8723A_2ANT_COEX_ALGO;
+} BT_8723A_2ANT_COEX_ALGO, *PBT_8723A_2ANT_COEX_ALGO;
 
 typedef struct _COEX_DM_8723A_2ANT{
 	// fw mechanism
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
index 5ce292f..db3627c 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
@@ -22,7 +22,7 @@ typedef enum _BT_INFO_SRC_8723B_1ANT{
 	BT_INFO_SRC_8723B_1ANT_BT_RSP			= 0x1,
 	BT_INFO_SRC_8723B_1ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8723B_1ANT_MAX
-}BT_INFO_SRC_8723B_1ANT,*PBT_INFO_SRC_8723B_1ANT;
+} BT_INFO_SRC_8723B_1ANT, *PBT_INFO_SRC_8723B_1ANT;
 
 typedef enum _BT_8723B_1ANT_BT_STATUS{
 	BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
@@ -32,7 +32,7 @@ typedef enum _BT_8723B_1ANT_BT_STATUS{
 	BT_8723B_1ANT_BT_STATUS_SCO_BUSY		= 0x4,
 	BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY		= 0x5,
 	BT_8723B_1ANT_BT_STATUS_MAX
-}BT_8723B_1ANT_BT_STATUS,*PBT_8723B_1ANT_BT_STATUS;
+} BT_8723B_1ANT_BT_STATUS, *PBT_8723B_1ANT_BT_STATUS;
 
 typedef enum _BT_8723B_1ANT_WIFI_STATUS{
 	BT_8723B_1ANT_WIFI_STATUS_NON_CONNECTED_IDLE			= 0x0,
@@ -42,7 +42,7 @@ typedef enum _BT_8723B_1ANT_WIFI_STATUS{
 	BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE			= 0x4,
 	BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY			= 0x5,
 	BT_8723B_1ANT_WIFI_STATUS_MAX
-}BT_8723B_1ANT_WIFI_STATUS,*PBT_8723B_1ANT_WIFI_STATUS;
+} BT_8723B_1ANT_WIFI_STATUS, *PBT_8723B_1ANT_WIFI_STATUS;
 
 typedef enum _BT_8723B_1ANT_COEX_ALGO{
 	BT_8723B_1ANT_COEX_ALGO_UNDEFINED		= 0x0,
@@ -57,7 +57,7 @@ typedef enum _BT_8723B_1ANT_COEX_ALGO{
 	BT_8723B_1ANT_COEX_ALGO_HID_A2DP_PANEDR		= 0x9,
 	BT_8723B_1ANT_COEX_ALGO_HID_A2DP		= 0xa,
 	BT_8723B_1ANT_COEX_ALGO_MAX			= 0xb,
-}BT_8723B_1ANT_COEX_ALGO,*PBT_8723B_1ANT_COEX_ALGO;
+} BT_8723B_1ANT_COEX_ALGO, *PBT_8723B_1ANT_COEX_ALGO;
 
 struct coex_dm_8723b_1ant{
 	/* fw mechanism */
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
index fa3784a..2b3f46d 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
@@ -20,7 +20,7 @@ typedef enum _BT_INFO_SRC_8723B_2ANT{
 	BT_INFO_SRC_8723B_2ANT_BT_RSP			= 0x1,
 	BT_INFO_SRC_8723B_2ANT_BT_ACTIVE_SEND		= 0x2,
 	BT_INFO_SRC_8723B_2ANT_MAX
-}BT_INFO_SRC_8723B_2ANT,*PBT_INFO_SRC_8723B_2ANT;
+} BT_INFO_SRC_8723B_2ANT, *PBT_INFO_SRC_8723B_2ANT;
 
 typedef enum _BT_8723B_2ANT_BT_STATUS{
 	BT_8723B_2ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
@@ -30,7 +30,7 @@ typedef enum _BT_8723B_2ANT_BT_STATUS{
 	BT_8723B_2ANT_BT_STATUS_SCO_BUSY		= 0x4,
 	BT_8723B_2ANT_BT_STATUS_ACL_SCO_BUSY		= 0x5,
 	BT_8723B_2ANT_BT_STATUS_MAX
-}BT_8723B_2ANT_BT_STATUS,*PBT_8723B_2ANT_BT_STATUS;
+} BT_8723B_2ANT_BT_STATUS, *PBT_8723B_2ANT_BT_STATUS;
 
 typedef enum _BT_8723B_2ANT_COEX_ALGO{
 	BT_8723B_2ANT_COEX_ALGO_UNDEFINED		= 0x0,
@@ -45,7 +45,7 @@ typedef enum _BT_8723B_2ANT_COEX_ALGO{
 	BT_8723B_2ANT_COEX_ALGO_HID_A2DP_PANEDR		= 0x9,
 	BT_8723B_2ANT_COEX_ALGO_HID_A2DP		= 0xa,
 	BT_8723B_2ANT_COEX_ALGO_MAX			= 0xb,
-}BT_8723B_2ANT_COEX_ALGO,*PBT_8723B_2ANT_COEX_ALGO;
+} BT_8723B_2ANT_COEX_ALGO, *PBT_8723B_2ANT_COEX_ALGO;
 
 struct coex_dm_8723b_2ant{
 	/* fw mechanism */
-- 
1.9.1

