Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3ILLZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:25:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10155 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab3ILLZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:25:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Sep 2013 04:25:34 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 4/4] ARM: tegra: defconfig updates
Date: Thu, 12 Sep 2013 04:24:51 -0700
Message-ID: <1378985091-9447-5-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable:
* Tegra CPUFreq driver.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index ea042e8..64bc8bd 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -42,6 +42,7 @@ CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_KEXEC=y
 CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
+CONFIG_ARM_TEGRA_CPUFREQ=y
 CONFIG_CPU_IDLE=y
 CONFIG_VFP=y
 CONFIG_PM_RUNTIME=y
-- 
1.7.9.5

