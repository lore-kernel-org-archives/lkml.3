Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3AQXIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:08:48 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34240 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab3AQXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:08:46 -0500
From: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: [PATCH 2/3] wlan-ng/prism2mgmt.c: formated too long lines
Date: Fri, 18 Jan 2013 00:07:31 +0100
Message-Id: <1358464052-14002-3-git-send-email-qi50dube@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@cip.cs.fau.de>

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>

---
 drivers/staging/wlan-ng/prism2mgmt.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 62b94b0..4b3db73 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -1144,9 +1144,9 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 			/* Enable the port */
 			result = hfa384x_drvr_enable(hw, 0);
 			if (result) {
-				pr_debug
-				("failed to enable port to presniff setting, result=%d\n",
-				     result);
+				pr_debug(
+					"failed to enable port to presniff setting,"
+					"result=%d\n", result);
 				goto failed;
 			}
 		} else {
@@ -1186,18 +1186,20 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 				hfa384x_drvr_stop(hw);
 				result = hfa384x_drvr_start(hw);
 				if (result) {
-					pr_debug
-					    ("failed to restart the card for sniffing, result=%d\n",
-					     result);
+					pr_debug(
+						"failed to restart the card "
+						"for sniffing, result=%d\n",
+						result);
 					goto failed;
 				}
 			} else {
 				/* Disable the port */
 				result = hfa384x_drvr_disable(hw, 0);
 				if (result) {
-					pr_debug
-					    ("failed to enable port for sniffing, result=%d\n",
-					     result);
+					pr_debug(
+						"failed to enable port for "
+						"sniffing, result=%d\n",
+						result);
 					goto failed;
 				}
 			}
-- 
1.7.10.4

