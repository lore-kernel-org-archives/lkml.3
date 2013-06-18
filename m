Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab3FSA2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:28:06 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:43550
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932824Ab3FSA2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:28:03 -0400
Message-Id: <201306190016.r5J0Gosh032063@eskarina.iko.pp.se>
From: Anders Hammarquist <iko@iko.pp.se>
Date: Wed, 19 Jun 2013 01:45:48 +0200
Subject: [PATCH 1/2] Add product id for Abbott strip port cable for Precision
 meter which uses the TI 3410 chip.
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Wed, 19 Jun 2013 02:16:52 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index c92c5ed..e581c25 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -172,7 +172,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
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
1.7.10.4

