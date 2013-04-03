Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3DCG00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:26:26 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54280 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762377Ab3DCGYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:24:53 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: robherring2@gmail.com, swarren@wwwdotorg.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv5 3/7] arm: vt8500: Increase available GPIOs on arch-vt8500
Date: Wed,  3 Apr 2013 19:24:47 +1300
Message-Id: <1364970291-17721-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the inclusion of the pin control driver, more GPIO pins have been
identified on the arch-vt8500 SoCs requiring an increase in the available
GPIOs.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..244c618 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1661,7 +1661,8 @@ config ARCH_NR_GPIO
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
 	default 512 if SOC_OMAP5
 	default 355 if ARCH_U8500
-	default 288 if ARCH_VT8500 || ARCH_SUNXI
+	default 352 if ARCH_VT8500
+	default 288 if ARCH_SUNXI
 	default 264 if MACH_H4700
 	default 0
 	help
-- 
1.7.9.5

