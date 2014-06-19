Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022AbaFST1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:27:52 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53997 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757784AbaFST1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:48 -0400
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] wlan-ng/prism2mgmt:checkpatch: Fix long lines
Date: Thu, 19 Jun 2014 21:20:13 +0200
Message-Id: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all warnings of checkpatch about lines over 80
characters.

Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@i4.cs.fau.de
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
CC: Himangi Saraogi <himangi774@gmail.com>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2mgmt.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index d110b36..36a3e1a 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -156,7 +156,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					  HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM);
 	if (result) {
 		netdev_err(wlandev->netdev,
-			   "setconfig(ROAMINGMODE) failed. result=%d\n", result);
+			   "setconfig(ROAMINGMODE) failed. result=%d\n",
+			   result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -273,7 +274,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 		result = hfa384x_drvr_enable(hw, 0);
 		if (result) {
 			netdev_err(wlandev->netdev,
-				   "drvr_enable(0) failed. result=%d\n", result);
+				   "drvr_enable(0) failed. result=%d\n",
+				   result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -293,7 +295,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					sizeof(hfa384x_HostScanRequest_data_t));
 	if (result) {
 		netdev_err(wlandev->netdev,
-			   "setconfig(SCANREQUEST) failed. result=%d\n", result);
+			   "setconfig(SCANREQUEST) failed. result=%d\n",
+			   result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -315,7 +318,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 		result = hfa384x_drvr_disable(hw, 0);
 		if (result) {
 			netdev_err(wlandev->netdev,
-				   "drvr_disable(0) failed. result=%d\n", result);
+				   "drvr_disable(0) failed. result=%d\n",
+				   result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -654,7 +658,8 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_TXRATECNTL, word);
 	if (result) {
-		netdev_err(wlandev->netdev, "Failed to set txrates=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set txrates=%d.\n",
+			   word);
 		goto failed;
 	}
 
-- 
1.9.1

