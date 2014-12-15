Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaLOO2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaLOO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Preston Fick <pffick@gmail.com>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 076/168] USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick
Date: Mon, 15 Dec 2014 14:25:30 +0000
Message-Id: <1418653622-21105-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Preston Fick <pffick@gmail.com>

commit ffcfe30ebd8dd703d0fc4324ffe56ea21f5479f4 upstream.

Signed-off-by: Preston Fick <pffick@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 3beae723ad3a..5741e9405069 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,6 +120,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
-- 
2.1.3

