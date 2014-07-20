Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaGTJeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 05:34:13 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42123 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGTJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 05:34:12 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCHv2] Staging: vt6655: Remove redundant comments in wcmd.h
Date: Sun, 20 Jul 2014 12:34:00 +0300
Message-Id: <1405848840-5996-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments in the header file wcmd.h

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
Changes v2: I've missed another redundant comment "//ms"
 so I've deleted it and added "vt6655" to the patch subject

 drivers/staging/vt6655/wcmd.h |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.h b/drivers/staging/vt6655/wcmd.h
index 2844476..126b61c 100644
--- a/drivers/staging/vt6655/wcmd.h
+++ b/drivers/staging/vt6655/wcmd.h
@@ -33,12 +33,9 @@
 #include "80211hdr.h"
 #include "80211mgr.h"
 
-/*---------------------  Export Definitions -------------------------*/
+#define AUTHENTICATE_TIMEOUT   1000
+#define ASSOCIATE_TIMEOUT      1000
 
-#define AUTHENTICATE_TIMEOUT   1000 //ms
-#define ASSOCIATE_TIMEOUT      1000 //ms
-
-// Command code
 typedef enum tagCMD_CODE {
 	WLAN_CMD_BSSID_SCAN,
 	WLAN_CMD_SSID,
@@ -76,7 +73,6 @@ typedef struct tagCMD_ITEM {
 	bool bForceSCAN;
 } CMD_ITEM, *PCMD_ITEM;
 
-// Command state
 typedef enum tagCMD_STATE {
 	WLAN_CMD_SCAN_START,
 	WLAN_CMD_SCAN_END,
@@ -92,13 +88,6 @@ typedef enum tagCMD_STATE {
 	WLAN_CMD_IDLE
 } CMD_STATE, *PCMD_STATE;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 void
 vResetCommandTimer(
 	void *hDeviceContext
-- 
1.7.9.5

