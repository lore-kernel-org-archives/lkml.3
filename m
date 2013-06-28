Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3F1SyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3F1SyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:54:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anders Hammarquist <iko@iko.pp.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 061/105] USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
Date: Fri, 28 Jun 2013 11:51:23 -0700
Message-Id: <1372445527-24414-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Hammarquist <iko@iko.pp.se>

commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.

Add product id for Abbott strip port cable for Precision meter which
uses the TI 3410 chip.

Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 4a8b685..a166761 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -178,7 +178,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index b353e7e..4a2423e 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -52,7 +52,9 @@
 
 /* Abbott Diabetics vendor and product ids */
 #define ABBOTT_VENDOR_ID		0x1a61
-#define ABBOTT_PRODUCT_ID		0x3410
+#define ABBOTT_STEREO_PLUG_ID		0x3410
+#define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID
+#define ABBOTT_STRIP_PORT_ID		0x3420
 
 /* Commands */
 #define TI_GET_VERSION			0x01
-- 
1.8.1.2

