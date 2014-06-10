Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaFJTyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFJTyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Sanders <aaron.sanders@hp.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/160] USB: pl2303: add ids for Hewlett-Packard HP POS pole displays
Date: Tue, 10 Jun 2014 12:44:28 -0700
Message-Id: <1402429600-20477-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/pl2303.c | 3 +++
 drivers/usb/serial/pl2303.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index beb8edc..6e09306 100644
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
index c38b8c0..42bc082 100644
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
1.9.1

