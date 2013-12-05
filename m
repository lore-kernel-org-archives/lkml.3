Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3LELBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:01:15 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4024 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3LELBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:01:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 02:54:27 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] ARM: tegra: select PINCTRL_TEGRA124 for Tegra124 SoC
Date: Thu, 5 Dec 2013 16:27:49 +0530
Message-ID: <1386241070-4350-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com>
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pincontrol driver for Tegra124 is build through config
PINCTRL_TEGRA124. Select this config option whenever Tegra124
SoC is enabled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 09e740f..807e7bc 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -63,6 +63,7 @@ config ARCH_TEGRA_124_SOC
 	bool "Enable support for Tegra124 family"
 	select ARM_L1_CACHE_SHIFT_6
 	select HAVE_ARM_ARCH_TIMER
+	select PINCTRL_TEGRA124
 	help
 	  Support for NVIDIA Tegra T124 processor family, based on the
 	  ARM CortexA15MP CPU
-- 
1.7.1.1

