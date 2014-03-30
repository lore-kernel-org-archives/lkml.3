Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaC3Xns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbaC3Xni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9=20=D0=9A=D1=80?=
	=?UTF-8?q?=D0=B0=D0=BC=D0=B0=D1=80=D0=B5=D0=BD=D0=BA=D0=BE?=" 
	<alexeyk13@yandex.ru>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.144166963@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 143/200] USB: serial: ftdi_sio: add id for Z3X Box device
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Алексей Крамаренко
 <alexeyk13@yandex.ru>

commit e1466ad5b1aeda303f9282463d55798d2eda218c upstream.

Custom VID/PID for Z3X Box device, popular tool for cellphone flashing.

Signed-off-by: Alexey E. Kramarenko <alexeyk13@yandex.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -917,6 +917,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1314,3 +1314,9 @@
  * Manufacturer: Crucible Technologies
  */
 #define FTDI_CT_COMET_PID	0x8e08
+
+/*
+ * Product: Z3X Box
+ * Manufacturer: Smart GSM Team
+ */
+#define FTDI_Z3X_PID		0x0011

