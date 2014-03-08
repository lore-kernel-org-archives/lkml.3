Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaCHF0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:26:39 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42782 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbaCHF0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:26:38 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: liqin.linux@gmail.com, lennox.wu@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig parameter
Date: Sat,  8 Mar 2014 06:26:30 +0100
Message-Id: <1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the CPU_SCORE7 Kconfig parameter,
which is no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/score/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index c75d06aa27c3..4ac8cae5727c 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -22,27 +22,21 @@ choice
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
1.8.3.2

