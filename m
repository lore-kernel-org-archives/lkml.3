Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaBTXud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:50:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaBTXu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ulrich Hahn <uhahn@eanco.de>, Johan Hovold <johan@hovold.com>
Subject: [PATCH 3.4 12/25] USB: ftdi_sio: add Tagsys RFID Reader IDs
Date: Thu, 20 Feb 2014 15:51:28 -0800
Message-Id: <20140220234842.826935910@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Hahn <uhahn@eanco.de>

commit 76f24e3f39a1a94bab0d54e98899d64abcd9f69c upstream.

Adding two more IDs to the ftdi_sio usb serial driver.
It now connects Tagsys RFID readers.
There might be more IDs out there for other Tagsys models.

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>
Cc: Johan Hovold <johan@hovold.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -205,6 +205,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -364,6 +364,12 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8
 
+/*
+ * Two of the Tagsys RFID Readers
+ */
+#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 


