Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaJCVj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaJCViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:38:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Taylor Braun-Jones <taylor.braun-jones@ge.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.16 125/357] USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device
Date: Fri,  3 Oct 2014 14:28:31 -0700
Message-Id: <20141003212937.233954305@linuxfoundation.org>
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

From: Taylor Braun-Jones <taylor.braun-jones@ge.com>

commit 9c491c372d677b6420e0f8c6361fe422791662cc upstream.

Signed-off-by: Taylor Braun-Jones <taylor.braun-jones@ge.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -952,6 +952,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
 	/* Infineon Devices */
 	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
+	/* GE Healthcare devices */
+	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1385,3 +1385,9 @@
  * ekey biometric systems GmbH (http://ekey.net/)
  */
 #define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
+
+/*
+ * GE Healthcare devices
+ */
+#define GE_HEALTHCARE_VID		0x1901
+#define GE_HEALTHCARE_NEMO_TRACKER_PID	0x0015


