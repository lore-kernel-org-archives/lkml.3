Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbbAFIJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:09:17 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:59814 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbbAFIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:09:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial] HID: Spelling s/Keayboard/Keyboard/
Date: Tue,  6 Jan 2015 09:09:13 +0100
Message-Id: <1420531753-10668-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/hid/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 230b6f887cd86e9b..303b295a5413d39b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -388,7 +388,7 @@ config HID_LOGITECH_HIDPP
 	Say Y if you want support for Logitech devices relying on the HID++
 	specification. Such devices are the various Logitech Touchpads (T650,
 	T651, TK820), some mice (Zone Touch mouse), or even keyboards (Solar
-	Keayboard).
+	Keyboard).
 
 config LOGITECH_FF
 	bool "Logitech force feedback support"
-- 
1.9.1

