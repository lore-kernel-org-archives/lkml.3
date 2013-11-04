Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3KDJ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:58:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33289 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887Ab3KDJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:58:04 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: liqin.linux@gmail.com, lennox.wu@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] score: remove unused CPU_SCORE7 Kconfig parameter
Date: Mon,  4 Nov 2013 10:58:01 +0100
Message-Id: <1383559081-5460-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the CPU_SCORE7 Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/score/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 305f7ee1f382..2bc03d04f3af 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -23,27 +23,21 @@ choice
 config ARCH_SCORE7
 	bool "SCORE7 processor"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
 	select GENERIC_HAS_IOMAP
 endchoice
 
 endmenu
 
-config CPU_SCORE7
-	bool
-
 config NO_DMA
 	bool
 	default y
-- 
1.8.1.2

