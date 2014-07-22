Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbaGVWgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:36:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaGVW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aleksander Morgado <aleksander@aleksander.es>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 042/116] usb: qcserial: add additional Sierra Wireless QMI devices
Date: Tue, 22 Jul 2014 15:20:53 -0700
Message-Id: <1406067727-19683-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Morgado <aleksander@aleksander.es>

commit 0ce5fb58564fd85aa8fd2d24209900e2e845317b upstream.

A set of new VID/PIDs retrieved from the out-of-tree GobiNet/GobiSerial
Sierra Wireless drivers.

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Link: http://marc.info/?l=linux-usb&m=140136310027293&w=2
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Aleksander: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/qcserial.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 781e4db..43d93db 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -145,15 +145,33 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 0)},	/* Sierra Wireless EM7355 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 2)},	/* Sierra Wireless EM7355 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 3)},	/* Sierra Wireless EM7355 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9040, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9040, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9040, 3)},	/* Sierra Wireless Modem Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 0)},	/* Sierra Wireless MC7305/MC7355 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 2)},	/* Sierra Wireless MC7305/MC7355 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 3)},	/* Sierra Wireless MC7305/MC7355 Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9053, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9053, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9053, 3)},	/* Sierra Wireless Modem Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9054, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9054, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9054, 3)},	/* Sierra Wireless Modem Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 0)},	/* Netgear AirCard 341U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 2)},	/* Netgear AirCard 341U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 3)},	/* Netgear AirCard 341U Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9056, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9056, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9056, 3)},	/* Sierra Wireless Modem Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9060, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9060, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9060, 3)},	/* Sierra Wireless Modem Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9061, 0)},	/* Sierra Wireless Modem Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9061, 2)},	/* Sierra Wireless Modem NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9061, 3)},	/* Sierra Wireless Modem Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 0)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 3)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
-- 
1.9.1

