Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162559AbaDCHNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:13:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47178 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162486AbaDCHNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:13:45 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 8/9] driver: staging: wlan-ng: Removed multiple assignments
Date: Thu,  3 Apr 2014 09:13:40 +0200
Message-Id: <1396509220-3110-1-git-send-email-shehabaldin.sherif@gmail.com>
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
index 64b51b7..777b1e7 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2600,7 +2600,8 @@ int hfa384x_drvr_start(hfa384x_t *hw)
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

