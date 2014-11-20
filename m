Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaKTFrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:47:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34121 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaKTFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:47:20 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-15-546d806538f4
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        pankaj.dubey@samsung.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v3 2/5] drivers: soc: Add support for Exynos PMU driver
Date: Thu, 20 Nov 2014 11:09:25 +0530
Message-id: <1416461968-2057-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkWje1ITfE4PwWY4uGqyEWvQuuslls
	enyN1eLyrjlsFjPO72OyWLT1C7sDm8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTF/
	/yTmgvcyFb936DYwXhPvYuTkkBAwkZjzsYsNwhaTuHBvPZDNxSEksJRRYuucuSwwRZ/mbWKG
	SCxilDhz9ROUM4FJoqPnCRNIFZuAscTPnfvZuxg5OEQEvCWWX1MEqWEWaGKUODfvMitIXFjA
	XeLSfCGQchYBVYlLu5uYQMK8Am4Syw/ngZgSAgoScybZgFRwAhU//7SHEcQWAqo4tWIxE8hE
	CYFmdom3L3+zQIwRkPg2+RALRK+sxKYDzBAnS0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrF
	ibnFpXnpesn5uZsYgeF7+t+zCTsY7x2wPsQowMGoxMObYJEbIsSaWFZcmXuI0RRow0RmKdHk
	fGCU5JXEGxqbGVmYmpgaG5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZE3
	9FPO0d0nxc5+Wnnx0mF23XORjl/EEzNvOoiLcrNu3WLDP8MpvL1FyZhB+ZBpSJH7oTVPZvwO
	YDG6uPHvzDlnk97b9a5KXH7vxAs3w1WsKgvLs2eE7JtUp9F4/O/T4w0Juhq/mSYf65Ca32KS
	f1zs3ucFtmtcl7uYpJtl3/A3THmxMVj2SJsSS3FGoqEWc1FxIgBYMuo2WgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAd3UhtwQgx3rtC0aroZY9C64ymax
	6fE1VovLu+awWcw4v4/JYtHWL+wObB6bl9R79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhDWPG/P2TmAvey1T83qHbwHhNvIuRk0NCwETi07xNzBC2mMSF
	e+vZuhi5OIQEFjFKnLn6iRnCmcAk0dHzhAmkik3AWOLnzv3sXYwcHCIC3hLLrymC1DALNDFK
	nJt3mRUkLizgLnFpvhBIOYuAqsSl3U1MIGFeATeJ5YfzQEwJAQWJOZNsQCo4gYqff9rDCGIL
	AVWcWrGYaQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdHxTHoH46oGi0OMAhyM
	Sjy8CRa5IUKsiWXFlbmHGCU4mJVEeD9VAoV4UxIrq1KL8uOLSnNSiw8xmgLdNJFZSjQ5Hxi5
	eSXxhsYm5qbGppYmFiZmlkrivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGF3Ptehf4QrcFPzm
	6WNVps8PzHbvd7geXrbTKX+KnafcliWPLgZsXePFdTGVd1mk+yq9y0/Xm8yz/XfmhYfirsw9
	co6/Vyj8LZ6R5RTmULOLV2BaadcZp2+x6QHbuILOnXg+L2OZ7de+nlWlh8K8r7f8KPrXmHdC
	b9fc9D0mz75EpZWnFW+JmKTEUpyRaKjFXFScCAC15ZLppAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves Exynos PMU driver implementation from "arm/mach-exynos"
to "drivers/soc/samsung". This driver is mainly used for setting misc
bits of register from PMU IP of Exynos SoC which will be required to
configure before Suspend/Resume. Currently all these settings are done
in "arch/arm/mach-exynos/pmu.c" but moving ahead for ARM64 based SoC
support, there is a need of this PMU driver in driver/* folder.

This driver uses existing DT binding information and there should
be no functionality change in the supported platforms.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Makefile                      |    2 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   20 ++++++++++++++++++++
 drivers/soc/samsung/Makefile                       |    1 +
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |    0
 6 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (100%)

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index bcefb54..b91b382 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,7 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o exynos-smc.o firmware.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..90f33b9 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -3,5 +3,6 @@ menu "SOC (System On Chip) specific Drivers"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
+source "drivers/soc/samsung/Kconfig"
 
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..44d220d 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
+obj-$(CONFIG_ARCH_EXYNOS)	+= samsung/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..a424ebc
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,20 @@
+#
+# SAMSUNG SOC drivers
+#
+menuconfig SOC_SAMSUNG
+	bool "Samsung SOC drivers support"
+
+if SOC_SAMSUNG
+
+config EXYNOS_PMU
+	bool "Support Exynos Power Management Unit"
+	depends on ARCH_EXYNOS
+	default y
+	help
+	  Exynos SoC have Power Management Unit (PMU) which controls power and
+	  operation state of various components in Exynos SoC. This driver
+	  provides implementation of PMU driver and provides various
+	  functionality like initialisation and transition to various low power
+	  states.
+
+endif #SOC_SAMSUNG
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
new file mode 100644
index 0000000..5a879c6
--- /dev/null
+++ b/drivers/soc/samsung/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o
diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/soc/samsung/exynos-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/pmu.c
rename to drivers/soc/samsung/exynos-pmu.c
-- 
1.7.9.5

