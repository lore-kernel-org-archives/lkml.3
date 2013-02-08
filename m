Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab3BHBNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:13:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456Ab3BHA5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Petr=20Kub=C3=A1nek?= <petr@kubanek.net>
Subject: [ 18/34] USB: ftdi_sio: add Zolix FTDI PID
Date: Thu,  7 Feb 2013 16:57:14 -0800
Message-Id: <20130208004630.515368512@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Kubánek <petr@kubanek.net>

commit 0ba3b2ccc72b3df5c305d61f59d93ab0f0e87991 upstream.

Add support for Zolix Omni 1509 monochromator custom USB-RS232 converter.

Signed-off-by: Petr Kubánek <petr@kubanek.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -671,6 +671,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MHAM_KW_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -147,6 +147,11 @@
 #define XSENS_CONVERTER_6_PID	0xD38E
 #define XSENS_CONVERTER_7_PID	0xD38F
 
+/**
+ * Zolix (www.zolix.com.cb) product ids
+ */
+#define FTDI_OMNI1509			0xD491	/* Omni1509 embedded USB-serial */
+
 /*
  * NDI (www.ndigital.com) product ids
  */


