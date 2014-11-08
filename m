Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaKHNWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:22:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41176 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaKHNWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:40 -0500
X-AuditID: cbfee68f-f791c6d000004834-d4-545e191dbf7c
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v2 0/6] exynos: Move pmu driver to driver/soc folder and add
 exynos7 support
Date: Sat, 08 Nov 2014 18:46:35 +0530
Message-id: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWyRsSkRldWMi7EYMkzc4uGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PF4TftrA7sHneu7WHz2Lyk3qNvyypGj8+b5AJYorhsUlJz
	MstSi/TtErgynizqYS9YLl7R9qiNvYFxq2AXIyeHhICJxLRXTxghbDGJC/fWs4HYQgJLGSXe
	LXKGqTm27Sx7FyMXUHw6o8Sjj1tYIJwJTBL/fh1lAaliEzCW+LlzP1AVB4eIgLfE8muKIDXM
	AjMYJXq6WxlB4sICcRJLpruAlLMIqErsm3MFbDGvgLvE4yftYK0SAgoScybZQOz9ziZx8XcA
	RLmAxLfJh1ggSmQlNh1ghiiRlDi44gbLBEbBBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNz
	NzECQ/T0v2f9OxjvHrA+xCjAwajEw3ujJTZEiDWxrLgy9xCjKdCGicxSosn5wEjIK4k3NDYz
	sjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY6Buwb6QU44vY1y/
	HniS9jHj6d78ticdC/04vHf5f9lwJMfspEXZFwF9zrnhqk9n1AXLzH3y87TftJX/pCxtnC8u
	z7qmVqZc57o+/d1qGTM//W4n4dWHNj+49+103JSn08yuSXwqYPp/pqHRUDxvYYVXdMjPf2HH
	KhjS/np73ura5j4p4KK3vRJLcUaioRZzUXEiAKNqjbNMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xoK6sZFyIwcSDehYNV0MsehdcZbO4
	//Uoo8Wmx9dYLS7vmsNmMeP8PiaLw2/aWR3YPe5c28PmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzHiyqIe9YLl4RdujNvYGxq2CXYycHBIC
	JhLHtp1lh7DFJC7cW8/WxcjFISQwnVHi0cctLBDOBCaJf7+OsoBUsQkYS/zcuR+og4NDRMBb
	Yvk1RZAaZoEZjBI93a2MIHFhgTiJJdNdQMpZBFQl9s25wghi8wq4Szx+0g7WKiGgIDFnks0E
	Ru4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj4JnUDsaVDRaHGAU4GJV4eG+0xIYI
	sSaWFVfmHmKU4GBWEuHtPQ8U4k1JrKxKLcqPLyrNSS0+xGgKtHwis5Rocj4wQvNK4g2NTcxN
	jU0tTSxMzCyVxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTD2nQ46xNzy1VVt7ZT8eX1f2PcJ
	aPWZ5tuZN615vrR2ReuGlroVvut6WxcFxr7TqWku0mJiOtd905RP+njQtXx+TscLky5dZr/y
	a+HxaSv/dLdzPzp0Z9/DC14R7Gx/fn8xmi4+keOr0odLsTc8DsyPkdeOvJOiN7O5Jyhuwcfp
	KwQ3ajXdu3hEiaU4I9FQi7moOBEAZsl3PpgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series[1 - 6] performs,

1) Moves pmu driver to driver/soc/samsung folder. Some discussion happened about
   this in the v1 version. Finally adding it in driver/soc folder as it too SoC
   specific and not a general driver. Entire discussion can be found here (A).
2) Registers this driver as MFD client driver. This will be used by clients like exynos pm
   sleep and pm domain driver.
3) Add exynos7 PMU support.

Changes from V1:
* Move pmu driver in driver/soc/samsung folder
* Removed the power domain features. They will posted as a separate series.
* Added exynos7 PMU support.
* Link to v1 can be found here (B)

This patch has dependency on following patches posted earlier by Pankaj (C),
which is accepted by maintainer.

Patch 6 was earlier posted by Abhilash (D) which has been reposted here with some
extra changes.

This complete patch series is rebased on linux-next.

(A) - http://www.spinics.net/lists/linux-samsung-soc/msg38444.html
(B) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
(C) - https://lkml.org/lkml/2014/10/6/581
(D) - http://www.spinics.net/lists/arm-kernel/msg358230.html 

Amit Daniel Kachhap (6):
  ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
  drivers: soc: Add support for Exynos PMU driver
  drivers: soc: samsung: Fix a spelling mistake
  soc: samsung: exynos-pmu: Register exynos-pmu driver as a mfd driver
  driver: soc: exynos-pmu: Add an API to be called after wakeup
  drivers: soc: samsung: Add support for Exynos7 pmu

 .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
 arch/arm/mach-exynos/Makefile                      |    2 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    4 +-
 arch/arm/mach-exynos/regs-pmu.h                    |  335 -----------
 arch/arm/mach-exynos/suspend.c                     |    3 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   19 +
 drivers/soc/samsung/Makefile                       |    1 +
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  471 ++++++++++++++-
 .../linux/soc/samsung}/exynos-pmu.h                |    6 +
 include/linux/soc/samsung/exynos-regs-pmu.h        |  608 ++++++++++++++++++++
 15 files changed, 1109 insertions(+), 349 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (50%)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (78%)
 create mode 100644 include/linux/soc/samsung/exynos-regs-pmu.h

-- 
1.7.9.5

