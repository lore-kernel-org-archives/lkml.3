Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3A2M6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:58:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5699 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A2M6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 29 Jan 2013 04:58:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/7] ARM: tegra114: select PINCTRL for Tegra114 SoC
Date: Tue, 29 Jan 2013 18:26:17 +0530
Message-ID: <1359464183-6255-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select PINCTRL and PINCTRL_TEGRA114 for enabling Tegra114 pincontrol
driver for Tegra114 SoC.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index eada60f..bde8197 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -51,6 +51,8 @@ config ARCH_TEGRA_114_SOC
 	select CPU_V7
 	select ARM_L1_CACHE_SHIFT_6
 	select ARM_ARCH_TIMER
+	select PINCTRL
+	select PINCTRL_TEGRA114
 	help
 	  Support for NVIDIA Tegra T114 processor family, based on the
 	  ARM CortexA15MP CPU
-- 
1.7.1.1

