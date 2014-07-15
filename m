Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbaGOWTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:19:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396AbaGOVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aleksander Morgado <aleksander@aleksander.es>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/198] usb: qcserial: add Netgear AirCard 341U
Date: Tue, 15 Jul 2014 14:29:02 -0700
Message-Id: <1405459868-15089-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Morgado <aleksander@aleksander.es>

commit ff1fcd50bc2459744e6f948310bc18eb7d6e8c72 upstream.

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Aleksander: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/qcserial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 6c0a542..781e4db 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -151,6 +151,9 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 0)},	/* Netgear AirCard 341U Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 2)},	/* Netgear AirCard 341U NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9055, 3)},	/* Netgear AirCard 341U Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 0)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 3)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
-- 
1.9.1

