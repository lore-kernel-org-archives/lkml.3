Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3KIHbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:31:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab3KIGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Alexey E. Kramarenko" <alexeyk13@yandex.ru>
Subject: [PATCH 3.10 05/74] USB: serial: ftdi_sio: add id for Z3X Box device
Date: Fri,  8 Nov 2013 22:51:10 -0800
Message-Id: <20131109065113.881529173@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Алексей Крамаренко <alexeyk13@yandex.ru>

commit e1466ad5b1aeda303f9282463d55798d2eda218c upstream.

Custom VID/PID for Z3X Box device, popular tool for cellphone flashing.

Signed-off-by: Alexey E. Kramarenko <alexeyk13@yandex.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -906,6 +906,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
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


