Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaGGFW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:22:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31487 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaGGFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:22:17 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-04-53ba2e84ff2a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 0/4] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Mon, 07 Jul 2014 10:49:32 +0530
Message-id: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkRrdFb1ewQcsea4tlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVsfnRH5aCSZoVf3fsYGxgvKPQxcjB
	ISFgIrH2WXkXIyeQKSZx4d56ti5GLg4hgaWMEvP2v2GHSJhItK1+A5VYxChx4e0JZghnApPE
	i7/HmEGq2AR0JZ68nwtmiwhkS/TfXs0CUsQs8JhR4s3Ko4wgCWEBX4npbz6xgdgsAqoS0671
	gtm8Ah4S+z43MkGcpCAxZ5INxObp7BK/v2pClAtIfJt8iAWiRFZi0wFmiBJJiYMrbrBMYBRc
	wMiwilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMwrE//e9a3g/HmAetDjMlA4yYyS4km5wPj
	Iq8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MOop
	XlIS9XeO3WFS9n4rf7Xiqf8p0qIN6++sm/hDVP/p1eyI93X3Zfec8xI0VHRTu3Vx56LV6TWS
	m6zK1c+pte5UUdQt0lN7Fb3NRKzy047r1gla5+5nhQsacD6cqK6ylUt0VYat7tMPSuvWNq1f
	/NfrwKpllose7WV1tVpRenDZ4rdLOmrWnVRiKc5INNRiLipOBACYqe9mgQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd0WvV3BBmf6DC2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VotFW4Eq1s94zWLRsYzR4uaz7UwOPB4t
	zT1sHpuX1Hv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0GFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIa
	xozNj/6wFEzSrPi7YwdjA+MdhS5GTg4JAROJttVv2CBsMYkL99YD2VwcQgKLGCUuvD3BDOFM
	YJJ48fcYM0gVm4CuxJP3c8FsEYFsif7bq1lAipgFHjNKvFl5lBEkISzgKzH9zSewsSwCqhLT
	rvWC2bwCHhL7PjcydTFyAK1TkJgzyWYCI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMGR80xqB+PKBotDjAIcjEo8vAdW7QwWYk0sK67MPcQowcGsJMJ7xg0oxJuSWFmVWpQfX1Sa
	k1p8iNEUaPlEZinR5HxgVOeVxBsam5ibGptamliYmFkqifMeaLUOFBJITyxJzU5NLUgtgulj
	4uCUamCctkVxorqV7OO5F0Xi/+T+Cz5y49cJE2U3xZ17k18o8Rxklc3onbJqWZ/pzifXClh/
	XQ8sdHRccX1ajumMX08fl4fHRvoWbus6afQgPnqCR/4M6wDBjL/P13S3RoVeP37D9ODZZ3M4
	f2WfPKqm+ENOsrVdQ9PyTsW7Q2Va3gsygtIPXray7l2pxFKckWioxVxUnAgAMkVYZ7ICAAA=
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

Patch v5 and discussion can be found here:
http://www.spinics.net/lists/arm-kernel/msg344841.html

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


Pankaj Dubey (4):
  ARM: EXYNOS: Add support for mapping PMU base address via DT
  ARM: EXYNOS: Refactored code for using PMU address via DT
  ARM: EXYNOS: Add platform driver support for Exynos PMU
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig                 |    1 +
 arch/arm/mach-exynos/common.h                |   18 +-
 arch/arm/mach-exynos/exynos-pmu.h            |   24 ++
 arch/arm/mach-exynos/exynos.c                |   49 ++-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/mcpm-exynos.c           |    9 +-
 arch/arm/mach-exynos/platsmp.c               |    4 +-
 arch/arm/mach-exynos/pm.c                    |   87 +++--
 arch/arm/mach-exynos/pmu.c                   |  228 ++++++++---
 arch/arm/mach-exynos/regs-pmu.h              |  522 +++++++++++++-------------
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 11 files changed, 559 insertions(+), 387 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

-- 
1.7.9.5

