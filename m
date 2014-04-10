Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935523AbaDJNyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:54:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39219 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934985AbaDJNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:53:58 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 7/7] ARM: sunxi: update the default ARCH_NR_GPIO for sunxi arch
Date: Thu, 10 Apr 2014 15:52:46 +0200
Message-Id: <1397137966-30818-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 SoC has PL and PM banks and thus increase the default ARCH_NR_GPIO.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5db05f6a..ee096bf 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1644,9 +1644,9 @@ config ARCH_NR_GPIO
 	int
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
 	default 512 if ARCH_EXYNOS || ARCH_KEYSTONE || SOC_OMAP5 || SOC_DRA7XX || ARCH_S3C24XX || ARCH_S3C64XX
+	default 416 if ARCH_SUNXI
 	default 392 if ARCH_U8500
 	default 352 if ARCH_VT8500
-	default 288 if ARCH_SUNXI
 	default 264 if MACH_H4700
 	default 0
 	help
-- 
1.8.3.2

