Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbaD3FCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:02:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaD3E7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:43 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-5d-53608339d6f5
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 00/12] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Wed, 30 Apr 2014 14:17:25 +0900
Message-id: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t8zY13L5oRgg52PTSyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZaxdtJWp4KdexaZpK9kaGNerdjFyckgImEjc7jzM
	DmGLSVy4t56ti5GLQ0hgGaPErKfvWGGKGq51MkMkFjFKvNz+BCwhJNDGJDHznTaIzSagK/Hk
	/VxmEFtEIFviSuN9sAZmgd2MEo2N89hAEsIC/hKfbt5nBLFZBFQldpxfCWbzCrhLnHu2HGgo
	B9A2BYk5k2xAeiUEJrNL/D3cDlUvIPFt8iEWiBpZiU0HmCGOk5Q4uOIGywRGwQWMDKsYRVML
	kguKk9KLTPSKE3OLS/PS9ZLzczcxQsJ4wg7GewesDzEmA42byCwlmpwPjIO8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUOSZi/CJi//0pQTPv
	xPa/Nd1YVXUvc/EKx9YzzktS9ELlFFpn+8oG+hg9+Pt17qGfemyHeL8cOfy4r8i/4G99yC7j
	vI+zl87e82ii2I/posm9B5afOMLULr7Y07W3LZm75LOzx9n191en3c/I+OKflrsyU9Fh5iX7
	h7Mz5ZrM7T2nlRiGcPQosRRnJBpqMRcVJwIAQ/AaPHkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAV3L5oRgg2UT9S2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xYu2grU8FP
	vYpN01ayNTCuV+1i5OSQEDCRaLjWyQxhi0lcuLeerYuRi0NIYBGjxMvtT1hBEkICbUwSM99p
	g9hsAroST97PBWsQEciWuNJ4nxmkgVlgN6NEY+M8NpCEsIC/xKeb9xlBbBYBVYkd51eC2bwC
	7hLnni0HGsoBtE1BYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfJM6kd
	jCsbLA4xCnAwKvHwCmyNDxZiTSwrrsw9xCjBwawkwnu+MiFYiDclsbIqtSg/vqg0J7X4EGMy
	0PKJzFKiyfnACM4riTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BsbFK3a/vu0msJxZ232ijJrWzEcLftXxhH76YCK+dd6ElHMBNwVOXee+VKAv2Dvx3EFNQe/L
	R5TevPv347nD2wmlzrfin94VfqcltjGD8Xzh4v2CvldCCm98fTZN+3nupgLfuIifKdKdT2xV
	rNvlY++/Z3V9wDDdLFfDX1vj2f7c9wcv38h7Oy9TiaU4I9FQi7moOBEA+h08/9YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, does some minor cleanup of exynos machine files.
It also modifies Exynos Power Management Unit (PMU) related code for
converting it into a platform_driver.
This is also preparation for moving PMU related code out of machine
folder into a either "drivers/mfd", or "drivers/power" or some other
suitable place so that ARM64 based SoC can utilize common piece of code.
These patches require change in Exynos SoC dtsi files, which has been
posted as separate patch series [2]

These patches are created on top of Kukjin Kim's for-next (v3.15-rc1 tag)
branch and on top of Daniel Lezcano's Exynos cpuidle refactor patches [3].

These patches depends on following three patch series:
[1] mfd: syscon: Support early initialization
    https://lkml.org/lkml/2014/4/8/239
[2] Add PMU node for Exynos SoCs
    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29329.html
[3] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085  

We have tested these patches on SMDK5250 board for System boot and
Arndale (Exynos5250) board for System boot and PMU initialization and S2R.

For testing on Arndale (Exynos5250) board:
Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Changes Since v2:
 - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
 - Removed exynos_cpuidle_init and exynos_cpufreq_init code as suggested
   by Tomasz Figa.
 - Removed early mapping of PMU base address from exynos.c and removed
   "get_exynos_pmuaddr" function. Instead of this added code in platsmp.c
   to get PMU base address using of_iomap as suggested by Tomasz Figa.
 - Converted PMU implementation into platform_driver by using static
   platform_device method. 

