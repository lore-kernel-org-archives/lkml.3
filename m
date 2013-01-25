Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3AYNYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:24:25 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:65517 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3AYNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:24:16 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/25] HID: multitouch: optimize Ideacom panels
Date: Fri, 25 Jan 2013 14:23:06 +0100
Message-Id: <1359120190-18281-22-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slot can be extracted by using MINUS_ONE.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f50b359..fe1aa3b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1095,10 +1095,10 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_HANVON_ALT_MULTITOUCH) },
 
 	/* Ideacom panel */
-	{ .driver_data = MT_CLS_SERIAL,
+	{ .driver_data = MT_CLS_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
 			USB_DEVICE_ID_IDEACOM_IDC6650) },
-	{ .driver_data = MT_CLS_SERIAL,
+	{ .driver_data = MT_CLS_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
 			USB_DEVICE_ID_IDEACOM_IDC6651) },
 
-- 
1.8.1

