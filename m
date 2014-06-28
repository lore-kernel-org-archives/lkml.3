Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaF1RuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbaF1RuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 053/110] usb: qcserial: add additional Sierra Wireless QMI devices
Date: Sat, 28 Jun 2014 10:46:50 -0700
Message-Id: <20140628174548.780756722@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Morgado <aleksander@aleksander.es>

commit 0ce5fb58564fd85aa8fd2d24209900e2e845317b upstream.

A set of new VID/PIDs retrieved from the out-of-tree GobiNet/GobiSerial
Sierra Wireless drivers.

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Link: http://marc.info/?l=linux-usb&m=140136310027293&w=2
Cc: <stable@vger.kernel.org>	# backport in link above
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -145,15 +145,33 @@ static const struct usb_device_id id_tab
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


