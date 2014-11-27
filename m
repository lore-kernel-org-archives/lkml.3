Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaK0Iqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:41260 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbaK0Iqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 16/91] USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
Date: Thu, 27 Nov 2014 16:41:59 +0800
Message-Id: <1417077794-9299-16-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit ee444609dbae8afee420c3243ce4c5f442efb622 upstream.

Add device id for NOVITUS Bono E thermal printer.

Reported-by: Emanuel Koczwara <poczta@emanuelkoczwara.pl>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 121a052..d91185a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -750,6 +750,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
+	{ USB_DEVICE(NOVITUS_VID, NOVITUS_BONO_E_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 0eb2e97..a5cd5f7 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -828,6 +828,12 @@
 #define TELLDUS_TELLSTICK_PID		0x0C30	/* RF control dongle 433 MHz using FT232RL */
 
 /*
+ * NOVITUS printers
+ */
+#define NOVITUS_VID			0x1a28
+#define NOVITUS_BONO_E_PID		0x6010
+
+/*
  * RT Systems programming cables for various ham radios
  */
 #define RTSYSTEMS_VID		0x2100	/* Vendor ID */
-- 
1.9.1

