Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbaDWPGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:06:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58584 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757227AbaDWPGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:06:34 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/5] ARM: sunxi: Select restart drivers
Date: Wed, 23 Apr 2014 17:04:34 +0200
Message-Id: <1398265476-29373-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we have the restart hooks in the kernel by selecting them in Kconfig.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index b57d7d53b9d3..5fe80cc9b524 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -9,6 +9,10 @@ config ARCH_SUNXI
 	select HAVE_ARM_ARCH_TIMER
 	select PINCTRL
 	select PINCTRL_SUNXI
+	select POWER_RESET
+	select POWER_RESET_SUN6I
+	select POWER_SUPPLY
 	select RESET_CONTROLLER
 	select SUN4I_TIMER
 	select SUN5I_HSTIMER
+	select SUNXI_WATCHDOG
-- 
1.9.1

