Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaCaS0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:26:35 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:53104 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaCaS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:26:33 -0400
Message-ID: <9a24b2302b95c4a1efa94aea5097ba5a@mwinf5d64.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Mon, 31 Mar 2014 19:45:44 +0200
Subject: [PATCH v3 1/2] staging: serqt_usb2: Add blank lines after declarations.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0267dd8..a04cfc3 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1268,9 +1268,9 @@ static void qt_set_termios(struct tty_struct *tty,
 	if (I_IXOFF(tty) || I_IXON(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
-		status =
-		    box_set_sw_flow_ctrl(port->serial, index, stop_char,
-				      start_char);
+
+		status = box_set_sw_flow_ctrl(port->serial, index, stop_char,
+					      start_char);
 		if (status < 0)
 			dev_dbg(&port->dev,
 				"box_set_sw_flow_ctrl (enabled) failed\n");
-- 
1.8.3.2

