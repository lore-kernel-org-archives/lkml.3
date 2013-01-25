Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab3AYN1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:27:41 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:36132 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3AYNX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:59 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/25] HID: multitouch: optimize MosArt panels
Date: Fri, 25 Jan 2013 14:22:58 +0100
Message-Id: <1359120190-18281-14-git-send-email-benjamin.tissoires@gmail.com>
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
index d66c4d7..bc680b5 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1114,7 +1114,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
 
 	/* MosArt panels */
-	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
+	{ .driver_data = MT_CLS_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
 			USB_DEVICE_ID_ASUS_T91MT)},
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-- 
1.8.1

