Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CFQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:29:23 -0500
Received: from smtp3.gemalto.com ([193.56.114.206]:38243 "EHLO
	smtp3.gemalto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3CFQ3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:29:18 -0500
X-Greylist: delayed 1225 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2013 11:29:18 EST
From: Schmiedl Christian <Christian.Schmiedl@gemalto.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Mar 2013 17:08:50 +0100
Subject: [PATCH] USB: added support for Cinterion's products AH6 and PLS8
Thread-Topic: [PATCH] USB: added support for Cinterion's products AH6 and
 PLS8
Thread-Index: Ac4ahOPZRgvnOZNXQmaHcO8RKtcmgQ==
Message-ID: <376FB829F3ECB542B825EAF4D8CA8A97DE761BEB06@CROEXCFWP03.gemalto.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Schmiedl <christian.schmiedl@gemalto.com>

/drivers/usb/serial/option.c: added support for Cinterion's products AH6 and PLS8 by adding Product IDs and USB_DEVICE tuples
Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
---
patch is against linux-3.2.40
--- linux-3.2.40/drivers/usb/serial/option.c.orig	2013-03-06 16:12:49.773178503 +0100
+++ linux-3.2.40/drivers/usb/serial/option.c	2013-03-06 16:53:00.589134238 +0100
@@ -341,6 +341,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
+#define CINTERION_PRODUCT_AH6			0x0055
+#define CINTERION_PRODUCT_PLS8			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1260,6 +1262,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
