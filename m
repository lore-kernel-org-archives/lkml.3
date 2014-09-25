Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaIYXvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:51:22 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50532 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIYXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:51:21 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: brcmstb: Kconfig: drop unneeded symbol selections
Date: Thu, 25 Sep 2014 16:50:54 -0700
Message-Id: <1411689054-10289-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are either implied or not necessary.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 arch/arm/mach-bcm/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index fc938005ad39..fa9e6134fa72 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -101,10 +101,7 @@ config ARCH_BCM_5301X
 
 config ARCH_BRCMSTB
 	bool "Broadcom BCM7XXX based boards" if ARCH_MULTI_V7
-	depends on MMU
 	select ARM_GIC
-	select MIGHT_HAVE_PCI
-	select HAVE_SMP
 	select HAVE_ARM_ARCH_TIMER
 	select BRCMSTB_GISB_ARB
 	select BRCMSTB_L2_IRQ
-- 
1.9.1

