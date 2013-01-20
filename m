Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3ATPbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:31:17 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55429 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab3ATPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:31:16 -0500
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: [PATCH 2/2] wlan-ng/prism2mgmt.c: formated too long lines
Date: Sun, 20 Jan 2013 16:30:54 +0100
Message-Id: <1358695854-2154-1-git-send-email-sisewank@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@cip.cs.fau.de>

Formated pr_debug() calls

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>

---
 drivers/staging/wlan-ng/prism2mgmt.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 6021f89..15733c6 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -1157,9 +1157,8 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 			/* Enable the port */
 			result = hfa384x_drvr_enable(hw, 0);
 			if (result) {
-				pr_debug
-				("failed to enable port to presniff setting, result=%d\n",
-				     result);
+				pr_debug("failed to enable port to presniff setting, result=%d\n",
+					 result);
 				goto failed;
 			}
 		} else {
@@ -1199,18 +1198,16 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 				hfa384x_drvr_stop(hw);
 				result = hfa384x_drvr_start(hw);
 				if (result) {
-					pr_debug
-					    ("failed to restart the card for sniffing, result=%d\n",
-					     result);
+					pr_debug("failed to restart the card for sniffing, result=%d\n",
+						 result);
 					goto failed;
 				}
 			} else {
 				/* Disable the port */
 				result = hfa384x_drvr_disable(hw, 0);
 				if (result) {
-					pr_debug
-					    ("failed to enable port for sniffing, result=%d\n",
-					     result);
+					pr_debug("failed to enable port for sniffing, result=%d\n",
+						 result);
 					goto failed;
 				}
 			}
-- 
1.7.10.4

