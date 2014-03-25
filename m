Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaCYTBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:01:07 -0400
Received: from palahniuk.acksyn.org ([5.9.7.26]:44648 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaCYTBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:01:05 -0400
From: Michele Baldessari <michele@acksyn.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michele Baldessari <michele@acksyn.org>
Subject: [PATCH] USB: serial: ftdi_sio: add id for Brainboxes VX-001 ExpressCard
Date: Tue, 25 Mar 2014 19:00:51 +0000
Message-Id: <1395774051-22470-1-git-send-email-michele@acksyn.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Custom VID/PID for Brainboxes VX-001 ExpressCard RS232 as reported in
https://bugzilla.redhat.com/show_bug.cgi?id=1071914

Signed-off-by: Michele Baldessari <michele@acksyn.org>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 44ab12986805..bf72063d6f48 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -909,6 +909,8 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
 	/* Cressi Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
+	/* Brainbox Devices */
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_001_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e599fbfcde5f..ae842a203371 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1326,3 +1326,10 @@
  * Manufacturer: Cressi
  */
 #define FTDI_CRESSI_PID		0x87d0
+
+/*
+ * Product: ExpressCard 1 Port RS2323
+ * Manufacturer: Brainboxes
+ */
+#define BRAINBOXES_VID		0x05d1
+#define BRAINBOXES_VX_001_PID	0x1001
-- 
1.8.5.3

