Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaK0IrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:41513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaK0IrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Taylor Braun-Jones <taylor.braun-jones@ge.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 26/91] USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device
Date: Thu, 27 Nov 2014 16:42:09 +0800
Message-Id: <1417077794-9299-26-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Taylor Braun-Jones <taylor.braun-jones@ge.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9c491c372d677b6420e0f8c6361fe422791662cc upstream.

Signed-off-by: Taylor Braun-Jones <taylor.braun-jones@ge.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d91185a..8425e9e 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -960,6 +960,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
 	/* ekey Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
+	/* GE Healthcare devices */
+	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index a5cd5f7..7628b91 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1382,3 +1382,9 @@
  * ekey biometric systems GmbH (http://ekey.net/)
  */
 #define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
+
+/*
+ * GE Healthcare devices
+ */
+#define GE_HEALTHCARE_VID		0x1901
+#define GE_HEALTHCARE_NEMO_TRACKER_PID	0x0015
-- 
1.9.1

