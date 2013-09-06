Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3IFL7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:59:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41160 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108Ab3IFL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:59:43 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] m68k: remove unused Kconfig parameters
Date: Fri,  6 Sep 2013 13:59:39 +0200
Message-Id: <1378468779-3289-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the UC5282 and UC5272 kernel configuration
parameters defined in arch/m68k/Kconfig.machine,
but used nowhere in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/m68k/Kconfig.machine | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index b9ab0a6..a10516b 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -150,18 +150,6 @@ config XCOPILOT_BUGS
 	help
 	  Support the bugs of Xcopilot.
 
-config UC5272
-	bool "Arcturus Networks uC5272 dimm board support"
-	depends on M5272
-	help
-	  Support for the Arcturus Networks uC5272 dimm board.
-
-config UC5282
-	bool "Arcturus Networks uC5282 board support"
-	depends on M528x
-	help
-	  Support for the Arcturus Networks uC5282 dimm board.
-
 config UCSIMM
 	bool "uCsimm module support"
 	depends on M68EZ328
-- 
1.8.1.2

