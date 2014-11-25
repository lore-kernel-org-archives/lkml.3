Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaKYLWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:22:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaKYKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adel Gadllah <adel.gadllah@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 142/254] HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f
Date: Tue, 25 Nov 2014 10:38:12 +0000
Message-Id: <1416912004-5928-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adel Gadllah <adel.gadllah@gmail.com>

commit 1af39588f84c7c18f8c6d88342f36513a4ce383c upstream.

This device needs the quirk as well.

Tested-by: Kevin Fenzi <kevin@scrye.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5bf100374095..ddd2acb8a091 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -299,6 +299,7 @@
 #define USB_VENDOR_ID_ELAN		0x04f3
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN	0x0089
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B	0x009b
+#define USB_DEVICE_ID_ELAN_TOUCHSCREEN_016F	0x016f
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8969470551c2..29d2590b033f 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -72,6 +72,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B, HID_QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_016F, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
-- 
2.1.0

