Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaI3Vxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:53:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaI3ViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/103] USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
Date: Tue, 30 Sep 2014 14:30:55 -0700
Message-Id: <1412112708-27356-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6552cc7f09261db2aeaae389aa2c05a74b3a93b4 upstream.

Add device id for Basic Micro ATOM Nano USB2Serial adapters.

Reported-by: Nicolas Alt <n.alt@mytum.de>
Tested-by: Nicolas Alt <n.alt@mytum.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 594a707..6f4e126 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -152,6 +152,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_BM_ATOM_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1e58d90..3168a01 100644
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
-- 
1.9.1

