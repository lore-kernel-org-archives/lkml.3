Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaIWCjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:38190 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbaIWCjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:18 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 21/45] USB: serial: pl2303: add device id for ztek device
Date: Tue, 23 Sep 2014 10:31:23 +0800
Message-Id: <1411439507-30391-21-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 91fcb1ce420e0a5f8d92d556d7008a78bc6ce1eb upstream.

This adds a new device id to the pl2303 driver for the ZTEK device.

Reported-by: Mike Chu <Mike-Chu@prolific.com.tw>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 9d768ac..3e450b4 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -51,6 +51,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ZTEK) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 42bc082..71fd9da 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -22,6 +22,7 @@
 #define PL2303_PRODUCT_ID_GPRS		0x0609
 #define PL2303_PRODUCT_ID_HCR331	0x331a
 #define PL2303_PRODUCT_ID_MOTOROLA	0x0307
+#define PL2303_PRODUCT_ID_ZTEK		0xe1f1
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
-- 
1.7.9.5

