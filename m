Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaJ0TCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:02:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJ0TCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Savage <joe.savage@goketra.com>, Johan Hovold <johan@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 024/105] USB: serial: cp210x: added Ketra N1 wireless interface support
Date: Mon, 27 Oct 2014 11:55:59 -0700
Message-Id: <1414436240-13879-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Savage <joe.savage@goketra.com>

commit bfc2d7dfdd761ae3beccdb26abebe03cef042f46 upstream.

Added support for Ketra N1 wireless interface, which uses the
Silicon Labs' CP2104 USB to UART bridge with customized PID 8946.

Signed-off-by: Joe Savage <joe.savage@goketra.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 1db213a..df16884 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -122,6 +122,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
-- 
1.9.1

