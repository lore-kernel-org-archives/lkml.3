Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbbAUUYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:24:35 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:51992 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbAUUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:24:29 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 21 Jan 2015 15:24:27 -0500
To: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH] USB: cp210x: add ID for RUGGEDCOM USB Serial Console
Message-ID: <20150121202427.GA4451@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the USB serial console device ID for Siemens Ruggedcom devices
which have a USB port for their serial console.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f4c56fc..f34e6ba 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -55,6 +55,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
+	{ USB_DEVICE(0x0908, 0x01FF) }, /* RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
 	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */
-- 
1.7.10.4
