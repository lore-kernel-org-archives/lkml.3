Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936281Ab3DHKKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:10:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935734Ab3DHJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/102] HID: usbhid: fix build problem
Date: Mon,  8 Apr 2013 10:50:10 +0100
Message-Id: <1365414657-29191-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 570637dc8eeb2faba06228d497ff40bb019bcc93 upstream.

Fix build problem caused by typo introduced by 620ae90ed8
("HID: usbhid: quirk for MSI GX680R led panel").

Reported-by: fengguang.wu@intel.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/usbhid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index e11d186..0401e3f 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -73,7 +73,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
-	{ USB_VENDIR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
-- 
1.8.1.2

