Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaECBeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 21:34:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32086 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaECBeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 21:34:16 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-dc-53644796cacf
Message-id: <53644BD4.4060200@samsung.com>
Date: Sat, 03 May 2014 10:52:20 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com
Subject: Re: [PATCH v3 00/12] ARM: Exynos: PMU cleanup and refactoring for
 using DT
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA91p7inBBntWSFosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyjg5dw5zwRqjisXLT7A1MC5U72Lk5JAQMJHo/fOe
	BcIWk7hwbz1bFyMXh5DAMkaJbc1vmGGKJk2ZwAyRWMQosbmzH6rqNaPEpbZGNpAqXgEtiRnb
	FgHZHBwsAqoSyzuiQcJsAroST97PBRskKhAmsWl6HytEuaDEj8n3wDaLCERI9J5aAraAWeAc
	o8S+Zz9YQOYIC4RKrPwRA1IjJOAu0dDQwwhicwp4SCy8/RtsDrOAtcTKSdsYIWx5ic1r3oLN
	kRC4xy5xaf86JpAEi4CAxLfJh8BmSgjISmw6APWYpMTBFTdYJjCKzUJy0iwkY2chGbuAkXkV
	o2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkgc9u1gvHnA+hBjMtDKicxSosn5wDjOK4k3NDYz
	sjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MgnIbGD+vDV5r
	7/P5aJSiWF2zfdGODpH2qa+yLMz376t2zQqsvr7+YPHpuHPP635MO5BYI9+ydO0W1ukXmFYH
	LWuusHjNaum6ZhmX9d9Df8+z/z0h9v38c8m/+xaUvPe5cHXzpS8lp22KhGwO73990kpZ70lT
	3v111//rC4hluS3Yt+D+XX7uz0osxRmJhlrMRcWJABNzaXfZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd1p7inBBtc3CFssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hxcu4c5oI1
	RhWLl59ga2BcqN7FyMkhIWAiMWnKBGYIW0ziwr31bF2MXBxCAosYJTZ39kM5rxklLrU1soFU
	8QpoSczYtgjI5uBgEVCVWN4RDRJmE9CVePJ+LtggUYEwiU3T+1ghygUlfky+xwJiiwhESPSe
	WsIMMpNZ4ByjxL5nP1hA5ggLhEqs/BEDUiMk4C7R0NDDCGJzCnhILLz9G2wOs4C1xMpJ2xgh
	bHmJzWveMk9gFJiFZMUsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc5c+k
	djCubLA4xCjAwajEw6twNzlYiDWxrLgy9xCjBAezkggvi2ZKsBBvSmJlVWpRfnxRaU5q8SHG
	ZGAATGSWEk3OByagvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLg
	lGpgnCtQN/lCqnb+/VvLFSWL9+iIaaRsqDkQfOisksQP/scXuVofGPluZ95ybrONxkXjfTIq
	XOsnOe9fzFrAYLHdbsLGia7XHtnmcGZZz2Y//fnUvA6vB4sCVVpDTFLub1S9fjwpzOKgOiO7
	fOFkSR7L+U+SXItvXH7Qfjouge9VJv+N9ttGpTxcSizFGYmGWsxFxYkAbGvMzDYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Gentle ping.

Tomasz, Kukjin will you please have a look on this series.


Thanks,
Pankaj Dubey

