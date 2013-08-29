Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3H2Oad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:30:33 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:43906 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab3H2Oab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:30:31 -0400
X-Greylist: Passed host: 188.105.214.130
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 1CBD13DC346
X-Greylist: Passed host: 188.105.214.130
X-Greylist: Passed host: 188.105.214.130
Subject: [PATCH] HID: roccat: Added support for KonePureOptical
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Aug 2013 16:30:28 +0200
Message-ID: <1377786628.2404.1.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KonePureOptical is a KonePure with different sensor.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-ids.h             |    1 +
 drivers/hid/hid-roccat-konepure.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ffe4c7a..ef18cd9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -716,6 +716,7 @@
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_KONEPURE	0x2dbe
+#define USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL	0x2db4
 #define USB_DEVICE_ID_ROCCAT_KONEXTD	0x2e22
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
diff --git a/drivers/hid/hid-roccat-konepure.c b/drivers/hid/hid-roccat-konepure.c
index c79d0b0..5850959 100644
--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -262,6 +262,7 @@ static int konepure_raw_event(struct hid_device *hdev,
 
 static const struct hid_device_id konepure_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL) },
 	{ }
 };
 
@@ -300,5 +301,5 @@ module_init(konepure_init);
 module_exit(konepure_exit);
 
 MODULE_AUTHOR("Stefan Achatz");
-MODULE_DESCRIPTION("USB Roccat KonePure driver");
+MODULE_DESCRIPTION("USB Roccat KonePure/Optical driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.3.4



