Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbaDKOkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:40:41 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64241 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbaDKOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:40:38 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, arnd@arndb.de,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: moxart: add select CLKSRC_OF to ARCH_MOXART
Date: Fri, 11 Apr 2014 16:40:26 +0200
Message-Id: <1397227226-20763-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLKSRC_OF was recently removed from options selected by
ARCH_MULTIPLATFORM, breaking boot on MOXA ART SoCs.

Add it to options selected by ARCH_MOXART.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    see "Merge tag 'cleanup-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc" dfc25e4503aef6b82a1de4a0fbe19aafa8648fbe
    
    Applies to next-20140409

 arch/arm/mach-moxart/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-moxart/Kconfig b/arch/arm/mach-moxart/Kconfig
index 82a4ba8..7b320c6 100644
--- a/arch/arm/mach-moxart/Kconfig
+++ b/arch/arm/mach-moxart/Kconfig
@@ -2,6 +2,7 @@ config ARCH_MOXART
 	bool "MOXA ART SoC" if ARCH_MULTI_V4
 	select CPU_FA526
 	select ARM_DMA_MEM_BUFFERABLE
+	select CLKSRC_OF
 	select CLKSRC_MMIO
 	select GENERIC_IRQ_CHIP
 	select ARCH_REQUIRE_GPIOLIB
-- 
1.8.2.1

