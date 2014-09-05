Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaIEN4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:56:54 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56463 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaIEN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:56:51 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Paul Bolle <pebolle@tiscali.nl>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] score: Remove GENERIC_HAS_IOMAP
Date: Fri,  5 Sep 2014 06:56:18 -0700
Message-Id: <1409925378-8343-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
[Guenter Roeck: Merge with 3.17-rc3; update headline]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Jiri, can you please take this through trivial ?

Thanks,
Guenter

 arch/score/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4ac8cae..366e1b5 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -22,17 +22,14 @@ choice
 config ARCH_SCORE7
 	bool "SCORE7 processor"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select GENERIC_HAS_IOMAP
 endchoice
 
 endmenu
-- 
1.9.1

