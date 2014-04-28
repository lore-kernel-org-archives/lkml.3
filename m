Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaD1MCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:02:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62158 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbaD1MCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:02:18 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-99-535e4347bbee
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RESUBMIT RFC PATCH v2 0/3] Add support for Exynos PMU driver
Date: Mon, 28 Apr 2014 21:20:04 +0900
Message-id: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t8zfV1357hggzUndSw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro3HDMbaCjyIV/17fYG1g3MvfxcjJISFg
	IrHv/AZWCFtM4sK99WwgtpDAMkaJXy84YWoaV2+Aik9nlNjXw9vFyAVktzFJrP68lxkkwSag
	K/Hk/VwwW0QgW+JK431mkCJmgauMEidftgM5HBzCAm4Sy46Ug9SwCKhKfL9yDKyeV8Bd4kzb
	VkaQEgkBBYk5k2xAWiUEprNLbDw9gRWiXkDi2+RDLBA1shKbDjBD3CYpcXDFDZYJjIILGBlW
	MYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoQEc/8OxrsHrA8xJgONm8gsJZqcD4yGvJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmBss7y+oU/rh
	+tuNc1ZU3F0h/v9bFNPFszm5NxpT1D7Pj5cI/cBuW+Esszrw9CONaUvvPXkmpxp2x/DBg+Z1
	wpzvFV+oL7SSm82hkXzCPsui7rHE1wv3vbvX3Z+UenQvO/fJ1oDXz6U2mf9/tvPLUdma2Nxf
	t9K+ZuZqblp43k6cYU2MU1a3kxJLcUaioRZzUXEiAG94wWR8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jQV1357hgg/3fVS02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY0bj
	hmNsBR9FKv69vsHawLiXv4uRk0NCwESicfUGNghbTOLCvfVgtpDAdEaJfT28XYxcQHYbk8Tq
	z3uZQRJsAroST97PBbNFBLIlrjTeZwYpYha4yihx8mU7kMPBISzgJrHsSDlIDYuAqsT3K8fA
	6nkF3CXOtG1lBCmREFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdHy
	TGoH48oGi0OMAhyMSjy8EXNig4VYE8uKK3MPMUpwMCuJ8Ho6xQUL8aYkVlalFuXHF5XmpBYf
	YkwGWj6RWUo0OR8YyXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwHj4n//j6ecv5zenNusxXxLcauieGn5l8YLFz8429VVJbgqUfT/5ifCi51ysmyQTmYUP
	rQgsnnxYyHymV9SaJAteS44b1k8yK5+73Ho46WHjzw5Wr26O3WuXL9JZscr/4EXJKst5q77X
	/b9hZuWyp/JX/pagxzJzlJO+P0lQ9/9W86yQac3xuFVKLMUZiYZazEXFiQCfYNzu2gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves PMU implementation from "mach-exynos/pmu.c" to
"drivers/mfd/exynos-pmu.c". Patch v1 was posted as RFC [1].

In case of ARM32 we had machine folder such as "mach-exynos" but
moving forward with ARM64 SoC support we can not have any more such
machine folders, keeping that in mind we have planned to move PMU
implementation out of machine folder, so that common piece of code
can be reused.

This patch series is based on kgene for-next and depends on following
patch series
 a) [PATCH v2 0/5] Add PMU node for Exynos SoCs
	https://lkml.org/lkml/2014/4/25/216
 b) [PATCH v2 00/10] ARM: Exynos: PMU cleanup and refactoring for using DT
	https://lkml.org/lkml/2014/4/25/252


1) [RFC PATCH 0/2] Add support for Exynos PMU driver
	https://lkml.org/lkml/2014/4/2/69

Changes since v1:
 - Rebased on Kukjin Kim's for-next (3.15_rc1 tag)
 - Added patch: Move PMU specific definitions from common.h
 - Added patch: Move pmu specific header files under "linux/mfd/samsung"
 - Removed patch: ARM: EXYNOS: remove arch specific PMU implementation
	As suggested breaking down patches into smalled pieces for better review.
	Also modified all changes in pmu.c under mach-exynos itself and then
	prepared patches moving files from mach-exynos to "drivers/mfd"


Pankaj Dubey (2):
  ARM: EXYNOS: Move pmu specific header files under "linux/mfd/samsung"
  drivers: mfd: Add support for Exynos PMU driver

Younggun Jang (1):
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig                       |    2 ++
 arch/arm/mach-exynos/Makefile                      |    2 --
 arch/arm/mach-exynos/common.h                      |   17 -----------
 arch/arm/mach-exynos/cpuidle.c                     |    3 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/hotplug.c                     |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    3 +-
 drivers/mfd/Kconfig                                |    9 ++++++
 drivers/mfd/Makefile                               |    1 +
 .../mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c  |    5 ++--
 include/linux/mfd/samsung/exynos-pmu.h             |   31 ++++++++++++++++++++
 .../linux/mfd/samsung/exynos-regs-pmu.h            |    0
 13 files changed, 52 insertions(+), 27 deletions(-)
 rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (99%)
 create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/mfd/samsung/exynos-regs-pmu.h (100%)

-- 
1.7.10.4

