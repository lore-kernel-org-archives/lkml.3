Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967547AbaFTNHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:07:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64229 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967243AbaFTNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:07:48 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: gregkh@linuxfoundation.org, thomas_75@safe-mail.net,
        paul.gortmaker@windriver.com, himangi774@gmail.com, arnd@arndb.de,
        aybuke.147@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: serqt_usb2: fixed blank line style warning in serqt_usb2.c
Date: Fri, 20 Jun 2014 06:08:07 -0700
Message-Id: <1403269687-15730-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serqt_usb2.c file that fixes the following
warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 998c384..5e97726 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -257,6 +257,7 @@ static void process_modem_status(struct quatech_port *qt_port,
 static void process_rx_char(struct usb_serial_port *port, unsigned char data)
 {
 	struct urb *urb = port->read_urb;
+
 	if (urb->actual_length)
 		tty_insert_flip_char(&port->port, data, TTY_NORMAL);
 }
-- 
2.0.0

