Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbbAYS1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:27:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbbAYSKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 161/183] ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT
Date: Sun, 25 Jan 2015 10:08:03 -0800
Message-Id: <20150125180817.166207776@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 40d1746d2eeec5e05956d749cca6364573b472b6 upstream.

CONFIG_GENERIC_CPUFREQ_CPU0 disappeared with commit bbcf071969b20f
("cpufreq: cpu0: rename driver and internals to 'cpufreq_dt'")

Use the renamed CONFIG_CPUFREQ_DT generic driver. It looks like with
v3.18-rc1, commit bbcf071969b20f and fdc509b15eb3eb came in via
different trees causing the resultant v3.18-rc1 to be non-functional for
cpufreq as default supported with omap2plus_defconfig.

Fixes: fdc509b15eb3eb ("ARM: omap2plus_defconfig: Add cpufreq to defconfig")
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/omap2plus_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -68,7 +68,7 @@ CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
-CONFIG_GENERIC_CPUFREQ_CPU0=y
+CONFIG_CPUFREQ_DT=y
 # CONFIG_ARM_OMAP2PLUS_CPUFREQ is not set
 CONFIG_CPU_IDLE=y
 CONFIG_BINFMT_MISC=y


