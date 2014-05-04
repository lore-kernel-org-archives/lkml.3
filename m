Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaEDP5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaEDPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Sanders <aaron.sanders@hp.com>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 86/86] USB: pl2303: add ids for Hewlett-Packard HP POS pole displays
Date: Sun,  4 May 2014 11:42:01 -0400
Message-Id: <20140504154152.131718774@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Sanders <aaron.sanders@hp.com>

commit b16c02fbfb963fa2941b7517ebf1f8a21946775e upstream.

Add device ids to pl2303 for the Hewlett-Packard HP POS pole displays:

LD960: 03f0:0B39
LCM220: 03f0:3139
LCM960: 03f0:3239

[ Johan: fix indentation and sort PIDs numerically ]

Signed-off-by: Aaron Sanders <aaron.sanders@hp.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |    3 +++
 drivers/usb/serial/pl2303.h |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -82,6 +82,9 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM960_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
 	{ USB_DEVICE(ZEAGLE_VENDOR_ID, ZEAGLE_N2ITION3_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -121,8 +121,11 @@
 #define SUPERIAL_VENDOR_ID	0x5372
 #define SUPERIAL_PRODUCT_ID	0x2303
 
-/* Hewlett-Packard LD220-HP POS Pole Display */
+/* Hewlett-Packard POS Pole Displays */
 #define HP_VENDOR_ID		0x03f0
+#define HP_LD960_PRODUCT_ID	0x0b39
+#define HP_LCM220_PRODUCT_ID	0x3139
+#define HP_LCM960_PRODUCT_ID	0x3239
 #define HP_LD220_PRODUCT_ID	0x3524
 
 /* Cressi Edy (diving computer) PC interface */


