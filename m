Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaKLB3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaKLB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathaniel Ting <nathaniel.ting@silabs.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.17 198/319] USB: serial: cp210x: add Silicon Labs 358x VID and PID
Date: Wed, 12 Nov 2014 10:15:36 +0900
Message-Id: <20141112011025.560055352@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathaniel Ting <nathaniel.ting@silabs.com>

commit 35cc83eab097e5720a9cc0ec12bdc3a726f58381 upstream.

Enable Silicon Labs Ember VID chips to enumerate with the cp210x usb serial
driver. EM358x devices operating with the Ember Z-Net 5.1.2 stack may now
connect to host PCs over a USB serial link.

Signed-off-by: Nathaniel Ting <nathaniel.ting@silabs.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -155,6 +155,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */


