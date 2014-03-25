Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaCYRS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:18:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaCYRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:18:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joerg Dorchain <joerg@dorchain.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 70/81] USB: ftdi_sio: add Cressi Leonardo PID
Date: Tue, 25 Mar 2014 10:16:23 -0700
Message-Id: <1395767794-5012-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f9bdb50..7601cf8 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -912,6 +912,8 @@ static struct usb_device_id id_table_combined [] = {
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
1.8.3.2

