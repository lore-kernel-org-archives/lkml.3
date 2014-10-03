Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaJCVjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:39:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaJCViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:38:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emanuel Koczwara <poczta@emanuelkoczwara.pl>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.16 126/357] USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
Date: Fri,  3 Oct 2014 14:28:32 -0700
Message-Id: <20141003212937.262677500@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ee444609dbae8afee420c3243ce4c5f442efb622 upstream.

Add device id for NOVITUS Bono E thermal printer.

Reported-by: Emanuel Koczwara <poczta@emanuelkoczwara.pl>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -741,6 +741,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
+	{ USB_DEVICE(NOVITUS_VID, NOVITUS_BONO_E_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -837,6 +837,12 @@
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


