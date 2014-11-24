Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaKXCNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:13:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaKXCMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:46 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-84-5472941be1b4
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 2/5] drivers: soc: Add support for Exynos PMU driver
Date: Mon, 24 Nov 2014 07:36:12 +0530
Message-id: <1416794775-1605-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
References: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkRld6SlGIwdINBhYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dkcfsyr8WirV/YHdg9Wpp72Dw2L6n36NuyitHj8ya5AJYoLpuU1JzM
	stQifbsErozj7/+xFlyTqdh34gFbA+N+8S5GTg4JAROJfd8bWSFsMYkL99azgdhCAksZJaac
	t4SpOXyhF6iGCyg+nVHi37tDLBDOBCaJXYvusoBUsQkYS/zcuZ+9i5GDQ0TAW2L5NUWQGmaB
	1YwSfy5sZQKpERZwl5jY+YQZxGYRUJV4de4UI4jNK+AmsfnrJLBeCQEFiTmTbEDCnEDlzUfn
	M0Ic5Cax53sHE8hMCYHJ7BLPLu1igpgjIPFtMshBIL2yEpsOMEMcLSlxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBAb16X/PJuxgvHfA+hCjAAejEg/vh9bCECHWxLLi
	ytxDjKZAGyYyS4km5wNjJ68k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYxeLAJ8ljN29bx1krbxLXw7v7h+3s6NS+8fvT6ZQ3ex7ufTCy9pT737aKcW
	43E/rlteLw0suS8klK5PVzF6fNax7mfEermNtX7KMgpemsc6xMLes7drasw/eu98od7HHEnd
	qKdNUSEluT9LvhlPdvzw8F+TsUjBefaMrc8jO+N2M1n4q/o+sFViKc5INNRiLipOBAC9zOQl
	ZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQV3pKUUhBjdnq1s0XA2x6F1wlc1i
	0+NrrBaXd81hs5hxfh+Txe3LvBaLtn5hd2D3aGnuYfPYvKTeo2/LKkaPz5vkAliiGhhtMlIT
	U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D2KymUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzjr//x1pwTaZi34kHbA2M+8W7GDk5JARM
	JA5f6GWFsMUkLtxbz9bFyMUhJDCdUeLfu0MsEM4EJoldi+6ygFSxCRhL/Ny5n72LkYNDRMBb
	Yvk1RZAaZoHVjBJ/LmxlAqkRFnCXmNj5hBnEZhFQlXh17hQjiM0r4Cax+esksF4JAQWJOZNs
	QMKcQOXNR+eDlQgBlez53sE0gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgqHkm
	vYNxVYPFIUYBDkYlHt6PrYUhQqyJZcWVuYcYJTiYlUR4z/4DCvGmJFZWpRblxxeV5qQWH2I0
	BTpqIrOUaHI+MKLzSuINjU3MTY1NLU0sTMwslcR5b9zMDRESSE8sSc1OTS1ILYLpY+LglGpg
	TNvq/+lx3Bue/6dNTBIO7u/oXf190lQGXd2q/at9t/vdfvr4qvK93xNUpnwQeR/0NW+m8AZf
	v09Zagr22ete1L1fJL7MgumFS+Hk5DSWB9qFR7iX+PxxfyV99KyeW8oa1uPyKreebYwR2byw
	+d+Zmff6zlzdUNppweV/+2HIzq/5HxwuW33Y0qvEUpyRaKjFXFScCABF5VlssAIAAA==
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
index 063113d..fcd7e37 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
+obj-$(CONFIG_SOC_SAMSUNG)	+= samsung/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..6855cc4
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,20 @@
+#
+# SAMSUNG SOC drivers
+#
+menu "Samsung SOC drivers support"
+
+config SOC_SAMSUNG
+	bool
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
+endmenu
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

