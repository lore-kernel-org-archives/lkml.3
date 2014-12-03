Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaLCIYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:24:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46709 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLCIYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:24:43 -0500
X-AuditID: cbfee68e-f79b46d000002b74-46-547ec8c94be4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, heiko@sntech.de,
        arnd@arndb.de, thomas.ab@samsung.com, tomasz.figa@gmail.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 0/2] Introducing Exynos ChipId driver
Date: Wed, 03 Dec 2014 13:47:36 +0530
Message-id: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkTvfkiboQg1mPtCz+TjrGbvH/0WtW
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdouOZYwWq3b9YXTg8mhp7mHz+P1rEqPH
	zll32T02L6n36NuyitFj+7V5zB6fN8kFsEdx2aSk5mSWpRbp2yVwZczq+M9ecEqyYuHFI8wN
	jGeEuxg5OSQETCTWvrjOBmGLSVy4tx7I5uIQEljKKNE+7S4TTNH87tPMEInpjBLH/y9mhXAm
	MEmcmTCbEaSKTUBX4sn7ucwgtohAtkT/7dUsIDazwBpGiZs71UBsYQELib0Nv8BqWARUJR7f
	XgRkc3DwCrhLHH8lCmJKCChIzJlkAzJeQmARu8Sfs41MEOUCEt8mH2KBqJGV2HSAGeI2SYmD
	K26wTGAUXMDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMMBP/3vWt4Px5gHrQ4wCHIxK
	PLwWcXUhQqyJZcWVuYcYTYE2TGSWEk3OB8ZRXkm8obGZkYWpiamxkbmlmZI4b4LUz2AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjPPmzP4dpa/rLHlckOefxFaxMpvXBQ/Dtih1XdTIYzu8
	bLX4Uqbrdm8nqN8+9vRX9ptJ7wyK28K474o1BmWeevfiZJ3aV4HXjd3TPC9Oa7hWZB/Z9b/v
	qJiC47s5+29Oi3k1O6areLVmWMSHI89kngT5ePl/5f1/gq3Pv3atd/j/dJtcscl3WJVYijMS
	DbWYi4oTAfqw0EVrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd2TJ+pCDGa/VrD4O+kYu8X/R69Z
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Foq1f2C06ljFarNr1h9GBy6OluYfN4/evSYwe
	O2fdZffYvKTeo2/LKkaP7dfmMXt83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFjVsd/9oJTkhULLx5hbmA8I9zFyMkhIWAiMb/7NDOELSZx4d56ti5GLg4hgemM
	Esf/L2aFcCYwSZyZMJsRpIpNQFfiyfu5YB0iAtkS/bdXs4DYzAJrGCVu7lQDsYUFLCT2NvwC
	q2ERUJV4fHsRkM3BwSvgLnH8lSiIKSGgIDFnks0ERu4FjAyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYLj55nUDsaVDRaHGAU4GJV4eC3i6kKEWBPLiitzDzFKcDArifAu2wEU4k1JrKxK
	LcqPLyrNSS0+xGgKtHsis5Rocj4wtvNK4g2NTcxNjU0tTSxMzCyVxHlv3MwNERJITyxJzU5N
	LUgtgulj4uCUamDMfmDFZvCRU/57csXL24LrL3C4V80MXz/H7roz58lY7qqfvMEX7OP+u7os
	5zv784c6y5fFc5P3X5h8aD7LhcMMlbYGexRy7j2aoabL2mR7OfV05s7li3QY5h4Js7q21vzA
	48OTGPeLyZosEWyIDjn29LyPxiXn43N36b9bZ8ky79V/cY6Amb2CSizFGYmGWsxFxYkA3UBe
	v7UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces Exynos Chipid platform driver.
Each Exynos SoC has ChipID block which can give information about SoC's
product Id and revision number.
At the same time it reduces dependency of mach-exynos files from plat-samsung,
by removing samsung_rev API, similar API is introduced in chipid driver itself
to get revision number and product id. 

This patch series is based on Kukjin Kim's for-next having SHA_ID:
9db7d78aca2c7fbc19a26ce2ef01c805dc010c72

It can also be cleanly applied on latest (next-20141201) linux-next.

This has been tested against both tree on Exynos3250 and Exynos5250 (SMDK) board.

Revision 3 and it's discussion can be found here
 - https://lkml.org/lkml/2014/5/10/31
 - https://lkml.org/lkml/2014/6/10/270
 - https://lkml.org/lkml/2014/5/11/16

Change since v3: 
 - This patch set contains 5/6 and 6/6 patch from v3 series.
 - Made EXYNOS_CHIPID config option non-user selectable,
   as suggested by Tomasz Figa.
 - Made uniform macro for EXYNOS4/5_SOC_MASK as EXYNOS_SOC_MASK as
   suggested by Tomasz Figa.
 - Made local variables static in chipid driver.
 - Added existing SoC's product id's.
 - Added platform driver support.

Changes since v2:
 - Reorganized patches as suggested by Tomasz Figa.
 - Addressed review comments of Tomasz Figa in i2c-s3c2410.c file.

Changes since v1:
 - Added patch to move i2c interrupt re-configuration code from exynos.c
   to i2c driver, as suggested by Arnd.
 - After above patch only user of SYS_I2C_CFG register is pm.c so moving
   save/restore of this register also into i2c driver.
 - Spiltted up exynos4 and exynos5 machine descriptors to get rid from
   soc_is_exynos4/exynos5 kind of macros, as suggested by Arnd.
 - Changed location of chipid driver to "drivers/soc".
 - Added drivers/base/soc.c provided infrastructure to make SoC specific 
   information avaible to user space via sysfs entry, as suggested by Arnd.

Pankaj Dubey (2):
  soc: samsung: add exynos chipid driver support
  ARM: EXYNOS: refactoring of mach-exynos to enable chipid driver

 arch/arm/mach-exynos/Kconfig                 |    2 +
 arch/arm/mach-exynos/common.h                |   46 ++----
 arch/arm/mach-exynos/exynos.c                |   77 ++++-----
 arch/arm/mach-exynos/include/mach/map.h      |    2 -
 arch/arm/mach-exynos/platsmp.c               |    2 +-
 arch/arm/mach-exynos/pm.c                    |    8 +-
 arch/arm/plat-samsung/cpu.c                  |   14 --
 arch/arm/plat-samsung/include/plat/cpu.h     |    2 -
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 drivers/soc/Kconfig                          |    1 +
 drivers/soc/Makefile                         |    1 +
 drivers/soc/samsung/Kconfig                  |   14 ++
 drivers/soc/samsung/Makefile                 |    1 +
 drivers/soc/samsung/exynos-chipid.c          |  218 ++++++++++++++++++++++++++
 include/linux/soc/samsung/exynos-soc.h       |   53 +++++++
 15 files changed, 338 insertions(+), 104 deletions(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/soc/samsung/exynos-soc.h

-- 
1.7.9.5

