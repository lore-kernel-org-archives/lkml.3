Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaFYMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:48:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44823 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaFYMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:48:26 -0400
X-AuditID: cbfee68f-b7fef6d000003970-52-53aac517193a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 0/6] Cleanup patches for mach-exynos
Date: Wed, 25 Jun 2014 18:15:36 +0530
Message-id: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkWlf86KpggyOzpC2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VotFW4Eq1s94zWJx89l2Jgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj7po5zAVfxSrWLT7A3sD4QLCLkYNDQsBE
	YvXTmC5GTiBTTOLCvfVsXYxcHEICSxklLk85zwiRMJHY+7efBSIxnVFi+eENzBDOBCaJo8eO
	MYFUsQnoSjx5P5cZxBYRyJbov70arINZ4BSjxOzN09hBEsIC5hJvG2eygNgsAqoSc9pngsV5
	BdwltjftZIQ4SUFiziQbkF4JgensEtt/zWSEqBeQ+Db5EAtEjazEpgPMENdJShxccYNlAqPg
	AkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBAX3637P+HYx3D1gfYkwGGjeRWUo0OR8Y
	EXkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZEr
	0vxSr98JvQ96S/6tnpbiMv8Sq+3KdKH/DtNatSfrbGbUqFgeJuxg8W972+wHWXOu1DNY/qvx
	2zVFy/bd1b/KalW89zR3yB9fvXv1Fs+oc5qXv6j9bnRd330lPot/dsZ9qTU39aI3PlEue5tm
	X7jhnLyiadKU0ym+2/J2sk7QDeR83DjxzGklluKMREMt5qLiRABEPDNZfgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jQV3xo6uCDc4+ELRYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGXfX
	zGEu+CpWsW7xAfYGxgeCXYycHBICJhJ7//azQNhiEhfurWfrYuTiEBKYziix/PAGZghnApPE
	0WPHmECq2AR0JZ68n8sMYosIZEv0317NAlLELHCKUWL25mnsIAlhAXOJt40zwcayCKhKzGmf
	CRbnFXCX2N60k7GLkQNonYLEnEk2Exi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	jphn0jsYVzVYHGIU4GBU4uG9MHtlsBBrYllxZe4hRgkOZiURXvf9q4KFeFMSK6tSi/Lji0pz
	UosPMZoCLZ/ILCWanA+M5rySeENjE3NTY1NLEwsTM0slcd6DrdaBQgLpiSWp2ampBalFMH1M
	HJxSDYzVJoW/th1fpJJ8/3e1/LmLnqmzkxIXLvjbfv/VfeUuOZfrYdwGD+32W2zrfZlz0Kfb
	UEVJwK3AQ3GK1Zk3McsnpbdNvfi7fYFg9W75ZYuc/Z0iFvWJlV+uj2Rovaw1y2hLwwEWVr7L
	b/f/EFh+PEjAcoJzQUfdtssBbrttZr9O899QzpJyaJMSS3FGoqEWc1FxIgD1f0zwrgIAAA==
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
 arch/arm/mach-exynos/exynos.c              |   26 ++++++++------------------
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
 12 files changed, 39 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.9.5

