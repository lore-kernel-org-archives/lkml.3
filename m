Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3IXVgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:36:43 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:45627 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3IXVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:36:41 -0400
Message-ID: <524205E5.2090303@marcussundberg.com>
Date: Tue, 24 Sep 2013 23:36:37 +0200
From: Marcus Sundberg <marcus@marcussundberg.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] net: ipheth Add support for iPad 3.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad23adfbe455f8ae44476d43e4b3033306fe536f Mon Sep 17 00:00:00 2001
From: Marcus Sundberg <marcus@marcussundberg.com>
Date: Tue, 24 Sep 2013 22:37:07 +0200
Subject: [PATCH 1/2] net: ipheth: Sort device IDs and use consistent
 whitespace.

Signed-off-by: Marcus Sundberg <marcus@marcussundberg.com>
---
 drivers/net/usb/ipheth.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index ff8594d..a736ebb 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -54,16 +54,16 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>

-#define USB_VENDOR_APPLE        0x05ac
-#define USB_PRODUCT_IPHONE      0x1290
-#define USB_PRODUCT_IPHONE_3G   0x1292
-#define USB_PRODUCT_IPHONE_3GS  0x1294
-#define USB_PRODUCT_IPHONE_4	0x1297
-#define USB_PRODUCT_IPAD 0x129a
-#define USB_PRODUCT_IPAD_MINI    0x12ab
-#define USB_PRODUCT_IPHONE_4_VZW 0x129c
-#define USB_PRODUCT_IPHONE_4S	0x12a0
-#define USB_PRODUCT_IPHONE_5	0x12a8
+#define USB_VENDOR_APPLE		0x05ac
+#define USB_PRODUCT_IPHONE		0x1290
+#define USB_PRODUCT_IPHONE_3G		0x1292
+#define USB_PRODUCT_IPHONE_3GS		0x1294
+#define USB_PRODUCT_IPHONE_4		0x1297
+#define USB_PRODUCT_IPAD		0x129a
+#define USB_PRODUCT_IPHONE_4_VZW	0x129c
+#define USB_PRODUCT_IPHONE_4S		0x12a0
+#define USB_PRODUCT_IPHONE_5		0x12a8
+#define USB_PRODUCT_IPAD_MINI		0x12ab

 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
-- 
1.7.9.5

>From 73f4ff929960772cc1cd07209b87ceba111173f2 Mon Sep 17 00:00:00 2001
From: Marcus Sundberg <marcus@marcussundberg.com>
Date: Tue, 24 Sep 2013 22:43:59 +0200
Subject: [PATCH 2/2] net: ipheth: Add support for iPad 3.

Add USB device ID 0x12a6 to the ipheth network-over-USB-tethering
driver for iOS devices.

Signed-off-by: Marcus Sundberg <marcus@marcussundberg.com>
---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index a736ebb..fc3e2a4 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -62,6 +62,7 @@
 #define USB_PRODUCT_IPAD		0x129a
 #define USB_PRODUCT_IPHONE_4_VZW	0x129c
 #define USB_PRODUCT_IPHONE_4S		0x12a0
+#define USB_PRODUCT_IPAD_3		0x12a6
 #define USB_PRODUCT_IPHONE_5		0x12a8
 #define USB_PRODUCT_IPAD_MINI		0x12ab

@@ -123,6 +124,10 @@ static struct usb_device_id ipheth_table[] = {
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_5,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPAD_3,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
-- 
1.7.9.5


-- 
------------------------------------------------------------------
           Marcus Sundberg <marcus@marcussundberg.com>
