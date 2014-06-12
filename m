Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbaFLRe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:34:27 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:49781 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386AbaFLRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:33:51 -0400
From: Wahib Faizi <wahibfaizi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
Date: Thu, 12 Jun 2014 21:32:20 +0400
Message-Id: <1402594340-10867-3-git-send-email-wahibfaizi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue "line over 80 characters"
detected by checkpatch.pl in usbip_host_driver.c.

Signed-off-by: Wahib Faizi <wahibfaizi@gmail.com>
---
 .../usbip/userspace/libsrc/usbip_host_driver.c     |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 32b8f52..bef08d5 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -88,8 +88,8 @@ struct usbip_exported_device *usbip_exported_device_new(const char *sdevpath)
 		goto err;
 
 	/* reallocate buffer to include usb interface data */
-	size = sizeof(struct usbip_exported_device) + edev->udev.bNumInterfaces *
-		sizeof(struct usbip_usb_interface);
+	size = sizeof(struct usbip_exported_device) +
+		edev->udev.bNumInterfaces * sizeof(struct usbip_usb_interface);
 
 	edev_old = edev;
 	edev = realloc(edev, size);
-- 
1.7.9.5

