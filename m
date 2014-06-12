Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaFLTLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:11:39 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52059 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFLTLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:11:08 -0400
From: Wahib Faizi <wahibfaizi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: usbip: usbip_host_driver.c: avoid assignment in if
Date: Thu, 12 Jun 2014 23:09:50 +0400
Message-Id: <1402600191-12391-2-git-send-email-wahibfaizi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402600191-12391-1-git-send-email-wahibfaizi@gmail.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402600191-12391-1-git-send-email-wahibfaizi@gmail.com>
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

