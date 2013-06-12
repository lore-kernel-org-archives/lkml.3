Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3FLIQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:16:41 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49424 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3FLIQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:16:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/11] CPUFreq Kconfig fixes
Date: Wed, 12 Jun 2013 13:45:07 +0530
Message-Id: <cover.1371022830.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Recently Arnd sent few fixes where drivers were using APIs from freq_table.c but
haven't selected CPU_FREQ_TABLE. Based on that, I just crossed checked all the
places where it should be selected and where it shouldn't be. These are fixes
around that.

I have applied these in my cpufreq-kconfig-fixes branch. Will send you a pull
request separately once I get some Acks (will wait for few days).

Viresh Kumar (11):
  cpufreq: blackfin: enable driver for CONFIG_BFIN_CPU_FREQ
  cpufreq: cris: select CPU_FREQ_TABLE
  cpufreq: davinci: select CPU_FREQ_TABLE
  cpufreq: exynos: select CPU_FREQ_TABLE
  cpufreq: highbank: remove select CPU_FREQ_TABLE
  cpufreq: imx: select CPU_FREQ_TABLE
  cpufreq: powerpc: CBE_RAS: select CPU_FREQ_TABLE
  cpufreq: pxa: select CPU_FREQ_TABLE
  cpufreq: S3C2416/S3C64XX: select CPU_FREQ_TABLE
  cpufreq: tegra: select CPU_FREQ_TABLE for ARCH_TEGRA
  cpufreq: X86_AMD_FREQ_SENSITIVITY: select CPU_FREQ_TABLE

 arch/arm/mach-davinci/Kconfig   | 1 +
 arch/arm/mach-pxa/Kconfig       | 3 +++
 arch/arm/mach-tegra/Kconfig     | 4 +---
 arch/cris/Kconfig               | 2 ++
 drivers/cpufreq/Kconfig.arm     | 6 +++++-
 drivers/cpufreq/Kconfig.powerpc | 1 +
 drivers/cpufreq/Kconfig.x86     | 1 +
 drivers/cpufreq/Makefile        | 2 +-
 8 files changed, 15 insertions(+), 5 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

