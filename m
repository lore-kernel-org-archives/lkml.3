Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaF0MvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:51:08 -0400
Received: from mail.sth.sze.hu ([193.224.129.230]:55079 "EHLO mail.sth.sze.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaF0MvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:51:06 -0400
From: Andras@mail.sth.sze.hu, Kovacs@mail.sth.sze.hu
To: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andras Kovacs <andras@sth.sze.hu>
Subject: [PATCH 1/1] Add support for Corsair usb dongle
Date: Fri, 27 Jun 2014 14:50:11 +0200
Message-Id: <1403873411-12889-1-git-send-email-andras@sth.sze.hu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andras Kovacs <andras@sth.sze.hu>

Corsair USB Dongles are shipped with Corsair AXi series PSUs.
These are cp210x serial usb devices, so make driver detect these.
I have a program, that can get information from these PSUs.

Tested with 2 different dongles shipped with Corsair AX860i and
AX1200i units.

Signed-off-by: Andras Kovacs <andras@sth.sze.hu>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 762e4a5..330df5c 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -153,6 +153,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
+	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
-- 
1.7.10.4

