Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3J0HGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:06:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58510 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897Ab3J0HGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:06:14 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jdike@addtoit.com, richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] um: remove used STDIO_CONSOLE Kconfig param
Date: Sun, 27 Oct 2013 08:06:10 +0100
Message-Id: <1382857570-3412-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the STDIO_CONSOLE Kconfig parameter which
is defined but no longer used anywhere in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/um/Kconfig.char | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
index b9d7c42..f10738d 100644
--- a/arch/um/Kconfig.char
+++ b/arch/um/Kconfig.char
@@ -6,10 +6,6 @@ config STDERR_CONSOLE
 	help
 	  console driver which dumps all printk messages to stderr.
 
-config STDIO_CONSOLE
-	bool
-	default y
-
 config SSL
 	bool "Virtual serial line"
 	help
-- 
1.8.1.2

