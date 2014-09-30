Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaI3K02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:26:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25741 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaI3K0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:26:16 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-3b-542a85460476
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v8 0/2] ARM: Exynos: Convert PMU implementation into a platform
 driver
Date: Tue, 30 Sep 2014 15:51:19 +0530
Message-id: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkTtetVSvEoO82t0XvgqtsFpseX2O1
	uLxrDpvFjPP7mCxuX+a1+HT0P6vFoq1f2C06ljFarNr1h9Hi5rPtTA5cHi3NPWweO2fdZffY
	vKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDLurHvFXtClXnHyxA+WBsYT8l2MnBwSAiYS
	EyatYIewxSQu3FvPBmILCSxllPjQbAVTs7BrAlANF1B8OqPEuX3dLBBFE5gkpj4OBrHZBHQl
	nryfywxiiwhkS/z4NhmshllgN6PE289iILawQITEzNP3mEBsFgFViasXTrCC2LwCHhKzL/4C
	WsABtExBYs4kG4i9/ewS++6VQpQLSHybfIgFokRWYtMBZogSSYmDK26wTGAUXMDIsIpRNLUg
	uaA4Kb3IRK84Mbe4NC9dLzk/dxMjMJBP/3s2YQfjvQPWhxgFOBiVeHg55LVChFgTy4orcw8x
	mgJtmMgsJZqcD4yXvJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MBqtev9/iWjg7KrWIrVNyzJ1MhmWyK9n9GZ5/VaNI7zVZ4WMAW/biX2L966a566W
	dzVJ5dBRu+C+74uuSTHWy7+JsHkzM5JXyW5p0K6AU8dbjO2NGu6cKP7xLU7M9GXBjNm/3nI3
	bJ53YqGGneJNSQZtM990f6/9SkwMtlo2iuX1a07/UpJ/r8RSnJFoqMVcVJwIAHgbQmxfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jQV23Vq0Qg//LmCx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rx+zKvxaej/1ktFm39wm7RsYzRYtWuP4wWN59tZ3Lg8mhp7mHz2DnrLrvH
	5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0k5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4866
	V+wFXeoVJ0/8YGlgPCHfxcjJISFgIrGwawI7hC0mceHeerYuRi4OIYHpjBLn9nWzgCSEBCYw
	SUx9HAxiswnoSjx5P5cZxBYRyJb48W0yWA2zwG5GibefxUBsYYEIiZmn7zGB2CwCqhJXL5xg
	BbF5BTwkZl/8BbSMA2iZgsScSTYTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO
	lWdSOxhXNlgcYhTgYFTi4eWQ1woRYk0sK67MPcQowcGsJML7tR4oxJuSWFmVWpQfX1Sak1p8
	iNEUaPlEZinR5HxgHOeVxBsam5ibGptamliYmFkqifMeaLUOFBJITyxJzU5NLUgtgulj4uCU
	amDcG3Y/OltRRuqBhKR+tmvKj6a/3Fpn0gqeeqbGX2bjSrlTpvmV3yTM85Tr0hOfK9eZHd4f
	drt44nmL6T1mNpMKLyp1KYiUlZ7tv9yTwvXmvePc8E/5fgZMtlstSyf1af+W+att5K9Q1FRs
	kNx6i0/vg8Ljw9YHT/393mF0kbs3dP+eB91lX5VYijMSDbWYi4oTAdsE1rOrAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, modifies Exynos Power Management Unit (PMU) related code
for converting it into a platform_driver. This is also preparation for moving
PMU related code out of machine folder into a either "drivers/mfd", or
"drivers/power" or some other suitable place so that ARM64 based SoC can
utilize common piece of code.

These patches are created on top of Kukjin Kim's for-next.

Vikas Sajjan have tested these patches on Exynos5420 based Peach board for
system boot and S2R.

This patch series depends on following patch series:
[1]: mfd: syscon: Decouple syscon interface from syscon devices.
     https://lkml.org/lkml/2014/9/30/156

Patch v7 and discussion can be found here:
https://lkml.org/lkml/2014/7/9/3

Change since v7:
 - Removing registration of syscon provider. As it will be handled now by
   syscon patch [1].
 - Rebased on top of latest kgene/for-next.
 
Change since v6:
 - Removed NULL check for pmu_data in pmu.c.
 - Moved pmu_raw_readl and pmu_raw_writel inline helper function
   into common.h.
  
Change Since v5:
 - Squashed patch "Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c"
   into patch "Refactored code for using PMU address via DT".
 - Addressed review comments from Tomasz Figa.
 - Using init_irq machine function to initialize PMU mapping instead
   of init_time.
 - Rebased on latest Kukjin Kim's for-next branch.

Changes Since v4:
 - Splitted patch series in two parts. Part 1 has code cleanup under mach-exynos
   and posted as separate patch [2]. Current patchset is part 2 which modified
   exynos pmu implementation for making it platform driver.
 - Removed dependency over early_syscon API.
 - Removed usage of regmap read/write APIs.
 - Modified probe function to register exynos pmu as syscon provider using
   Tomasz Figa's syscon patch [1].
 - Address various other review comments from Tomasz Figa.
 - Removed signed-off-by of Young-Gun Jang <yg1004.jang at samsung.com>,
   as this id is no more valid. Taking ownership of all his patches.

Changes Since v3:
 - Optimized exynos_pmu_probe function by removing exynos_pmu_data_init
   as suggested by Vikas Sajjan.
 - Modified syscon_early_regmap_lookup_by_phandle and
   syscon_regmap_lookup_by_phandle function call to pass property as NULL.

Changes Since v2:
 - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
 - Removed early mapping of PMU base address from exynos.c and removed
   "get_exynos_pmuaddr" function. Instead of this added code in platsmp.c
   to get PMU base address using of_iomap as suggested by Tomasz Figa.
 - Converted PMU implementation into platform_driver by using static
   platform_device method. 

Changes Since v1:
 - Rebased on latest for-next of Kukjin Kim's tree.
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
 - Updated patch: Refactored code for PMU register mapping via DT
	- Modified to use regmap_read/write when using regmap handle.
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

Pankaj Dubey (2):
  ARM: EXYNOS: Add platform driver support for Exynos PMU
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig      |    1 +
 arch/arm/mach-exynos/common.h     |   17 ----
 arch/arm/mach-exynos/exynos-pmu.h |   24 +++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |  191 ++++++++++++++++++++++++++++---------
 arch/arm/mach-exynos/suspend.c    |    1 +
 6 files changed, 175 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

-- 
1.7.9.5

