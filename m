Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaDAQzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:55:25 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:24617 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDAQzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:55:22 -0400
Message-ID: <00fbf0b95251730a9d46bd112dc0979a@mwinf5d45.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Tue, 1 Apr 2014 18:28:33 +0200
Subject: [PATCH v4 2/3] staging: serqt_usb2: Add blank line after declaration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 90cf2bd..f329cb4 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1265,9 +1265,9 @@ static void qt_set_termios(struct tty_struct *tty,
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
1.7.2.5

