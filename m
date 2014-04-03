Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbaDCA0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:26:00 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52652 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbaDCAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:25:59 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 2/2] driver: staging: wlan-ng: Removed unnecessary typedefs from hfa384x_usb.c
Date: Thu,  3 Apr 2014 02:25:54 +0200
Message-Id: <1396484754-32500-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary typedefs from hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 4cfd074..4e057d7 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -767,7 +767,8 @@ struct usbctlx_rmem_completor {
 
 static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 {
-	struct usbctlx_rmem_completor *complete = (struct usbctlx_rmem_completor *) head;
+	struct usbctlx_rmem_completor *complete =
+		(struct usbctlx_rmem_completor *)head;
 
 	pr_debug("rmemresp:len=%d\n", complete->rmemresp->frmlen);
 	memcpy(complete->data, complete->rmemresp->data, complete->len);
-- 
1.7.9.5

