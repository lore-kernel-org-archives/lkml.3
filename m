Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423056Ab3FUJbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:31:38 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56496 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3FUJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:31:37 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: usbip: replace pr_warning() with pr_warn()
Date: Fri, 21 Jun 2013 15:01:04 +0530
Message-Id: <1371807064-25221-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_warn() is preferred over pr_warning().

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/usbip_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index 82123be..64933b9 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -85,7 +85,7 @@ int usbip_start_eh(struct usbip_device *ud)
 
 	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
 	if (IS_ERR(ud->eh)) {
-		pr_warning("Unable to start control thread\n");
+		pr_warn("Unable to start control thread\n");
 		return PTR_ERR(ud->eh);
 	}
 
-- 
1.7.10.4

