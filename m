Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaENBlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:41:39 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35433 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaENBlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:41:36 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH] HID: hid-sensor-hub: Add Microsoft Surface Pro 2 HID ID and set report quirk
Date: Tue, 13 May 2014 20:41:25 -0500
Message-Id: <1400031685-28090-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-ids.h        | 3 +++
 drivers/hid/hid-sensor-hub.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..18e2099 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -633,6 +633,9 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
+#define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
+#define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
+#define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index be14b56..eefaaf6 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -711,6 +711,15 @@ static const struct hid_device_id sensor_hub_devices[] = {
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_TEXAS_INSTRUMENTS,
 			USB_DEVICE_ID_TEXAS_INSTRUMENTS_LENOVO_YOGA),
 			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+			USB_DEVICE_ID_MS_SURFACE_PRO_2),
+			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+			USB_DEVICE_ID_MS_TOUCH_COVER_2),
+			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
+			USB_DEVICE_ID_MS_TYPE_COVER_2),
+			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
 		     HID_ANY_ID) },
 	{ }
-- 
1.9.0

