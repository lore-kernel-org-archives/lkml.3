Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab3EFXKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab3EFW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:58:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [ 06/46] USB: add ftdi_sio USB ID for GDM Boost V1.x
Date: Mon,  6 May 2013 15:58:12 -0700
Message-Id: <20130506225821.333805725@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefani Seibold <stefani@seibold.net>

commit 58f8b6c4fa5a13cb2ddb400e26e9e65766d71e38 upstream.

This patch add a missing usb device id for the GDMBoost V1.x device

The patch is against 3.9-rc5

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -74,6 +74,7 @@
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
+#define FTDI_OPENDCC_GBM_BOOST_PID	0xBFDD
 
 /* NZR SEM 16+ USB (http://www.nzr.de) */
 #define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */


