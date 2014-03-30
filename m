Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaC3WJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 18:09:18 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:58604 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaC3WJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 18:09:17 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2014 18:09:16 EDT
Message-ID: <c2c046eabac0f093249aa9767bc9169b@mwinf5d23.me-wanadoo.net>
From: <thomas_75@safe-mail.net>
To: unlisted-recipients:; (no To-header on input)
Date: Sun, 30 Mar 2014 18:09:17 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f29cc555820b3f3047e91fece8b7eac07ff75a8 Mon Sep 17 00:00:00 2001
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Sun, 30 Mar 2014 23:29:38 +0200
Subject: [PATCH] staging: serqt_usb2: Add blank lines after declarations.

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0267dd8..f883f48 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -995,8 +995,8 @@ static void qt_close(struct usb_serial_port *port)
 	struct tty_struct *tty;
 	int status;
 	unsigned int index;
-	status = 0;
 
+	status = 0;
 	tty = tty_port_tty_get(&port->port);
 	index = port->port_number;
 
@@ -1268,8 +1268,8 @@ static void qt_set_termios(struct tty_struct *tty,
 	if (I_IXOFF(tty) || I_IXON(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
-		status =
-		    box_set_sw_flow_ctrl(port->serial, index, stop_char,
+
+		status = box_set_sw_flow_ctrl(port->serial, index, stop_char,
 				      start_char);
 		if (status < 0)
 			dev_dbg(&port->dev,
-- 
1.8.3.2

