Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3JJVlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:41:50 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60072 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754904Ab3JJVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:46 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 3/6] drivers: usb: core: hub.c: Comments shouldnt be C99 // comment style
Date: Thu, 10 Oct 2013 23:41:29 +0200
Message-Id: <1381441292-6145-4-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e5fdf4b..5e9fc21 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2488,7 +2488,7 @@ error_device_descriptor:
 	usb_autosuspend_device(usb_dev);
 error_autoresume:
 out_authorized:
-	usb_unlock_device(usb_dev);	// complements locktree
+	usb_unlock_device(usb_dev);	/* complements locktree */
 	return result;
 }
 
@@ -3210,7 +3210,7 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 	if (status == 0 && !port_is_suspended(hub, portstatus))
 		goto SuspendCleared;
 
-	// dev_dbg(hub->intfdev, "resume port %d\n", port1);
+	/* dev_dbg(hub->intfdev, "resume port %d\n", port1); */
 
 	set_bit(port1, hub->busy_bits);
 
-- 
1.8.4

