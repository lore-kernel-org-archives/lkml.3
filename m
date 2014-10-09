Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaJIVjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:39:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaJIVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Taylor Braun-Jones <taylor.braun-jones@ge.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/163] USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device
Date: Thu,  9 Oct 2014 14:01:07 -0700
Message-Id: <1412888588-26755-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taylor Braun-Jones <taylor.braun-jones@ge.com>

commit 9c491c372d677b6420e0f8c6361fe422791662cc upstream.

Signed-off-by: Taylor Braun-Jones <taylor.braun-jones@ge.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7bdfa9c..c903b0b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -954,6 +954,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
 	/* Infineon Devices */
 	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
+	/* GE Healthcare devices */
+	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 8927a5c..5937b2d 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1391,3 +1391,9 @@
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

