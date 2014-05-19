Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbaESRhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:37:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50552 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbaESRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:36:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/7] ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs
Date: Mon, 19 May 2014 19:36:33 +0200
Message-Id: <1400520995-27365-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-berlin/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 95c098f497b5..101e0f356730 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -5,6 +5,7 @@ config ARCH_BERLIN
 	select GENERIC_IRQ_CHIP
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
+	select PINCTRL
 
 if ARCH_BERLIN
 
@@ -15,16 +16,19 @@ config MACH_BERLIN_BG2
 	select CACHE_L2X0
 	select CPU_PJ4B
 	select HAVE_ARM_TWD if SMP
+	select PINCTRL_BERLIN_BG2
 
 config MACH_BERLIN_BG2CD
 	bool "Marvell Armada 1500-mini (BG2CD)"
 	select CACHE_L2X0
 	select HAVE_ARM_TWD if SMP
+	select PINCTRL_BERLIN_BG2CD
 
 config MACH_BERLIN_BG2Q
 	bool "Marvell Armada 1500 Pro (BG2-Q)"
 	select CACHE_L2X0
 	select HAVE_ARM_TWD if SMP
+	select PINCTRL_BERLIN_BG2Q
 
 endmenu
 
-- 
1.9.1

