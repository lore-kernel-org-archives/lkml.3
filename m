Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbANOQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:16:47 -0500
Received: from mailscan33.extendcp.co.uk ([79.170.42.5]:47133 "EHLO
	mailscan1.extendcp.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752406AbbANOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:16:46 -0500
From: Mark Glover <mark@actisense.com>
To: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Glover <mark@actisense.com>
Subject: [PATCH] Added PIDs for Actisense USB Devices
Date: Wed, 14 Jan 2015 13:58:40 +0000
Message-Id: <1421243920-15048-1-git-send-email-mark@actisense.com>
X-Mailer: git-send-email 1.7.9.5
X-Authenticated-As: mark.glover@actisense.com
X-Extend-Src: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Glover <mark@actisense.com>

 Signed-off-by: Mark Glover <mark@actisense.com>

---
 drivers/usb/serial/ftdi_sio.c     |   17 +++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   21 +++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1ebb351..a118e5b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -978,6 +978,23 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	/* GE Healthcare devices */
 	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
+	/* Active Research (Actisense) devices */
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_NDC_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_USG_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_NGT_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_NGW_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_D9AC_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_D9AD_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_D9AE_PID) },
+	{ USB_DEVICE(FTDI_VID, ACTISENSE_D9AF_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEAGAUGE_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASWITCH_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_NMEA2000_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_ETHERNET_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_WIFI_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_DISPLAY_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_LITE_PID) },
+	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_ANALOG_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serials/ftdi_sio_ids.h
index e52409c..8ccd1b6 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1438,3 +1438,24 @@
  */
 #define GE_HEALTHCARE_VID		0x1901
 #define GE_HEALTHCARE_NEMO_TRACKER_PID	0x0015
+
+/*
+ * Active Research (Actisense) devices
+ */
+#define ACTISENSE_NDC_PID		0xD9A8 /* NDC USB Serial Adapter */
+#define ACTISENSE_USG_PID		0xD9A9 /* USG USB Serial Adapter */
+#define ACTISENSE_NGT_PID		0xD9AA /* NGT NMEA2000 Interface */
+#define ACTISENSE_NGW_PID		0xD9AB /* NGW NMEA2000 Gateway */
+#define ACTISENSE_D9AC_PID		0xD9AC /* Actisense Reserved */
+#define ACTISENSE_D9AD_PID		0xD9AD /* Actisense Reserved */
+#define ACTISENSE_D9AE_PID		0xD9AE /* Actisense Reserved */
+#define ACTISENSE_D9AF_PID		0xD9AF /* Actisense Reserved */
+#define CHETCO_SEAGAUGE_PID		0xA548 /* SeaGauge USB Adapter */
+#define CHETCO_SEASWITCH_PID		0xA549 /* SeaSwitch USB Apadter */
+#define CHETCO_SEASMART_NMEA2000_PID	0xA54A /* SeaSmart NMEA2000 Gateway */
+#define CHETCO_SEASMART_ETHERNET_PID	0xA54B /* SeaSmart Ethernet Gateway */
+#define CHETCO_SEASMART_WIFI_PID	0xA5AC /* SeaSmart Wifi Gateway */
+#define CHETCO_SEASMART_DISPLAY_PID	0xA5AD /* SeaSmart NMEA2000 Display */
+#define CHETCO_SEASMART_LITE_PID	0xA5AE /* SeaSmart Lite USB Adapter */
+#define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
+
-- 
1.7.9.5

