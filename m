Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbaFLRdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:33:52 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:37636 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaFLRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:33:49 -0400
From: Wahib Faizi <wahibfaizi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
Date: Thu, 12 Jun 2014 21:32:19 +0400
Message-Id: <1402594340-10867-2-git-send-email-wahibfaizi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue "do not use assignment in if condition"
detected by checkpatch.pl in usbip_host_driver.c.

Signed-off-by: Wahib Faizi <wahibfaizi@gmail.com>
---
 .../usbip/userspace/libsrc/usbip_host_driver.c     |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 92caef7..32b8f52 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -47,7 +47,8 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	snprintf(status_attr_path, SYSFS_PATH_MAX, "%s/usbip_status",
 		 udev->path);
 
-	if ((fd = open(status_attr_path, O_RDONLY)) < 0) {
+	fd = open(status_attr_path, O_RDONLY);
+	if (fd < 0) {
 		err("error opening attribute %s", status_attr_path);
 		return -1;
 	}
-- 
1.7.9.5