Changes Since v1:
 - Rebased on latest for-next of Kukjin Kim's tree.
 - Added patch: "Make exynos machine_ops as static". 
	For making more cleanup in "mach-exynos/common.h"
	as suggested by Tomasz Figa.
 - Addressed comments of Tomasz Figa for cleaning "mach-exynos/common.h".
 - Updated patch: Remove file path from comment section
	As suggested by Michel Simek, instead of updating file path
	lets remove them from each file under "mach-exynos".
	Even though Kukjin pointed out that there is similar patch pending from
	Sachin/Tushar but since I could not find I have included this here. If
	I have missed something please point to any existing such patch.
 - Updated patch: Add support for mapping PMU base address via DT
	- Removed __initdata from declaration of "exynos_pmu_base", as it caused
	kernel crash as pointed out by Vikas Sajjan.
	- Added support for Syscon initialization and getting PMU regmap handle
	as suggested by Sylwester. Since current implementation of early
	intialization [1] has limitation that "early_syscon_init" requires
	DT to be unflattened and system should be able to allocate memory,
	we can't use regmap handles for platsmp.c file as "smp_secondary_init"
	will be called before DT unflattening. So I have kept both method for
	accessing PMU base address. platsmp.c will use ioremmaped address where
	as rest other files can use regmap handle.
 - Added patch: Remove "linux/bug.h" from pmu.c.
 - Updated patch: Refactored code for PMU register mapping via DT
	- Modified to use regmap_read/write when using regmap handle.
 - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
 - Added patch: Add device tree based initialization support for PMU.
	- Convert existing PMU implementation to be a device tree based 
	 before moving it to "drivers/mfd" folder. As suggested by Bartlomiej.
	- Dropped making a platform_driver for PMU, as currently PMU binding
	has two compatibility strings as "samsung, exynosxxx-pmu", "syscon",
	once we	enable MFD_SYSCON config option, current "syscon" driver probe
	gets called and PMU probe never gets called. So modified PMU
	initialization code to scan DT and match against supported compatiblity
	string in driver code, and once we get matching node use that for
	accessing PMU regmap handle using "syscon_early_regmap_lookup_by_phandle".
	If there is any better solution please suggest.

Pankaj Dubey (8):
  ARM: EXYNOS: Make exynos machine_ops as static
  ARM: EXYNOS: Move cpufreq and cpuidle device registration to
    init_machine
  ARM: EXYNOS: Cleanup "mach-exynos/common.h" file
  ARM: EXYNOS: Remove file path from comment section
  ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
  ARM: EXYNOS: Refactored code for using PMU address via DT
  ARM: EXYNOS: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
  ARM: EXYNOS: Add platform driver support for Exynos PMU.

Young-Gun Jang (4):
  ARM: EXYNOS: Move SYSREG definition into sys-reg specific file.
  ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
  ARM: EXYNOS: Add support for mapping PMU base address via DT
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig                 |    2 +
 arch/arm/mach-exynos/common.h                |   28 +-
 arch/arm/mach-exynos/exynos-pmu.h            |   31 ++
 arch/arm/mach-exynos/exynos.c                |   84 +++--
 arch/arm/mach-exynos/headsmp.S               |    2 -
 arch/arm/mach-exynos/hotplug.c               |    7 +-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/include/mach/memory.h   |    3 +-
 arch/arm/mach-exynos/platsmp.c               |   42 ++-
 arch/arm/mach-exynos/pm.c                    |   79 ++--
 arch/arm/mach-exynos/pm_domains.c            |    8 +-
 arch/arm/mach-exynos/pmu.c                   |  285 +++++++++++---
 arch/arm/mach-exynos/regs-pmu.h              |  512 +++++++++++++-------------
 arch/arm/mach-exynos/regs-sys.h              |   22 ++
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 15 files changed, 680 insertions(+), 429 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.10.4

