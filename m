Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaCEOl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:41:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbaCEOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joerg Dorchain <joerg@dorchain.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 55/62] USB: ftdi_sio: add Cressi Leonardo PID
Date: Wed,  5 Mar 2014 14:36:59 +0000
Message-Id: <1394030226-26652-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Dorchain <joerg@dorchain.net>

commit 6dbd46c849e071e6afc1e0cad489b0175bca9318 upstream.

Hello,

the following patch adds an entry for the PID of a Cressi Leonardo
diving computer interface to kernel 3.13.0.
It is detected as FT232RL.
Works with subsurface.

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ab8b689..1dfb333 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -918,6 +918,8 @@ static struct usb_device_id id_table_combined [] = {
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
+	/* Cressi Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1e2d369..e599fbf 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1320,3 +1320,9 @@
  * Manufacturer: Smart GSM Team
  */
 #define FTDI_Z3X_PID		0x0011
+
+/*
+ * Product: Cressi PC Interface
+ * Manufacturer: Cressi
+ */
+#define FTDI_CRESSI_PID		0x87d0
-- 
1.9.0

