Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaICWQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbaICWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Alt <n.alt@mytum.de>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 77/88] USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
Date: Wed,  3 Sep 2014 15:05:51 -0700
Message-Id: <20140903220518.254633981@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6552cc7f09261db2aeaae389aa2c05a74b3a93b4 upstream.

Add device id for Basic Micro ATOM Nano USB2Serial adapters.

Reported-by: Nicolas Alt <n.alt@mytum.de>
Tested-by: Nicolas Alt <n.alt@mytum.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -151,6 +151,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_BM_ATOM_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -42,6 +42,8 @@
 /* www.candapter.com Ewert Energy Systems CANdapter device */
 #define FTDI_CANDAPTER_PID 0x9F80 /* Product Id */
 
+#define FTDI_BM_ATOM_NANO_PID	0xa559	/* Basic Micro ATOM Nano USB2Serial */
+
 /*
  * Texas Instruments XDS100v2 JTAG / BeagleBone A3
  * http://processors.wiki.ti.com/index.php/XDS100