On 04/30/2014 02:17 PM, Pankaj Dubey wrote:
> This patch series, does some minor cleanup of exynos machine files.
> It also modifies Exynos Power Management Unit (PMU) related code for
> converting it into a platform_driver.
> This is also preparation for moving PMU related code out of machine
> folder into a either "drivers/mfd", or "drivers/power" or some other
> suitable place so that ARM64 based SoC can utilize common piece of code.
> These patches require change in Exynos SoC dtsi files, which has been
> posted as separate patch series [2]
>
> These patches are created on top of Kukjin Kim's for-next (v3.15-rc1 tag)
> branch and on top of Daniel Lezcano's Exynos cpuidle refactor patches [3].
>
> These patches depends on following three patch series:
> [1] mfd: syscon: Support early initialization
>      https://lkml.org/lkml/2014/4/8/239
> [2] Add PMU node for Exynos SoCs
>      http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29329.html
> [3] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085
>
> We have tested these patches on SMDK5250 board for System boot and
> Arndale (Exynos5250) board for System boot and PMU initialization and S2R.
>
> For testing on Arndale (Exynos5250) board:
> Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>
> Changes Since v2:
>   - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
>   - Removed exynos_cpuidle_init and exynos_cpufreq_init code as suggested
>     by Tomasz Figa.
>   - Removed early mapping of PMU base address from exynos.c and removed
>     "get_exynos_pmuaddr" function. Instead of this added code in platsmp.c
>     to get PMU base address using of_iomap as suggested by Tomasz Figa.
>   - Converted PMU implementation into platform_driver by using static
>     platform_device method.
>
> Changes Since v1:
>   - Rebased on latest for-next of Kukjin Kim's tree.
>   - Added patch: "Make exynos machine_ops as static".
> 	For making more cleanup in "mach-exynos/common.h"
> 	as suggested by Tomasz Figa.
>   - Addressed comments of Tomasz Figa for cleaning "mach-exynos/common.h".
>   - Updated patch: Remove file path from comment section
> 	As suggested by Michel Simek, instead of updating file path
> 	lets remove them from each file under "mach-exynos".
> 	Even though Kukjin pointed out that there is similar patch pending from
> 	Sachin/Tushar but since I could not find I have included this here. If
> 	I have missed something please point to any existing such patch.
>   - Updated patch: Add support for mapping PMU base address via DT
> 	- Removed __initdata from declaration of "exynos_pmu_base", as it caused
> 	kernel crash as pointed out by Vikas Sajjan.
> 	- Added support for Syscon initialization and getting PMU regmap handle
> 	as suggested by Sylwester. Since current implementation of early
> 	intialization [1] has limitation that "early_syscon_init" requires
> 	DT to be unflattened and system should be able to allocate memory,
> 	we can't use regmap handles for platsmp.c file as "smp_secondary_init"
> 	will be called before DT unflattening. So I have kept both method for
> 	accessing PMU base address. platsmp.c will use ioremmaped address where
> 	as rest other files can use regmap handle.
>   - Added patch: Remove "linux/bug.h" from pmu.c.
>   - Updated patch: Refactored code for PMU register mapping via DT
> 	- Modified to use regmap_read/write when using regmap handle.
>   - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
>   - Added patch: Add device tree based initialization support for PMU.
> 	- Convert existing PMU implementation to be a device tree based
> 	 before moving it to "drivers/mfd" folder. As suggested by Bartlomiej.
> 	- Dropped making a platform_driver for PMU, as currently PMU binding
> 	has two compatibility strings as "samsung, exynosxxx-pmu", "syscon",
> 	once we	enable MFD_SYSCON config option, current "syscon" driver probe
> 	gets called and PMU probe never gets called. So modified PMU
> 	initialization code to scan DT and match against supported compatiblity
> 	string in driver code, and once we get matching node use that for
> 	accessing PMU regmap handle using "syscon_early_regmap_lookup_by_phandle".
> 	If there is any better solution please suggest.
>
> Pankaj Dubey (8):
>    ARM: EXYNOS: Make exynos machine_ops as static
>    ARM: EXYNOS: Move cpufreq and cpuidle device registration to
>      init_machine
>    ARM: EXYNOS: Cleanup "mach-exynos/common.h" file
>    ARM: EXYNOS: Remove file path from comment section
>    ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
>    ARM: EXYNOS: Refactored code for using PMU address via DT
>    ARM: EXYNOS: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
>    ARM: EXYNOS: Add platform driver support for Exynos PMU.
>
> Young-Gun Jang (4):
>    ARM: EXYNOS: Move SYSREG definition into sys-reg specific file.
>    ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
>    ARM: EXYNOS: Add support for mapping PMU base address via DT
>    ARM: EXYNOS: Move PMU specific definitions from common.h
>
>   arch/arm/mach-exynos/Kconfig                 |    2 +
>   arch/arm/mach-exynos/common.h                |   28 +-
>   arch/arm/mach-exynos/exynos-pmu.h            |   31 ++
>   arch/arm/mach-exynos/exynos.c                |   84 +++--
>   arch/arm/mach-exynos/headsmp.S               |    2 -
>   arch/arm/mach-exynos/hotplug.c               |    7 +-
>   arch/arm/mach-exynos/include/mach/map.h      |    3 -
>   arch/arm/mach-exynos/include/mach/memory.h   |    3 +-
>   arch/arm/mach-exynos/platsmp.c               |   42 ++-
>   arch/arm/mach-exynos/pm.c                    |   79 ++--
>   arch/arm/mach-exynos/pm_domains.c            |    8 +-
>   arch/arm/mach-exynos/pmu.c                   |  285 +++++++++++---
>   arch/arm/mach-exynos/regs-pmu.h              |  512 +++++++++++++-------------
>   arch/arm/mach-exynos/regs-sys.h              |   22 ++
>   arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
>   15 files changed, 680 insertions(+), 429 deletions(-)
>   create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
>   create mode 100644 arch/arm/mach-exynos/regs-sys.h
>


-- 
Best Regards,
Pankaj Dubey

