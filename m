Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaIEXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:25:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55602 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIEXZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:25:58 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Matt Porter <mporter@linaro.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH] ARM: brcmstb: Kconfig: drop unneeded symbol selections
Date: Fri,  5 Sep 2014 16:25:37 -0700
Message-Id: <1409959537-14217-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are either implied or not necessary.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Based on some of Rob's comments from earlier review

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

