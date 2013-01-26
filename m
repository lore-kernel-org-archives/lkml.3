Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3AZOhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:37:07 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:51527 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3AZOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:37:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: sunxi: Increase the number of GPIOs available
Date: Sat, 26 Jan 2013 15:36:51 +0100
Message-Id: <1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10 has 9 banks of 32 GPIOs available, so it doesn't fit
in the usual 256 limit set by gpio.h. Increase this number to 288.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f95ba14..1e86fa9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1632,7 +1632,7 @@ config ARCH_NR_GPIO
 	default 355 if ARCH_U8500
 	default 264 if MACH_H4700
 	default 512 if SOC_OMAP5
-	default 288 if ARCH_VT8500
+	default 288 if ARCH_VT8500 || ARCH_SUNXI
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
-- 
1.7.10.4

