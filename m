Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaL0Hcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 02:32:55 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:60568 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaL0Hcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 02:32:50 -0500
From: Preston Fick <pffick@gmail.com>
To: johan@kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Preston Fick <pffick@gmail.com>
Subject: [PATCH] USB: serial: cp210x: Correcting IDs for production CEL MeshConnect USB Stick
Date: Sat, 27 Dec 2014 01:32:41 -0600
Message-Id: <1419665561-19977-1-git-send-email-pffick@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing typo for MeshConnect IDs. The original PID (0x8875) is not in production and is not needed. Instead it has been changed to the official production PID (0x8857).

Signed-off-by: Preston Fick <pffick@gmail.com>
---
 drivers/usb/serial/cp210x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 6c4eb3c..fb8d3fa 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,7 +120,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
-	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
+	{ USB_DEVICE(0x10C4, 0x8857) }, /* CEL MeshConnect USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
-- 
1.9.1

