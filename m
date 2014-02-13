Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBMUky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:40:54 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54655 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBMUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:40:52 -0500
From: Matteo Croce <matteo@openwrt.org>
To: linux-uvc-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Matteo Croce <matteo@openwrt.org>
Subject: [PATCH] uvcvideo: support Samsung notebook webcam
Date: Thu, 13 Feb 2014 21:40:46 +0100
Message-Id: <1392324046-8832-1-git-send-email-matteo@openwrt.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Samsung NP350V5C-S09IT Webcam device ID

Signed-off-by: Matteo Croce <matteo@openwrt.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c3bb250..ba6a71a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2467,6 +2467,14 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
+	/* Samsung NP350V5C USB Web Camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2232,
+	  .idProduct		= 0x1029,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
 	{}
-- 
1.8.3.2

