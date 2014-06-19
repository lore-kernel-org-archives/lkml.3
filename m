Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbaFST2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:28:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54004 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934281AbaFST1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:27:50 -0400
From: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
To: devel@linuxdriverproject.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Neil Armstrong <superna9999@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] wlan-ng/prism2sta:checkpatch: Fix long lines
Date: Thu, 19 Jun 2014 21:20:18 +0200
Message-Id: <1403205620-10219-6-git-send-email-Johannes.Stadlinger@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all warning of checkpatch about lines over 80
characters.

Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@i4.cs.fau.de
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Tugce Sirin <ztugcesirin@gmail.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Neil Armstrong <superna9999@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Vitaly Osipov <vitaly.osipov@gmail.com>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
---
 drivers/staging/wlan-ng/prism2sta.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 278b6a1..a449fdf 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -452,7 +452,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+					   "hfa384x_drvr_start() failed,result=%d\n",
+					   (int)result);
 				result =
 				 P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -496,7 +497,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+					   "hfa384x_drvr_start() failed,result=%d\n",
+					   (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -506,7 +508,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_getcardinfo(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_getcardinfo() failed,result=%d\n", (int)result);
+					   "prism2sta_getcardinfo() failed,result=%d\n",
+					   (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
@@ -516,7 +519,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_globalsetup(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_globalsetup() failed,result=%d\n", (int)result);
+					   "prism2sta_globalsetup() failed,result=%d\n",
+					   (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
@@ -1271,7 +1275,8 @@ void prism2sta_processing_defer(struct work_struct *data)
 				     HFA384x_RID_CURRENTSSID, result);
 				return;
 			}
-			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
+			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *)
+									&ssid,
 						(p80211pstrd_t *) &
 						wlandev->ssid);
 
-- 
1.9.1

