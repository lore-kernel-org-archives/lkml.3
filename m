Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162526AbaDCHNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:13:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36555 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162514AbaDCHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:13:15 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 5/9] driver: staging: wlan-ng: Removed Unnecessary space after function pointer name
Date: Thu,  3 Apr 2014 09:13:10 +0200
Message-Id: <1396509190-3003-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed Unnecessary space after function pointer name

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 65e59a3..26289c6 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -203,7 +203,7 @@ static int hfa384x_usbctlx_submit(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
 static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
 
 struct usbctlx_completor {
-	int (*complete) (struct usbctlx_completor *);
+	int (*complete)(struct usbctlx_completor *);
 };
 
 static int
-- 
1.7.9.5

