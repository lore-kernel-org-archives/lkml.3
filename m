Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3EEL6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:58:16 -0400
Received: from fallback6.mail.ru ([94.100.176.134]:59008 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3EEL6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:58:15 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Vineet Gupta <vgupta@synopsys.com>, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] ARC: Remove non existent reference to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD
Date: Sun,  5 May 2013 15:57:44 +0400
Message-Id: <1367755064-13130-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arc/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 6de5ace..491ae79 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -16,8 +16,6 @@ config ARC
 	select GENERIC_FIND_FIRST_BIT
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
-	select GENERIC_KERNEL_EXECVE
-	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
-- 
1.8.1.5

