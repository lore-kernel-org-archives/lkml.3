Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaCDUEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaCDUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Dorchain <joerg@dorchain.net>
Subject: [PATCH 3.13 125/172] USB: ftdi_sio: add Cressi Leonardo PID
Date: Tue,  4 Mar 2014 12:03:29 -0800
Message-Id: <20140304200303.717860262@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -908,6 +908,8 @@ static struct usb_device_id id_table_com
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
+	/* Cressi Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
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


