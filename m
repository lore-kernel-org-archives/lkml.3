Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaDEVfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:35:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58826 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaDEVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:35:02 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 08/10] driver: staging: wlan-ng: Removed multiple assignments
Date: Sat,  5 Apr 2014 23:34:56 +0200
Message-Id: <1396733696-16013-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed multiple assignments from hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 1a6116a..cf27030 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2599,7 +2599,8 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	 */
 	result1 = hfa384x_cmd_initialize(hw);
 	msleep(1000);
-	result = result2 = hfa384x_cmd_initialize(hw);
+	result = hfa384x_cmd_initialize(hw);
+	result2 = result;
 	if (result1 != 0) {
 		if (result2 != 0) {
 			netdev_err(hw->wlandev->netdev,
-- 
1.7.9.5

