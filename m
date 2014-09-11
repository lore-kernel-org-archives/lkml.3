Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaIKMqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:46:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429AbaIKMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicolas Alt" <n.alt@mytum.de>,
        "Johan Hovold" <johan@kernel.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.166569698@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 071/131] USB: ftdi_sio: add Basic Micro ATOM Nano
 USB2Serial PID
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6552cc7f09261db2aeaae389aa2c05a74b3a93b4 upstream.

Add device id for Basic Micro ATOM Nano USB2Serial adapters.

Reported-by: Nicolas Alt <n.alt@mytum.de>
Tested-by: Nicolas Alt <n.alt@mytum.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -162,6 +162,7 @@ static struct usb_device_id id_table_com
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

