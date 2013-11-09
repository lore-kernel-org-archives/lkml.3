Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3KIBO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 20:14:57 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:64281 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3KIBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 20:14:45 -0500
MIME-Version: 1.0
Date: Fri, 8 Nov 2013 19:14:45 -0600
Message-ID: <CAA_L7Z5NYpUf3YE0oWqMEmDmWCFLxybY55BT-+gVe4HWNvMR3A@mail.gmail.com>
Subject: [PATCH 2/2] dell-wmi.c: Added support for the monitor hotkey present
 on laptops like the Dell N4110
From: Souvik Banerjee <souvik1997@gmail.com>
To: matthew.garrett@nebula.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        torvalds@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the monitor switching hotkey on laptops such as the N4110.

Signed-off-by: Souvik Banerjee <souvik1997@gmail.com>
---
 drivers/platform/x86/dell-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 5adb60a..a880183 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -92,6 +92,8 @@ static const struct key_entry
dell_wmi_legacy_keymap[] __initconst = {
         { KE_IGNORE, 0xe025, { KEY_RESERVED } },
         { KE_IGNORE, 0xe026, { KEY_RESERVED } },

+        /* For laptops like the Dell Inspiron N4110 with a monitor hotkey */
+        { KE_KEY, 0xe027, { KEY_SWITCHVIDEOMODE } },
         { KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
         { KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
         { KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
--
1.8.4.1
