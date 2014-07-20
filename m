Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaGTIsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 04:48:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47219 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaGTIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 04:48:43 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH 2/2] Staging: Remove redundant comments in wcmd.h file
Date: Sun, 20 Jul 2014 11:48:32 +0300
Message-Id: <1405846112-5046-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments in the header file wcmd.h

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/wcmd.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.h b/drivers/staging/vt6655/wcmd.h
index 2844476..696916c 100644
--- a/drivers/staging/vt6655/wcmd.h
+++ b/drivers/staging/vt6655/wcmd.h
@@ -33,12 +33,9 @@
 #include "80211hdr.h"
 #include "80211mgr.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define AUTHENTICATE_TIMEOUT   1000 //ms
 #define ASSOCIATE_TIMEOUT      1000 //ms
 
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

