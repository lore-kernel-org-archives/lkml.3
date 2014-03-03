Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaCCS5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:57:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaCCS5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 31/67] usb: ftdi_sio: add Mindstorms EV3 console adapter
Date: Mon,  3 Mar 2014 10:55:19 -0800
Message-Id: <1393872955-28810-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 67847baee056892dc35efb9c3fd05ae7f075588c upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8856967..579a2c3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -157,6 +157,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1b8af46..83ca064 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -50,6 +50,7 @@
 #define TI_XDS100V2_PID		0xa6d0
 
 #define FTDI_NXTCAM_PID		0xABB8 /* NXTCam for Mindstorms NXT */
+#define FTDI_EV3CON_PID		0xABB9 /* Mindstorms EV3 Console Adapter */
 
 /* US Interface Navigator (http://www.usinterface.com/) */
 #define FTDI_USINT_CAT_PID	0xb810	/* Navigator CAT and 2nd PTT lines */
-- 
1.8.3.2

