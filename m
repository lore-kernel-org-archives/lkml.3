Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbbA1F6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:58:33 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34795 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761483AbbA1F62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:58:28 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH v3 4/5] usb: serial: remove unused function for F81232
Date: Wed, 28 Jan 2015 13:58:24 +0800
Message-Id: <1422424704-7520-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unused function set_control_lines()

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

