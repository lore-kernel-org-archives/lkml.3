Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbbAUKbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:31:03 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58793 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbAUKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:30:26 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH v2 4/4] usb: serial: remove unused function for F81232
Date: Wed, 21 Jan 2015 18:30:21 +0800
Message-Id: <1421836221-25619-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unused function set_line_control

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/usb/serial/f81232.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 9a54f56..11a236b 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -323,13 +323,6 @@ static void f81232_process_read_urb(struct urb *urb)
 		tty_flip_buffer_push(&port->port);
 	}
 
-
-}
-
-static int set_control_lines(struct usb_device *dev, u8 value)
-{
-	/* FIXME - Stubbed out for now */
-	return 0;
 }
 
 static void f81232_break_ctl(struct tty_struct *tty, int break_state)
-- 
1.9.1

