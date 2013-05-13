Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3EMIxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:53:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41288 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3EMIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:53:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] ARM: sunxi: select ARCH_REQUIRE_GPIOLIB
Date: Mon, 13 May 2013 10:53:08 +0200
Message-Id: <1368435188-26965-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SUNXI currently doesn't enable a gpiolib, which causes build
problems when building a kernel with only the sunxi platform enabled.
Select ARCH_REQUIRE_GPIOLIB to solve this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index d259c78..5b045e3 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -1,5 +1,6 @@
 config ARCH_SUNXI
 	bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
+	select ARCH_REQUIRE_GPIOLIB
 	select CLKSRC_MMIO
 	select CLKSRC_OF
 	select COMMON_CLK
-- 
1.8.1.2

