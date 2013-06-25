Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3FYShs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:37:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3FYSgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:36:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anders Hammarquist <iko@iko.pp.se>
Subject: [ 25/27] USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
Date: Tue, 25 Jun 2013 11:35:44 -0700
Message-Id: <20130625183520.595515489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Hammarquist <iko@iko.pp.se>

commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.

Add product id for Abbott strip port cable for Precision meter which
uses the TI 3410 chip.

Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -179,7 +179,8 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
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


