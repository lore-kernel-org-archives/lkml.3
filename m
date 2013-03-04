Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3CDWwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:52:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51026 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab3CDWww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:52:52 -0500
From: Nishanth Menon <nm@ti.com>
To: <linux-usb@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: fix trivial usb_device kernel-doc errors
Date: Mon, 4 Mar 2013 16:52:49 -0600
Message-ID: <1362437569-30821-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial kernel-doc warnings:
Warning(include/linux/usb.h:574): No description found for parameter 'usb3_lpm_enabled'
Warning(include/linux/usb.h:574): Excess struct/union/enum/typedef member 'usb_classdev' description in 'usb_device'
Warning(include/linux/usb.h:574): Excess struct/union/enum/typedef member 'usbfs_dentry' description in 'usb_device'

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 include/linux/usb.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index 4d22d0f..52464fb 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -469,14 +469,12 @@ struct usb3_lpm_parameters {
  * @lpm_capable: device supports LPM
  * @usb2_hw_lpm_capable: device can perform USB2 hardware LPM
  * @usb2_hw_lpm_enabled: USB2 hardware LPM enabled
+ * @usb3_lpm_enabled: USB3 hardware LPM enabled
  * @string_langid: language ID for strings
  * @product: iProduct string, if present (static)
  * @manufacturer: iManufacturer string, if present (static)
  * @serial: iSerialNumber string, if present (static)
  * @filelist: usbfs files that are open to this device
- * @usb_classdev: USB class device that was created for usbfs device
- *	access from userspace
- * @usbfs_dentry: usbfs dentry entry for the device
  * @maxchild: number of ports if hub
  * @quirks: quirks of the whole device
  * @urbnum: number of URBs submitted for the whole device
-- 
1.7.9.5

