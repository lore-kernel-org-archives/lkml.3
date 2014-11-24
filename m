Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaKXCMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:12:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59283 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKXCMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:40 -0500
X-AuditID: cbfee691-f79b86d000004a5a-1b-547294162691
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v4 0/5] exynos: Move pmu driver to driver/soc folder and add
 exynos7 support
Date: Mon, 24 Nov 2014 07:36:10 +0530
Message-id: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWyRsSkTldsSlGIQftzI4uGqyEWvQuuslls
	enyN1eLyrjlsFjPO72OyuH2Z14HNo6W5h81j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL
	4MqYe/UHW8EliYoZXVeYGxjXCHUxcnJICJhIPLk6jRHCFpO4cG89G4gtJLCUUWJCkxVMzYoL
	i1i7GLmA4tMZJWYde8cM4UxgktjwZQFYB5uAscTPnfvZuxg5OEQEvCWWX1MEqWEWaGCU2P5h
	PliNsECcxPuF98C2sQioSqz/cQjM5hVwk/i8o40ZpFdCQEFiziQbkF4JgfdsEp/O32KGqBeQ
	+Db5EAtEjazEpgPMEMdJShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB
	oXn637OJOxjvH7A+xCjAwajEw/uhtTBEiDWxrLgy9xCjKdCGicxSosn5wAjIK4k3NDYzsjA1
	MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0TdJw0xaVuzclf92qim2
	9/tEtR7HT/EKuSlftkle5vnNa0cDdFjPLYy8pjyH2e8lq8DSHexHNQ9aZiV/O57zNWDWr+j2
	x5MaZzWYbj+kvP7J7kea1nfuXV9U+KyrUN1x2vKpx/Kb65fnXP0q43+d+8DelYeEWmqymI5s
	3zHZWzR16817iQ0mX5RYijMSDbWYi4oTAZlneydIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xoK7YlKIQgyuztCwaroZY9C64ymax
	6fE1VovLu+awWcw4v4/J4vZlXgc2j5bmHjaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdotZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+7VH2wFlyQqZnRdYW5gXCPUxcjJISFgIrHiwiJW
	CFtM4sK99WxdjFwcQgLTGSVmHXvHDOFMYJLY8GUBG0gVm4CxxM+d+9m7GDk4RAS8JZZfUwSp
	YRZoYJTY/mE+WI2wQJzE+4X3GEFsFgFVifU/DoHZvAJuEp93tDGD9EoIKEjMmWQzgZF7ASPD
	KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg0H8mtYNxZYPFIUYBDkYlHl6PjsIQIdbEsuLK
	3EOMEhzMSiK8Z/8BhXhTEiurUovy44tKc1KLDzGaAi2fyCwlmpwPjMu8knhDYxNzU2NTSxML
	EzNLJXHeGzdzQ4QE0hNLUrNTUwtSi2D6mDg4pRoY7WKsUw12pL5wKF2VwjTxwpfqEplDHXwv
	5G3W+N1/ml1nnLb/jpi4jXOS2+oj3s+XX3Dt9/tw/JG//tEsTo07sU+YY1UTBG55pSfcCYkS
	fSzununucX9xyESn2zXbJq7cMi3axyztroJCPLfPkzPneENWXNepPh1oo9lh/eHa5Nr35ve4
	vaSUWIozEg21mIuKEwHjKmlckwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series [1 - 5] performs,

1) Moves pmu driver to driver/soc/samsung folder. This is needed as exynos7 is
   an arm64 based platform and hence PMU driver should be in driver folder.
   Some discussion happened about this in the v1 version. Finally adding it in
   driver/soc folder as it too SoC specific and not a general driver.
   Entire discussion can be found here (A).
2) Add exynos7 PMU support.
3) Enables the driver for 32bit arm exynos platforms.

Changes from V3:
* Fixed Kconfig as per Russell feedback
* Rebased the series against Pankaj SoC restart consolidation patches (D) as per
  Kukjin request.
* Link to V3 can be found here (C)

Changes from V2:
* Added review comment changes suggested by Pankaj.
* Removed mfd client support in this patch series. This will be added later in
  the power domain patch series.
* Link to V2 can be found here (B)

Changes from V1:
* Move pmu driver in driver/soc/samsung folder
* Removed the power domain features. They will posted as a separate series.
* Added exynos7 PMU support.
* Link to v1 can be found here (A)

This complete patch series is rebased on Kukjin for-next tree.

(A) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
(B) - http://www.spinics.net/lists/arm-kernel/msg375910.html
(C) - http://www.spinics.net/lists/linux-samsung-soc/msg39237.html 
(D) - http://www.spinics.net/lists/linux-samsung-soc/msg39095.html

Amit Daniel Kachhap (5):
  ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
  drivers: soc: Add support for Exynos PMU driver
  driver: soc: exynos-pmu: Add an API to be called after wakeup
  drivers: soc: exynos-pmu: Add support for Exynos7
  arm: exynos: Select SOC_SAMSUNG config option

 .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
 arch/arm/mach-exynos/Kconfig                       |    1 +
 arch/arm/mach-exynos/Makefile                      |    2 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    4 +-
 arch/arm/mach-exynos/suspend.c                     |    4 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   20 +
 drivers/soc/samsung/Makefile                       |    1 +
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  442 +++++++++++++++++++-
 .../linux/soc/samsung}/exynos-pmu.h                |    1 +
 .../linux/soc/samsung/exynos-regs-pmu.h            |  273 ++++++++++++
 15 files changed, 744 insertions(+), 13 deletions(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (64%)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (89%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (63%)

-- 
1.7.9.5

