Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378Ab3DBElJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:41:09 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:59340 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123Ab3DBElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:41:01 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 2/6] arm: vt8500: Increase available GPIOs on arch-vt8500
Date: Tue,  2 Apr 2013 17:40:57 +1300
Message-Id: <1364877661-26086-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
References: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
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

