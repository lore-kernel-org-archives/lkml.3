Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaDMV5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:57:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36696 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaDMV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:57:23 -0400
X-Originating-IP: 93.199.245.184
Date: Sun, 13 Apr 2014 23:57:16 +0200
From: Tristan Bruns <tristan@tristanbruns.de>
To: jhovold@gmail.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: cp210x: Add 8281 (Nanotec Plug & Drive)
Message-ID: <20140413215716.GB13605@eddie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tristan Bruns <tristan@tristanbruns.de>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 95fa121..762e4a5 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -104,6 +104,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
 	{ USB_DEVICE(0x10C4, 0x822B) }, /* Modem EDGE(GSM) Comander 2 */
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
+	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
 	{ USB_DEVICE(0x10C4, 0x82F9) }, /* Procyon AVS */
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
-- 
1.9.1

