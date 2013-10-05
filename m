Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3JEQL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:26 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45235 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752594Ab3JEQLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:23 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 3/5] drivers: usb: core: hcd: replaced C99 // comments
Date: Sat,  5 Oct 2013 18:02:08 +0200
Message-Id: <6c9a8196c101dbb2d915a24ac53b0f6926b85351.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 0f3e5a0..3a2667c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -428,7 +428,7 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 	char const *s;
 	static char const langids[4] = {4, USB_DT_STRING, 0x09, 0x04};
 
-	// language ids
+	/* language ids */
 	switch (id) {
 	case 0:
 		/* Array of LANGID codes (0x0409 is MSFT-speak for "en-us") */
@@ -615,7 +615,7 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 	case DeviceOutRequest | USB_REQ_SET_INTERFACE:
 		break;
 	case DeviceOutRequest | USB_REQ_SET_ADDRESS:
-		// wValue == urb->dev->devaddr
+		/* wValue == urb->dev->devaddr */
 		dev_dbg (hcd->self.controller, "root hub device address %d\n",
 			wValue);
 		break;
@@ -625,7 +625,7 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 	/* ENDPOINT REQUESTS */
 
 	case EndpointRequest | USB_REQ_GET_STATUS:
-		// ENDPOINT_HALT flag
+		/* ENDPOINT_HALT flag */
 		tbuf[0] = 0;
 		tbuf[1] = 0;
 		len = 2;
@@ -683,7 +683,7 @@ error:
 		if (urb->transfer_buffer_length < len)
 			len = urb->transfer_buffer_length;
 		urb->actual_length = len;
-		// always USB_DIR_IN, toward host
+		/* always USB_DIR_IN, toward host */
 		memcpy (ubuf, bufp, len);
 
 		/* report whether RH hardware supports remote wakeup */
@@ -1134,7 +1134,7 @@ long usb_calc_bus_time (int speed, int is_input, int isoc, int bytecount)
 			return (9107L + BW_HOST_DELAY + tmp);
 		}
 	case USB_SPEED_HIGH:	/* ISOC or INTR */
-		// FIXME adjust for input vs output
+		/* FIXME adjust for input vs output */
 		if (isoc)
 			tmp = HS_NSECS_ISO (bytecount);
 		else
-- 
1.8.4

