Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab3EGNlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab3EGNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 078/118] USB: add ftdi_sio USB ID for GDM Boost V1.x
Date: Tue,  7 May 2013 14:38:44 +0100
Message-Id: <1367933964-1564-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefani Seibold <stefani@seibold.net>

commit 58f8b6c4fa5a13cb2ddb400e26e9e65766d71e38 upstream.

This patch add a missing usb device id for the GDMBoost V1.x device

The patch is against 3.9-rc5

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index a93f958..527fb35 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e79861e..3c00351 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -74,6 +74,7 @@
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
+#define FTDI_OPENDCC_GBM_BOOST_PID	0xBFDD
 
 /* NZR SEM 16+ USB (http://www.nzr.de) */
 #define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
-- 
1.8.1.2

