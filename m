Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbaDVVXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33457 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528AbaDVVXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:41 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 2/6] Staging: rts5139: Fixed multi-line code alignment
Date: Tue, 22 Apr 2014 23:23:00 +0200
Message-Id: <1398201784-7602-3-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multi-line code aligned with open parenthesis.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 9d9c706..28f4631 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -291,15 +291,15 @@ static int rts51x_control_thread(void *__chip)
 		 */
 		else if (chip->srb->device->id) {
 			RTS51X_DEBUGP("Bad target number (%d:%d)\n",
-				       chip->srb->device->id,
-				       chip->srb->device->lun);
+				      chip->srb->device->id,
+				      chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
 			RTS51X_DEBUGP("Bad LUN (%d:%d)\n",
-				       chip->srb->device->id,
-				       chip->srb->device->lun);
+				      chip->srb->device->id,
+				      chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -433,12 +433,12 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->pusb_intf = intf;
 	rts51x->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	RTS51X_DEBUGP("Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
 	RTS51X_DEBUGP("Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
-		       intf->cur_altsetting->desc.bInterfaceSubClass,
-		       intf->cur_altsetting->desc.bInterfaceProtocol);
+		      intf->cur_altsetting->desc.bInterfaceSubClass,
+		      intf->cur_altsetting->desc.bInterfaceProtocol);
 
 	/* Store our private data in the interface */
 	usb_set_intfdata(intf, chip);
@@ -569,8 +569,7 @@ static int get_pipes(struct rts51x_chip *chip)
 	}
 
 	if (!ep_in || !ep_out) {
-		RTS51X_DEBUGP("Endpoint sanity check failed!"
-					"Rejecting dev.\n");
+		RTS51X_DEBUGP("Endpoint sanity check failed! Rejecting dev.\n");
 		return -EIO;
 	}
 
-- 
1.9.1

