Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaDEVeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:34:20 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41150 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaDEVeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:34:17 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 05/10] driver: staging: wlan-ng: Removed Unnecessary space after function pointer name
Date: Sat,  5 Apr 2014 23:34:12 +0200
Message-Id: <1396733652-15906-1-git-send-email-shehabaldin.sherif@gmail.com>
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
index 74db234..22f0f1d 100644
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

