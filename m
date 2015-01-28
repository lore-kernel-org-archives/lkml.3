Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320AbbA1EWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:22:40 -0500
Received: from mail.kernel.org ([198.145.29.136]:40017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934298AbbA1EWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:33 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nathaniel Ting <nathaniel.ting@silabs.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 093/177] USB: serial: cp210x: add Silicon Labs 358x VID and PID
Date: Wed, 28 Jan 2015 12:09:11 +0800
Message-Id: <1422418236-12852-184-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Ting <nathaniel.ting@silabs.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 35cc83eab097e5720a9cc0ec12bdc3a726f58381 upstream.

Enable Silicon Labs Ember VID chips to enumerate with the cp210x usb serial
driver. EM358x devices operating with the Ember Z-Net 5.1.2 stack may now
connect to host PCs over a USB serial link.

Signed-off-by: Nathaniel Ting <nathaniel.ting@silabs.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 37bca6b..19074db 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -161,6 +161,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
-- 
1.9.1

