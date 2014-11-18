Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbaKRPTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:19:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaKROJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 035/206] Bluetooth: sort the list of IDs in the source code
Date: Tue, 18 Nov 2014 15:06:30 +0100
Message-Id: <e0dd6d2f9983101dd340f3a4b4342934526daffb.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0b8800623d3f12dd40a039aa191d52bfa4eef5b4 upstream.

This will help to manage table of supported IDs.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/ath3k.c | 82 +++++++++++++++++++++++------------------------
 drivers/bluetooth/btusb.c | 54 +++++++++++++++----------------
 2 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 59f3075f66b3..9f3b102b76c7 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -63,53 +63,53 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0x3000) },
 
 	/* Atheros AR3011 with sflash firmware*/
+	{ USB_DEVICE(0x0489, 0xE027) },
+	{ USB_DEVICE(0x0489, 0xE03D) },
+	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0CF3, 0x3002) },
 	{ USB_DEVICE(0x0CF3, 0xE019) },
 	{ USB_DEVICE(0x13d3, 0x3304) },
-	{ USB_DEVICE(0x0930, 0x0215) },
-	{ USB_DEVICE(0x0489, 0xE03D) },
-	{ USB_DEVICE(0x0489, 0xE027) },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0489, 0xe04d) },
+	{ USB_DEVICE(0x0489, 0xe04e) },
+	{ USB_DEVICE(0x0489, 0xe057) },
+	{ USB_DEVICE(0x0489, 0xe056) },
+	{ USB_DEVICE(0x0489, 0xe05f) },
+	{ USB_DEVICE(0x04c5, 0x1330) },
+	{ USB_DEVICE(0x04CA, 0x3004) },
+	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
+	{ USB_DEVICE(0x04CA, 0x3007) },
+	{ USB_DEVICE(0x04CA, 0x3008) },
+	{ USB_DEVICE(0x04CA, 0x300b) },
+	{ USB_DEVICE(0x0930, 0x0219) },
+	{ USB_DEVICE(0x0930, 0x0220) },
 	{ USB_DEVICE(0x0CF3, 0x0036) },
 	{ USB_DEVICE(0x0CF3, 0x3004) },
 	{ USB_DEVICE(0x0CF3, 0x3008) },
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x0CF3, 0x311E) },
 	{ USB_DEVICE(0x0CF3, 0x311F) },
+	{ USB_DEVICE(0x0cf3, 0x3121) },
 	{ USB_DEVICE(0x0CF3, 0x817a) },
-	{ USB_DEVICE(0x13d3, 0x3375) },
-	{ USB_DEVICE(0x04CA, 0x3004) },
-	{ USB_DEVICE(0x04CA, 0x3005) },
-	{ USB_DEVICE(0x04CA, 0x3006) },
-	{ USB_DEVICE(0x04CA, 0x3007) },
-	{ USB_DEVICE(0x04CA, 0x3008) },
-	{ USB_DEVICE(0x04CA, 0x300b) },
-	{ USB_DEVICE(0x13d3, 0x3362) },
+	{ USB_DEVICE(0x0cf3, 0xe003) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0CF3, 0xE005) },
-	{ USB_DEVICE(0x0930, 0x0219) },
-	{ USB_DEVICE(0x0930, 0x0220) },
-	{ USB_DEVICE(0x0489, 0xe057) },
+	{ USB_DEVICE(0x13d3, 0x3362) },
+	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x13d3, 0x3393) },
-	{ USB_DEVICE(0x0489, 0xe04e) },
-	{ USB_DEVICE(0x0489, 0xe056) },
-	{ USB_DEVICE(0x0489, 0xe04d) },
-	{ USB_DEVICE(0x04c5, 0x1330) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
-	{ USB_DEVICE(0x0cf3, 0x3121) },
-	{ USB_DEVICE(0x0cf3, 0xe003) },
-	{ USB_DEVICE(0x0489, 0xe05f) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
 
 	/* Atheros AR5BBU22 with sflash firmware */
-	{ USB_DEVICE(0x0489, 0xE03C) },
 	{ USB_DEVICE(0x0489, 0xE036) },
+	{ USB_DEVICE(0x0489, 0xE03C) },
 
 	{ }	/* Terminating entry */
 };
@@ -122,39 +122,39 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
 static struct usb_device_id ath3k_blist_tbl[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe05f), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0CF3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311E), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311F), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0CF3, 0x817a), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe05f), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
-	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xE036), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
 
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9e101bf542de..ae81df6a4318 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -102,16 +102,16 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
 	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x0489, 0xe042) },
+	{ USB_DEVICE(0x04ca, 0x2003) },
 	{ USB_DEVICE(0x0b05, 0x17b5) },
 	{ USB_DEVICE(0x0b05, 0x17cb) },
-	{ USB_DEVICE(0x04ca, 0x2003) },
-	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0489, 0xff, 0x01, 0x01) },
 
-	/*Broadcom devices with vendor specific id */
+	/* Broadcom devices with vendor specific id */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
 
 	/* ASUSTek Computer - Broadcom based */
@@ -140,58 +140,58 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0a5c, 0x2033), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros 3011 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe027), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x0cf3, 0xe019), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
-	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
-	{ USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
-	{ USB_DEVICE(0x0489, 0xe027), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros 3012 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe05f), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311f), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x817a), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
-	{ USB_DEVICE(0x0489, 0xe05f), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR5BBU12 with sflash firmware */
-	{ USB_DEVICE(0x0489, 0xe03c), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe036), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe03c), .driver_info = BTUSB_ATH3012 },
 
 	/* Broadcom BCM2035 */
-	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
-	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = BTUSB_BCM92035 },
+	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = BTUSB_WRONG_SCO_MTU },
+	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = BTUSB_WRONG_SCO_MTU },
 
 	/* Broadcom BCM2045 */
 	{ USB_DEVICE(0x0a5c, 0x2039), .driver_info = BTUSB_WRONG_SCO_MTU },
-- 
2.1.3

