Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaCDUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Dorchain <joerg@dorchain.net>
Subject: [PATCH 3.10 71/97] USB: ftdi_sio: add Cressi Leonardo PID
Date: Tue,  4 Mar 2014 12:04:24 -0800
Message-Id: <20140304200348.333545774@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -910,6 +910,8 @@ static struct usb_device_id id_table_com
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
+	/* Cressi Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
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


