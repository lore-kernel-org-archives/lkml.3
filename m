Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3KQVwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:52:37 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47497 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3KQVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:52:28 -0500
From: Adam Cozzette <acozzette@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Cozzette <acozzette@gmail.com>
Subject: [PATCH] usbkbd.c: trivial typo ('released' -> 'pressed')
Date: Sun, 17 Nov 2013 13:51:23 -0800
Message-Id: <1384725083-3963-1-git-send-email-acozzette@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like this typo was introduced by a mistake in a copy-and-paste in
commit ddbe32491951.

Signed-off-by: Adam Cozzette <acozzette@gmail.com>
---
 drivers/hid/usbhid/usbkbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 7960869..9a332e6 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -146,7 +146,7 @@ static void usb_kbd_irq(struct urb *urb)
 				input_report_key(kbd->dev, usb_kbd_keycode[kbd->new[i]], 1);
 			else
 				hid_info(urb->dev,
-					 "Unknown key (scancode %#x) released.\n",
+					 "Unknown key (scancode %#x) pressed.\n",
 					 kbd->new[i]);
 		}
 	}
-- 
1.8.3.2

