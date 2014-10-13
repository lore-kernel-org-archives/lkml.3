Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaJMC0C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaJMCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:25:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Savage <joe.savage@goketra.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 15/16] USB: serial: cp210x: added Ketra N1 wireless interface support
Date: Mon, 13 Oct 2014 04:24:12 +0200
Message-Id: <20141013022342.052592276@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022341.386913672@linuxfoundation.org>
References: <20141013022341.386913672@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Savage <joe.savage@goketra.com>

commit bfc2d7dfdd761ae3beccdb26abebe03cef042f46 upstream.

Added support for Ketra N1 wireless interface, which uses the
Silicon Labs' CP2104 USB to UART bridge with customized PID 8946.

Signed-off-by: Joe Savage <joe.savage@goketra.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -122,6 +122,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */


