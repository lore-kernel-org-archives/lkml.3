Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGGDxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60128 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGGDxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:33 -0400
X-AuditID: cbfee690-b7fb56d000003439-50-53ba19bbbc11
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 0/6] Cleanup patches for mach-exynos
Date: Mon, 07 Jul 2014 09:20:50 +0530
Message-id: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkTne35K5gg4YzihbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxeN9hpoIuiYql378wNjBeF+pi5OSQEDCR
	2LGzkQ3CFpO4cG89kM3FISSwlFHifd8R9i5GDrCieZNqIeLTGSU2b/7MAuFMYJJovniTGaSb
	TUBX4sn7uWC2iEC2RP/t1WBFzAKnGCVmb57GDpIQFjCXeDF1ClgRi4CqxKwnu8BW8wp4SCyZ
	d5MVYpuCxJxJNiC9EgKT2SXmXl7JClEvIPFt8iEWiBpZiU0HmCGulpQ4uOIGywRGwQWMDKsY
	RVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAgP69L9nE3Yw3jtgfYgxGWjcRGYp0eR8YETklcQb
	GpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjhrpYder0
	yZ/YLueulz7Qq366L6ZTzLskX1Lz5dlqMZG8pM7LU3bqTDRycsnN/xKqXiBk2dzWeNZya/jp
	R7a5oif1rdcsDr8ZZ/OwImbK3/TJlvu0aivvn2ngeiuRUe7FUvFQJLFl6rl/9zuDt2hfEf6/
	yc7DuWN5tNTSKV1sKhtnMtVenabEUpyRaKjFXFScCABE2tfmfgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jQd3dkruCDVaskbBYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGYf3
	HWYq6JKoWPr9C2MD43WhLkYODgkBE4l5k2q7GDmBTDGJC/fWs3UxcnEICUxnlNi8+TMLhDOB
	SaL54k1mkCo2AV2JJ+/ngtkiAtkS/bdXgxUxC5xilJi9eRo7SEJYwFzixdQpYEUsAqoSs57s
	YgOxeQU8JJbMu8kKsVlBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfL
	M6kdjCsbLA4xCnAwKvHwHli1M1iINbGsuDL3EKMEB7OSCO8ZN6AQb0piZVVqUX58UWlOavEh
	RlOg5ROZpUST84GxnFcSb2hsYm5qbGppYmFiZqkkznug1TpQSCA9sSQ1OzW1ILUIpo+Jg1Oq
	gXEKU+MFlWOq8aFSV3lkYxa+6i2uKGB3yX5rsXe9zdmU2LDdyg9fTtgh5PWJb6eVp8MCudW6
	Hc8kT80sPZP1yOXu4XZVE7u/R4M9/prGGrFmHxaR77jzqfqR+Z63Z1uMv+pP9WKatnvtzb5l
	Hw8VSf7Yf6b8tUSearPQnD/3ZOanlD704zm60UeJpTgj0VCLuag4EQBsLTucrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is doing code cleanup under arch/arm/mach-exynos.
These patches have been separated from main exynos pmu v4 patch
posted here [1].

[1]: https://lkml.org/lkml/2014/5/10/29

Changes Since v5:
 - Rebased on latest for-next of Kukjin Kim's tree.
 - Using of_machine_is_compatible instead of soc_is_exynos in patch 2.

Changes Since v4:
 - Rebased on latest for-next of Kukjin Kim's tree.
 - Removing file path comment from mach-exynos/headsmp.S also.
 - Removed signed-off-by of Young-Gun Jang <yg1004.jang@samsung.com>,
   as this id is no more valid. Taking ownership of all his patches.
 - Separated these patches from main exynos pmu v4 patch series as
   suggested by Tomasz Figa.

Changes Since v3:
 - Addressed build fail issue in exynos.c as reported by Sachin Kamat.
 - Rebased on top of Sysram patches by Sachin Kamat.

Changes Since v2:
 - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
 - Removed exynos_cpuidle_init and exynos_cpufreq_init code as suggested
   by Tomasz Figa.

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
 - Added patch: Remove "linux/bug.h" from pmu.c.
 - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c


Pankaj Dubey (6):
  ARM: EXYNOS: Make exynos machine_ops as static
  ARM: EXYNOS: Move cpufreq and cpuidle device registration to
    init_machine
  ARM: EXYNOS: Move SYSREG definition into sys-reg specific file
  ARM: EXYNOS: Remove file path from comment section
  ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
  ARM: EXYNOS: Remove "linux/bug.h" from pmu.c

 arch/arm/mach-exynos/common.h              |    8 --------
 arch/arm/mach-exynos/exynos.c              |   27 ++++++++-------------------
 arch/arm/mach-exynos/headsmp.S             |    1 -
 arch/arm/mach-exynos/hotplug.c             |    3 +--
 arch/arm/mach-exynos/include/mach/map.h    |    3 +--
 arch/arm/mach-exynos/include/mach/memory.h |    3 +--
 arch/arm/mach-exynos/platsmp.c             |    3 +--
 arch/arm/mach-exynos/pm.c                  |    1 +
 arch/arm/mach-exynos/pm_domains.c          |    8 ++++----
 arch/arm/mach-exynos/pmu.c                 |    1 -
 arch/arm/mach-exynos/regs-pmu.h            |    4 ----
 arch/arm/mach-exynos/regs-sys.h            |   22 ++++++++++++++++++++++
 12 files changed, 39 insertions(+), 45 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.9.5

