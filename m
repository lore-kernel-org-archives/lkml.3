Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbaEMKLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933053AbaEMKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaron Sanders <aaron.sanders@hp.com>,
        Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 121/182] USB: pl2303: add ids for Hewlett-Packard HP POS pole displays
Date: Tue, 13 May 2014 11:27:53 +0200
Message-Id: <fdd1dc3ce835420d228b4a18dae42fa0d42d6f6e.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Sanders <aaron.sanders@hp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b16c02fbfb963fa2941b7517ebf1f8a21946775e upstream.

Add device ids to pl2303 for the Hewlett-Packard HP POS pole displays:

LD960: 03f0:0B39
LCM220: 03f0:3139
LCM960: 03f0:3239

[ Johan: fix indentation and sort PIDs numerically ]

Signed-off-by: Aaron Sanders <aaron.sanders@hp.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/pl2303.c | 3 +++
 drivers/usb/serial/pl2303.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index beb8edce4ef2..6e09306b2a5e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -83,6 +83,9 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM960_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
 	{ USB_DEVICE(ZEAGLE_VENDOR_ID, ZEAGLE_N2ITION3_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index c38b8c00c06f..42bc082896ac 100644
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
-- 
1.9.3

