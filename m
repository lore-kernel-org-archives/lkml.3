Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaFYOGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:06:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26411 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaFYOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:06:28 -0400
X-AuditID: cbfee690-b7fb56d000003439-75-53aad7622ced
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 0/5] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Wed, 25 Jun 2014 19:33:47 +0530
Message-id: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkRjfp+qpgg0l9shbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrHoWMZocfPZdiYHHo+W
	5h42j81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro//VYaaCF2oVq3ctYmpgfCvXxcjJ
	ISFgIjFx+WlGCFtM4sK99WxdjFwcQgJLGSWeflzBBFM0f0YvO0RiOqPEpfPXmSCcCUwSrdPe
	sYNUsQnoSjx5P5cZxBYRyJbov72aBaSIWeAxo8SblUfBdggL+Ep0r98K1sAioCpxaeVrFhCb
	V8BDYsG7btYuRg6gdQoScybZgPRKCMxjl9i8bj4rRL2AxLfJh1ggamQlNh1ghrhOUuLgihss
	ExgFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDO3T/55N2MF474D1IcZkoHETmaVE
	k/OBsZFXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYxJv5f318T4SM8VjdjZ9fG78JacbiNXdo4PnPl8/XGTfr5d56P0e9sbuzcTLMT5T87ZtOur
	8r+3727tzXW6q9CnulRyVl2w8Zkp83b93TVzPePdGYZmpbyLwxcanpeWVevaq7JKueWCX3Hj
	7Z3t7v+qlmkcquqUrpfQWTLPnl3/IMf6oDen5GqVWIozEg21mIuKEwGg+sDogwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd2k66uCDbquClksm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsWiYxmjxc1n25kceDxa
	mnvYPDYvqffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoMOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBn9rw4zFbxQq1i9axFTA+NbuS5GTg4JAROJ+TN62SFsMYkL99azdTFycQgJTGeUuHT+OhOE
	M4FJonXaO7AqNgFdiSfv5zKD2CIC2RL9t1ezgBQxCzxmlHiz8igjSEJYwFeie/1WsAYWAVWJ
	Sytfs4DYvAIeEgvedbN2MXIArVOQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwZHzTHoH46oGi0OMAhyMSjy8F2avDBZiTSwrrsw9xCjBwawkwuu+f1WwEG9KYmVValF+
	fFFpTmrxIUZToOUTmaVEk/OBUZ1XEm9obGJuamxqaWJhYmapJM57sNU6UEggPbEkNTs1tSC1
	CKaPiYNTqoFx1eP7Khs2uIdftEoKdN28ROq/QdT7RRrue5Yprfz66MH99R/LZM/tY/g9YXXd
	ytNidqUcq1hl1j5LbfOwaZsZ+mFmQYfF6+4b/u+7ipJvXuiP95m/WVrl9Y7so7drgzaG6Vy+
	ONM7Q2NXuruZ6GrlsLS1P+6dCngXKaDw6wbrnPWparcOakUaK7EUZyQaajEXFScCABZZaxiy	AgAA
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
I have tested this patches on Exynos5250 Snow board for system boot and S2R.

This patch series depends on following two patch series:
[1]: mfd: syscon: Decouple syscon interface from syscon devices.
     https://lkml.org/lkml/2014/6/24/188

[2]: Cleanup patches for mach-exynos.
     http://www.spinics.net/lists/arm-kernel/msg341474.html

Patch v4 and discussion can be found here:
https://lkml.org/lkml/2014/5/10/29

Changes Since v4:
 - Splitted patch series in two parts. Part 1 has code cleanup under mach-exynos
   and posted as separate patch [2]. Current patchset is part 2 which modified
   exynos pmu implementation for making it platform driver.
 - Removed dependency over early_syscon API.
 - Removed usage of regmap read/write APIs.
 - Modified probe function to register exynos pmu as syscon provider using
   Tomasz Figa's syscon patch [1].
 - Address various other review comments from Tomasz Figa.
 - Removed signed-off-by of Young-Gun Jang <yg1004.jang@samsung.com>,
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

Pankaj Dubey (5):
  ARM: EXYNOS: Add support for mapping PMU base address via DT
  ARM: EXYNOS: Refactored code for using PMU address via DT
  ARM: EXYNOS: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
  ARM: EXYNOS: Add platform driver support for Exynos PMU
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig                 |    1 +
 arch/arm/mach-exynos/common.h                |   18 +-
 arch/arm/mach-exynos/exynos-pmu.h            |   31 ++
 arch/arm/mach-exynos/exynos.c                |   63 +++-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/mcpm-exynos.c           |    5 +-
 arch/arm/mach-exynos/platsmp.c               |    4 +-
 arch/arm/mach-exynos/pm.c                    |   80 ++--
 arch/arm/mach-exynos/pmu.c                   |  223 ++++++++---
 arch/arm/mach-exynos/regs-pmu.h              |  510 +++++++++++++-------------
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 11 files changed, 556 insertions(+), 383 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

-- 
1.7.9.5

