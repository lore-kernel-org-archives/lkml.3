Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3AYN0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:26:33 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:58890 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3AYNYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:24:09 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/25] HID: multitouch: optimize Cando panels
Date: Fri, 25 Jan 2013 14:23:03 +0100
Message-Id: <1359120190-18281-19-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not very different in terms of processing time. However, this
uniformizes the handling of devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 9d8228a..0ea98ae 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -978,7 +978,7 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_DUAL_CONTACT_NUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
-	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
+	{ .driver_data = MT_CLS_DUAL_CONTACT_NUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-- 
1.8.1

