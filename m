Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3KYNHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:07:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57033 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3KYNHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Alexey E. Kramarenko" <alexeyk13@yandex.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 20/78] USB: serial: ftdi_sio: add id for Z3X Box device
Date: Mon, 25 Nov 2013 13:06:07 +0000
Message-Id: <1385384825-21681-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9=20=D0=9A=D1=80?=

commit e1466ad5b1aeda303f9282463d55798d2eda218c upstream.

Custom VID/PID for Z3X Box device, popular tool for cellphone flashing.

Signed-off-by: Alexey E. Kramarenko <alexeyk13@yandex.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c57562a..6a979cd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -914,6 +914,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1b8af46..a7019d1 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1307,3 +1307,9 @@
  * Manufacturer: Crucible Technologies
  */
 #define FTDI_CT_COMET_PID	0x8e08
+
+/*
+ * Product: Z3X Box
+ * Manufacturer: Smart GSM Team
+ */
+#define FTDI_Z3X_PID		0x0011
-- 
1.8.3.2

