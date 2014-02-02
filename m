Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaBBLLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 06:11:12 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62929 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaBBLLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 06:11:10 -0500
Date: Sun, 02 Feb 2014 12:10:56 +0100
From: Ulrich Hahn <uhahn@eanco.de>
Subject: ..another device for the ftdi_sio driver, 3rd infusion
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.11
Message-Id: <1391339456.31834.1@biblenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>

diff -ur linux-3.13.1/drivers/usb/serial/ftdi_sio.c linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c
--- linux-3.13.1/drivers/usb/serial/ftdi_sio.c	2014-01-29 14:06:37.000000000 +0100
+++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c	2014-02-02 11:57:08.625914749 +0100
@@ -192,6 +192,8 @@
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
Only in linux-3.13.1+tagsys/drivers/usb/serial: ftdi_sio.c.orig
diff -ur linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h	2014-01-29 14:06:37.000000000 +0100
+++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h	2014-02-02 11:57:08.629914782 +0100
@@ -363,6 +363,13 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8
 
+/*
+ * Tagsys RFID Readers
+ * survey (two of them) by Ulrich Hahn
+ */
+#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 
