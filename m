Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaLEXPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:15:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaLEXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Troy Clark <tclark@matrixorbital.ca>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 27/45] usb: serial: ftdi_sio: add PIDs for Matrix Orbital products
Date: Fri,  5 Dec 2014 14:45:10 -0800
Message-Id: <20141205223321.008431452@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Clark <tclark@matrixorbital.ca>

commit 204ec6e07ea7aff863df0f7c53301f9cbbfbb9d3 upstream.

Add PIDs for new Matrix Orbital GTT series products.

Signed-off-by: Troy Clark <tclark@matrixorbital.ca>
[johan: shorten commit message ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |   33 ++++++++++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   39 ++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -486,6 +486,39 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FD_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FE_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FF_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_4701_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9300_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9301_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9302_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9303_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9304_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9305_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9306_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9307_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9308_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9309_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930A_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930B_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930C_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930D_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930E_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930F_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9310_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9311_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9312_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9313_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9314_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9315_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9316_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9317_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9318_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9319_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931A_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931B_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931C_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931D_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931E_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931F_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PERLE_ULTRAPORT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PIEGROUP_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TNC_X_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -926,8 +926,8 @@
 #define BAYER_CONTOUR_CABLE_PID        0x6001
 
 /*
- * The following are the values for the Matrix Orbital FTDI Range
- * Anything in this range will use an FT232RL.
+ * Matrix Orbital Intelligent USB displays.
+ * http://www.matrixorbital.com
  */
 #define MTXORB_VID			0x1B3D
 #define MTXORB_FTDI_RANGE_0100_PID	0x0100
@@ -1186,8 +1186,39 @@
 #define MTXORB_FTDI_RANGE_01FD_PID	0x01FD
 #define MTXORB_FTDI_RANGE_01FE_PID	0x01FE
 #define MTXORB_FTDI_RANGE_01FF_PID	0x01FF
-
-
+#define MTXORB_FTDI_RANGE_4701_PID	0x4701
+#define MTXORB_FTDI_RANGE_9300_PID	0x9300
+#define MTXORB_FTDI_RANGE_9301_PID	0x9301
+#define MTXORB_FTDI_RANGE_9302_PID	0x9302
+#define MTXORB_FTDI_RANGE_9303_PID	0x9303
+#define MTXORB_FTDI_RANGE_9304_PID	0x9304
+#define MTXORB_FTDI_RANGE_9305_PID	0x9305
+#define MTXORB_FTDI_RANGE_9306_PID	0x9306
+#define MTXORB_FTDI_RANGE_9307_PID	0x9307
+#define MTXORB_FTDI_RANGE_9308_PID	0x9308
+#define MTXORB_FTDI_RANGE_9309_PID	0x9309
+#define MTXORB_FTDI_RANGE_930A_PID	0x930A
+#define MTXORB_FTDI_RANGE_930B_PID	0x930B
+#define MTXORB_FTDI_RANGE_930C_PID	0x930C
+#define MTXORB_FTDI_RANGE_930D_PID	0x930D
+#define MTXORB_FTDI_RANGE_930E_PID	0x930E
+#define MTXORB_FTDI_RANGE_930F_PID	0x930F
+#define MTXORB_FTDI_RANGE_9310_PID	0x9310
+#define MTXORB_FTDI_RANGE_9311_PID	0x9311
+#define MTXORB_FTDI_RANGE_9312_PID	0x9312
+#define MTXORB_FTDI_RANGE_9313_PID	0x9313
+#define MTXORB_FTDI_RANGE_9314_PID	0x9314
+#define MTXORB_FTDI_RANGE_9315_PID	0x9315
+#define MTXORB_FTDI_RANGE_9316_PID	0x9316
+#define MTXORB_FTDI_RANGE_9317_PID	0x9317
+#define MTXORB_FTDI_RANGE_9318_PID	0x9318
+#define MTXORB_FTDI_RANGE_9319_PID	0x9319
+#define MTXORB_FTDI_RANGE_931A_PID	0x931A
+#define MTXORB_FTDI_RANGE_931B_PID	0x931B
+#define MTXORB_FTDI_RANGE_931C_PID	0x931C
+#define MTXORB_FTDI_RANGE_931D_PID	0x931D
+#define MTXORB_FTDI_RANGE_931E_PID	0x931E
+#define MTXORB_FTDI_RANGE_931F_PID	0x931F
 
 /*
  * The Mobility Lab (TML)


