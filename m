Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbaLKIPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:15:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22464 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbaLKIPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:15:19 -0500
X-AuditID: cbfee691-f79b86d000004a5a-74-548952950613
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, heiko@sntech.de,
        arnd@arndb.de, thomas.ab@samsung.com, tomasz.figa@gmail.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 0/2] Introducing Exynos ChipId driver
Date: Thu, 11 Dec 2014 13:37:42 +0530
Message-id: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkTndqUGeIweFj8hZ/Jx1jt/j/6DWr
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu0XHMkaLVbv+MDpwebQ097B5/P41idFj
	56y77B6bl9R79G1Zxeix/do8Zo/Pm+QC2KO4bFJSczLLUov07RK4MpomSRW0yFScf13awHhS
	tIuRk0NCwERi546jrBC2mMSFe+vZuhi5OIQEljJKzFvRzQJT1HK9ixEiMZ1R4vGcTewgCSGB
	CUwSnU+8QWw2AV2JJ+/nMoPYIgLZEv23V4M1MwusYZS4uVOti5GDQ1jAQuJ/SxlImEVAVeLt
	uR52kDCvgIfEpd9cEKvkJLbcesQOskpCYBG7xOXXv1gh6gUkvk0+xAJSLyEgK7HpADNEvaTE
	wRU3WCYwCi5gZFjFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERjap/89m7iD8f4B60OMAhyM
	Sjy8K662hwixJpYVV+YeYjQF2jCRWUo0OR8YQXkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTDqXV/fVR2ZWf5uXeTsrl2MTz/IrnW6onhm0+ptNRW1
	1/elSTa9mx6tkSIqWNw6l3HbiYM8H3/Yyv/qPievEWN00kHtmO3xRdoWM3pqT6ktWz31W3OZ
	+aPH8+alWO0Lrd6bef7ARB/OjXnyRsz7ns65fD/aQZPXaCbfCiWRsq98v8KqbbZn++YosRRn
	JBpqMRcVJwIAvnRxRGgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd2pQZ0hBuvbxCz+TjrGbvH/0WtW
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdouOZYwWq3b9YXTg8mhp7mHz+P1rEqPH
	zll32T02L6n36NuyitFj+7V5zB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcxomiRV0CJTcf51aQPjSdEuRk4OCQETiZbrXYwQtpjEhXvr2boYuTiEBKYzSjye
	s4kdJCEkMIFJovOJN4jNJqAr8eT9XGYQW0QgW6L/9moWEJtZYA2jxM2dal2MHBzCAhYS/1vK
	QMIsAqoSb8/1sIOEeQU8JC795oJYJSex5dYj9gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBEfOM+kdjKsaLA4xCnAwKvHwBlxuDxFiTSwrrsw9xCjBwawkwvvYoTNEiDclsbIq
	tSg/vqg0J7X4EKMp0PKJzFKiyfnAqM4riTc0NjE3NTa1NLEwMbNUEudVsm8LERJITyxJzU5N
	LUgtgulj4uCUamBs1Qo9vfDU13tFP/8kpTc1v1vpemKjZ8K1y0fO3e/ZqZY4ayZD+QyFyEar
	Gicupaff1nC9klEvfx5+N2OpsMqiqs18C6MML3iXK13ifPvRNJCVXzslZc7Wot8WnZontnl7
	F7+JeN9wcpfeztv3uT4qK+1RZjJ9X2Eaf8Voqvg2j/Az3cesp3UqsRRnJBpqMRcVJwIAU9tp
	2bICAAA=
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

It can also be cleanly applied on latest (next-20141209) linux-next.

This has been tested against both tree on Exynos3250 and Exynos5250 (SMDK) board.

Revision 4 and it's discussion can be found here
 - https://lkml.org/lkml/2014/12/3/115

Changes since v4:
 - Removed custom sysfs entries as they were not providing any new information
   as pointed out by Arnd.
 - Removed functions exporting product_id and revision, instead we will export
   exynos_chipid_info structure. It will be helpfull when we need to provide more
   fields of chipid outside of chipid, as commented by Yadwinder
 - Converted all funcions as __init. 

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

 arch/arm/mach-exynos/Kconfig                 |   2 +
 arch/arm/mach-exynos/common.h                |  54 ++++-----
 arch/arm/mach-exynos/exynos.c                |  77 +++++-------
 arch/arm/mach-exynos/include/mach/map.h      |   2 -
 arch/arm/mach-exynos/platsmp.c               |   2 +-
 arch/arm/mach-exynos/pm.c                    |   8 +-
 arch/arm/plat-samsung/cpu.c                  |  14 ---
 arch/arm/plat-samsung/include/plat/cpu.h     |   2 -
 arch/arm/plat-samsung/include/plat/map-s5p.h |   1 -
 drivers/soc/Kconfig                          |   1 +
 drivers/soc/Makefile                         |   1 +
 drivers/soc/samsung/Kconfig                  |  14 +++
 drivers/soc/samsung/Makefile                 |   1 +
 drivers/soc/samsung/exynos-chipid.c          | 168 +++++++++++++++++++++++++++
 include/linux/soc/samsung/exynos-soc.h       |  51 ++++++++
 15 files changed, 296 insertions(+), 102 deletions(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/soc/samsung/exynos-soc.h

-- 
2.2.0

