Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab3HMQEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab3HMP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:34 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1khosP3HmjoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=G1R-Y3-9tMgA:10 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=rXS_5oD0Zpa597KmHtQA:9 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155828.961176659@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anders Hammarquist <iko@iko.pp.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [34/88] USB: serial: ti_usb_3410_5052: new device id for Abbot strip port
 cable
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0034-USB-serial-ti_usb_3410_5052-new-device-id-for-Abbot-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anders Hammarquist <iko@iko.pp.se>

[ Upstream commit 35a2fbc941accd0e9f1bfadd669311786118d874 ]

Add product id for Abbott strip port cable for Precision meter which
uses the TI 3410 chip.

Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 722069c..c7550bf 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -180,7 +180,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
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


