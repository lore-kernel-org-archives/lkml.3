Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaDAQzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:55:19 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:54079 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDAQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:55:14 -0400
Message-ID: <4b3f4209cf5a187c093d964f424a4344@mwinf5d45.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Tue, 1 Apr 2014 18:27:34 +0200
Subject: [PATCH v4 1/3] staging: serqt_usb2: Remove useless variable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0267dd8..90cf2bd 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -993,9 +993,7 @@ static void qt_close(struct usb_serial_port *port)
 	struct quatech_port *qt_port;
 	struct quatech_port *port0;
 	struct tty_struct *tty;
-	int status;
 	unsigned int index;
-	status = 0;
 
 	tty = tty_port_tty_get(&port->port);
 	index = port->port_number;
@@ -1015,8 +1013,7 @@ static void qt_close(struct usb_serial_port *port)
 	tty_kref_put(tty);
 
 	/* Close uart channel */
-	status = qt_close_channel(serial, index);
-	if (status < 0)
+	if (qt_close_channel(serial, index) < 0)
 		dev_dbg(&port->dev, "%s - qt_close_channel failed.\n",
 			__func__);
 
-- 
1.7.2.5

