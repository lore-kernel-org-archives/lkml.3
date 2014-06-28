Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaF1Sq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:46:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaF1Rtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: [PATCH 3.14 052/110] usb: qcserial: add Netgear AirCard 341U
Date: Sat, 28 Jun 2014 10:46:49 -0700
Message-Id: <20140628174548.732267816@linuxfoundation.org>
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

commit ff1fcd50bc2459744e6f948310bc18eb7d6e8c72 upstream.

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -151,6 +151,9 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 0)},	/* Netgear AirCard 341U Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 2)},	/* Netgear AirCard 341U NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 3)},	/* Netgear AirCard 341U Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 0)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 3)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Modem */


