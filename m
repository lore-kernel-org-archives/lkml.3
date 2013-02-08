Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946003Ab3BHBBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:01:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945931Ab3BHA6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Petr=20Kub=C3=A1nek?= <petr@kubanek.net>
Subject: [ 07/16] USB: ftdi_sio: add Zolix FTDI PID
Date: Thu,  7 Feb 2013 16:58:06 -0800
Message-Id: <20130208004628.343610372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.112511141@linuxfoundation.org>
References: <20130208004627.112511141@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -674,6 +674,7 @@ static struct usb_device_id id_table_com
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


