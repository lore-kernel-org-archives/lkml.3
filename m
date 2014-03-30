Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaCaADU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:03:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470AbaC3XnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "=?UTF-8?q?Bj=C3=B8rn=20Mork?=" <bjorn@mork.no>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.545726573@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 077/200] usb: ftdi_sio: add Mindstorms EV3 console adapter
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 67847baee056892dc35efb9c3fd05ae7f075588c upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -163,6 +163,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -50,6 +50,7 @@
 #define TI_XDS100V2_PID		0xa6d0
 
 #define FTDI_NXTCAM_PID		0xABB8 /* NXTCam for Mindstorms NXT */
+#define FTDI_EV3CON_PID		0xABB9 /* Mindstorms EV3 Console Adapter */
 
 /* US Interface Navigator (http://www.usinterface.com/) */
 #define FTDI_USINT_CAT_PID	0xb810	/* Navigator CAT and 2nd PTT lines */

