Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3BKGGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:06:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2135 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3BKGGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:06:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 10 Feb 2013 22:03:45 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <arnd@arndb.de>, <marvin24@gmx.de>, <balbi@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v2 2/3] ARM: tegra: Rename board-dt-tegra20.c to tegra.c
Date: Mon, 11 Feb 2013 08:05:42 +0200
Message-ID: <1360562743-21689-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360562743-21689-1-git-send-email-hdoyu@nvidia.com>
References: <1360562743-21689-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the preparation to unify "board-dt-tegra{20,30,114}.c" to a
single file "tegra.c".

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/Makefile                       |    2 +-
 .../arm/mach-tegra/{board-dt-tegra20.c => tegra.c} |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm/mach-tegra/{board-dt-tegra20.c => tegra.c} (100%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index f6b46ae..c6d6be2 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= board-dt-tegra114.o
 ifeq ($(CONFIG_CPU_IDLE),y)
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/tegra.c
similarity index 100%
rename from arch/arm/mach-tegra/board-dt-tegra20.c
rename to arch/arm/mach-tegra/tegra.c
-- 
1.7.9.5

