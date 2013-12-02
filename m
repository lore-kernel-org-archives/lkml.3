Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3LBNWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:22:52 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42851 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3LBNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:22:48 -0500
X-Originating-IP: 109.242.63.236
From: Aldo Iljazi <mail@aldo.io>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: usbip: vhci_hcd.c: removed a space
Date: Mon,  2 Dec 2013 15:22:29 +0200
Message-Id: <1385990549-6979-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 921: Removed the space before the semicolon.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index e810ad5..fa3e0b2 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -918,7 +918,7 @@ static void vhci_stop(struct usb_hcd *hcd)
 	sysfs_remove_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
 
 	/* 2. shutdown all the ports of vhci_hcd */
-	for (rhport = 0 ; rhport < VHCI_NPORTS; rhport++) {
+	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
 		struct vhci_device *vdev = &vhci->vdev[rhport];
 
 		usbip_event_add(&vdev->ud, VDEV_EVENT_REMOVED);
-- 
1.7.9.5

