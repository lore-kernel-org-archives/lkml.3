Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3BHA6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:58:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3BHA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Killig <sven@killig.de>
Subject: [ 13/26] USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II
Date: Thu,  7 Feb 2013 16:57:41 -0800
Message-Id: <20130208004629.574603394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Killig <sven@killig.de>

commit c249f911406efcc7456cb4af79396726bf7b8c57 upstream.

Add PID/VID entries for ELV WS 300 PC II weather station

Signed-off-by: Sven Killig <sven@killig.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -590,6 +590,7 @@ static struct usb_device_id id_table_com
 	/*
 	 * ELV devices:
 	 */
+	{ USB_DEVICE(FTDI_ELV_VID, FTDI_ELV_WS300_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_USR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_MSM1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_KL100_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -209,7 +209,7 @@
 
 /*
  * ELV USB devices submitted by Christian Abt of ELV (www.elv.de).
- * All of these devices use FTDI's vendor ID (0x0403).
+ * Almost all of these devices use FTDI's vendor ID (0x0403).
  * Further IDs taken from ELV Windows .inf file.
  *
  * The previously included PID for the UO 100 module was incorrect.
@@ -217,6 +217,8 @@
  *
  * Armin Laeuger originally sent the PID for the UM 100 module.
  */
+#define FTDI_ELV_VID	0x1B1F	/* ELV AG */
+#define FTDI_ELV_WS300_PID	0xC006	/* eQ3 WS 300 PC II */
 #define FTDI_ELV_USR_PID	0xE000	/* ELV Universal-Sound-Recorder */
 #define FTDI_ELV_MSM1_PID	0xE001	/* ELV Mini-Sound-Modul */
 #define FTDI_ELV_KL100_PID	0xE002	/* ELV Kfz-Leistungsmesser KL 100 */


