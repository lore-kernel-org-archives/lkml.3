Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBISwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:52:39 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62418 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBISsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:36 -0500
From: Richard Weinberger <richard@nod.at>
To: Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
Date: Sun,  9 Feb 2014 19:47:54 +0100
Message-Id: <1391971686-9517-17-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/score/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index c75d06a..c7a7b65 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -23,19 +23,16 @@ config ARCH_SCORE7
 	bool "SCORE7 processor"
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 endchoice
 
 endmenu
-- 
1.8.4.2

