Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaEJGiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14528 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaEJGiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:22 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-9b-536dc95d40ef
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 00/11] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Sat, 10 May 2014 15:56:27 +0900
Message-id: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t8zI93Yk7nBBu9mcVssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgylg+8y9bwXyjimf9m5gbGP+odzFyckgImEgs/3GU
	FcIWk7hwbz1bFyMXh5DAMkaJtx8uMsMUzT96lxkiMZ1RYsLPq1BVbUwS12atYQOpYhPQlXjy
	fi5Yh4hAtsSVxvtgHcwCuxklGhvngRUJC/hLzDm4Amwfi4CqxMK5f1hAbF4BD4n2D/1ANRxA
	6xQk5kyyAemVEOhnl1g/ez4jRL2AxLfJh1ggamQlNh2Auk5S4uCKGywTGAUXMDKsYhRNLUgu
	KE5KLzLWK07MLS7NS9dLzs/dxAgJ5P4djHcPWB9iTAYaN5FZSjQ5HxgJeSXxhsZmRhamJqbG
	RuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcSL7sqMr4lYf2cdbJzyt
	uSbfVqnLraZfYn34jlNuT/ttml2rb0qKef9JmZ7fdG/XpA2X19xjUJrHZH/wtRDzvFksGZeC
	y07PnrBH/8jUib37yiM+aSdvYphWu/H7Gzn5R997z15/U5RZxSPBWR1W+o3/eFzC7QP/DHi2
	bSpgF7VZvv5OJKNUnBJLcUaioRZzUXEiAH1Q9G16AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jQd3Yk7nBBvt3s1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixfOZftoL5
	RhXP+jcxNzD+Ue9i5OSQEDCRmH/0LjOELSZx4d56ti5GLg4hgemMEhN+XoVy2pgkrs1awwZS
	xSagK/Hk/VywDhGBbIkrjfeZQYqYBXYzSjQ2zgMrEhbwl5hzcAUriM0ioCqxcO4fFhCbV8BD
	ov1DP1ANB9A6BYk5k2wmMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcJ8+kdzCu
	arA4xCjAwajEw1v4NidYiDWxrLgy9xCjBAezkgjvioO5wUK8KYmVValF+fFFpTmpxYcYk4GW
	T2SWEk3OB8ZwXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	+jJYPz3Z/3HRtPcrbTjfPnEOOdX14bGh16/nR1SnCXDWP1hbJLum08/36BzJP198U2Kyl8fp
	xFo/Tey6E/yLUfX75dvsfEU761heuc08XOqxZ0PCVu9PqVO6MqOqpj7NOCAv/ohR7e/XlQIB
	p44cPtk14YHg5XU7H9x4rns3pPays03B8jU3eJRYijMSDbWYi4oTAbAK5IXXAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, does some minor cleanup of exynos machine files.
It also modifies Exynos Power Management Unit (PMU) related code for
converting it into a platform_driver. This is also preparation for moving
PMU related code out of machine folder into a either "drivers/mfd", or
"drivers/power" or some other suitable place so that ARM64 based SoC can
utilize common piece of code.

These patches require change in Exynos4 SoC dtsi files, which has been
posted as separate patch series. 

These patches are created on top of Kukjin Kim's for-next (v3.15-rc1 tag)
branch and on top of Daniel Lezcano's Exynos cpuidle refactor patches [2].

These patches depends on following three patch series:
[1] mfd: syscon: Support early initialization
    https://lkml.org/lkml/2014/4/8/239
[2] Daniel Lezcano's Exynos cpuidle refactor patches
    http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085
[3] Allow NULL property in syscon_early_regmap_lookup_by_phandle
    https://lkml.org/lkml/2014/5/10/10 and
    https://lkml.org/lkml/2014/4/29/661

We have tested these patches on SMDK5250 board for System boot and
Arndale (Exynos5250) board for System boot and PMU initialization and S2R.

For testing on Arndale (Exynos5250) board:
Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Changes Since v3:
 - Addressed build fail issue in exynos.c as reported by Sachin Kamat.
 - Optimized exynos_pmu_probe function by removing exynos_pmu_data_init
   as suggested by Vikas Sajjan.
 - Rebased on top of Sysram patches by Sachin Kamat.
 - Modified syscon_early_regmap_lookup_by_phandle and
   syscon_regmap_lookup_by_phandle function call to pass property as NULL.

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

Pankaj Dubey (7):
  ARM: EXYNOS: Make exynos machine_ops as static
  ARM: EXYNOS: Move cpufreq and cpuidle device registration to
    init_machine
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

 arch/arm/Kconfig                             |    1 +
 arch/arm/mach-exynos/common.h                |   27 +-
 arch/arm/mach-exynos/exynos-pmu.h            |   31 ++
 arch/arm/mach-exynos/exynos.c                |   84 +++--
 arch/arm/mach-exynos/headsmp.S               |    2 -
 arch/arm/mach-exynos/hotplug.c               |    7 +-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/include/mach/memory.h   |    3 +-
 arch/arm/mach-exynos/platsmp.c               |   42 ++-
 arch/arm/mach-exynos/pm.c                    |   79 ++--
 arch/arm/mach-exynos/pm_domains.c            |    8 +-
 arch/arm/mach-exynos/pmu.c                   |  271 +++++++++++---
 arch/arm/mach-exynos/regs-pmu.h              |  512 +++++++++++++-------------
 arch/arm/mach-exynos/regs-sys.h              |   22 ++
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 15 files changed, 665 insertions(+), 428 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.10.4

