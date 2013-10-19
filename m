Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3JSR4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 13:56:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46683 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3JSR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 13:56:18 -0400
MIME-Version: 1.0
Date: Sat, 19 Oct 2013 12:56:17 -0500
Message-ID: <CAA_L7Z7WNv7EKAaJFefPoe__KurYSgMgRongB2e4O9kaoKEz-w@mail.gmail.com>
Subject: [PATCH 2/2] Added support for the monitor hotkey present on laptops
 like the Dell N4110
From: Souvik Banerjee <souvik1997@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
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
