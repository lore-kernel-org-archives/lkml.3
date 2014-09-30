Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaI3Vwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaI3ViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/103] USB: zte_ev: remove duplicate Qualcom PID
Date: Tue, 30 Sep 2014 14:30:54 -0700
Message-Id: <1412112708-27356-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 754eb21c0bbbbc4b8830a9a864b286323b84225f upstream.

Remove dublicate Qualcom PID 0x3197 which is already handled by the
moto-modem driver since commit 6986a978eec7 ("USB: add new moto_modem
driver for some Morotola phones").

Fixes: 799ee9243d89 ("USB: serial: add zte_ev.c driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/zte_ev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index 78ff536..88dd32c 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -275,7 +275,6 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 static const struct usb_device_id id_table[] = {
 	/* MG880 */
 	{ USB_DEVICE(0x19d2, 0xfffd) },
-	{ USB_DEVICE(0x05C6, 0x3197) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
1.9.1

