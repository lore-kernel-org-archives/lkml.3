Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3FLIUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:20:12 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59738 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3FLIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:20:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 03/11] cpufreq: davinci: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 13:45:10 +0530
Message-Id: <1894877337de5e8cf067a147a3b416b95c4cc62e.1371022830.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq driver of this platform uses APIs from freq_table.c and so must select
CPU_FREQ_TABLE.

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index a075b3e..e026b19 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -40,6 +40,7 @@ config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
 	select ARCH_DAVINCI_DA8XX
 	select ARCH_HAS_CPUFREQ
+	select CPU_FREQ_TABLE
 	select CP_INTC
 
 config ARCH_DAVINCI_DA8XX
-- 
1.7.12.rc2.18.g61b472e

