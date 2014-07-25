Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbaGYQ3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:29:43 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37637 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112AbaGYQ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:29:42 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from iocmd.h
Date: Fri, 25 Jul 2014 19:29:28 +0300
Message-Id: <1406305768-32247-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from iocmd.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/iocmd.h |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/staging/vt6655/iocmd.h b/drivers/staging/vt6655/iocmd.h
index e499f1b..ae037ec 100644
--- a/drivers/staging/vt6655/iocmd.h
+++ b/drivers/staging/vt6655/iocmd.h
@@ -31,12 +31,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-//typedef uint32_t u32;
-//typedef uint16_t u16;
-//typedef uint8_t u8;
-
 // ioctl Command code
 #define MAGIC_CODE	                 0x3142
 #define IOCTL_CMD_TEST	            (SIOCDEVPRIVATE + 0)
@@ -167,10 +161,6 @@ typedef struct tagSBSSIDItem {
 	u32	    uChannel;
 	u8      abyBSSID[BSSID_LEN];
 	u8      abySSID[SSID_MAXLEN + 1];
-	//2006-1116-01,<Modify> by NomadZhao
-	//u16	    wBeaconInterval;
-	//u16	    wCapInfo;
-	//u8      byNetType;
 	u8      byNetType;
 	u16	    wBeaconInterval;
 	u16	    wCapInfo;        // for address of byNetType at align 4
@@ -228,9 +218,8 @@ typedef struct tagSStatMIBCount {
 	u32   dwIsrUnrecoverableError;
 	u32   dwIsrSoftInterrupt;
 	u32   dwIsrRxNoBuf;
-	/////////////////////////////////////
 
-	u32   dwIsrUnknown;               // unknown interrupt count
+	u32   dwIsrUnknown;
 
 	// RSR status count
 	//
@@ -349,7 +338,6 @@ typedef struct tagSCmdValue {
 // hostapd & viawget ioctl related
 //
 
-// VIAGWET_IOCTL_HOSTAPD ioctl() cmd:
 enum {
 	VIAWGET_HOSTAPD_FLUSH = 1,
 	VIAWGET_HOSTAPD_ADD_STA = 2,
@@ -415,15 +403,6 @@ struct viawget_hostapd_param {
 	} u;
 };
 
-//2006-1116-01,<Add> by NomadZhao
 #pragma pack()
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 #endif //__IOCMD_H__
-- 
1.7.9.5

