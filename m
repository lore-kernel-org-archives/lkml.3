Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbaGORO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:58 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54387 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andras Kovacs <andras@sth.sze.hu>, <stable@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 40/94] USB: cp210x: add support for Corsair usb dongle
Date: Tue, 15 Jul 2014 20:00:55 +0300
Message-Id: <1405443709-15288-40-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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

