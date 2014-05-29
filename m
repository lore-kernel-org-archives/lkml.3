Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbaE2OSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:18:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59347 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933196AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/103] usb: option driver, add support for Telit UE910v2
Date: Thu, 29 May 2014 15:48:25 +0200
Message-Id: <8ee84f2cdd9ef7772e1638be5cb66716ff614179.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d6de486bc22255779bd54b0fceb4c240962bf146 upstream.

option driver, added VID/PID for Telit UE910v2 modem

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 68fc9fe65936..367c7f08b27c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -243,6 +243,7 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_PRODUCT_CC864_DUAL		0x1005
 #define TELIT_PRODUCT_CC864_SINGLE		0x1006
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
+#define TELIT_PRODUCT_UE910_V2			0x1012
 #define TELIT_PRODUCT_LE920			0x1200
 
 /* ZTE PRODUCTS */
@@ -1041,6 +1042,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UE910_V2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
 		.driver_info = (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
-- 
1.9.3

