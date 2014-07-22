Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaGVHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:11:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54303 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaGVHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:11:24 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: gregkh@linuxfoundation.org
Cc: wkang77@gmail.com, aybuke.147@gmail.com, khoroshilov@ispras.ru,
        kiran.padwal21@gmail.com, joe@perches.com, jonathankim@gctsemi.com,
        deanahn@gctsemi.com, teobaluta@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_usb.c: fix missing blank line after variable declaration
Date: Tue, 22 Jul 2014 12:38:25 +0530
Message-Id: <1406012905-31347-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch fix - Add missing blank line after variable declaration

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/staging/gdm724x/gdm_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index ea89d53..0c1b2de 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -896,6 +896,7 @@ static void gdm_usb_disconnect(struct usb_interface *intf)
 	struct lte_udev *udev;
 	u16 idVendor, idProduct;
 	struct usb_device *usbdev;
+
 	usbdev = interface_to_usbdev(intf);
 
 	idVendor = __le16_to_cpu(usbdev->descriptor.idVendor);
-- 
1.7.9.5

