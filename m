Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaEJHCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:02:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27964 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaEJHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:02:05 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-d8-536dceeb4ecd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 0/6] Introducing Exynos ChipId driver
Date: Sat, 10 May 2014 16:20:13 +0900
Message-id: <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706287-13919-1-git-send-email-y@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zA90353KDDc7qWvyddIzdonfBVTaL
	TY+vsVpc3jWHzWLG+X1MFou2fmG3WD/jNYsDu8fvX5MYPTYvqffo27KK0ePzJrkAligum5TU
	nMyy1CJ9uwSujLkT4gu6lSqurjrH2sDYINnFyMkhIWAiMfHXFEYIW0ziwr31bF2MXBxCAssY
	Jbquf2aBKbqw4hJUYhGjxJyV7SwQThuTxKcvF9hAqtgEdCWevJ/LDGKLCGRLXGm8D2YzC6RL
	PHg7gRXEFhawkPg0czpYPYuAqsS6ra1gNq+Ah8SEbxOBbA6gbQoScybZgIQ5Bewkrm1rBjtC
	SMBWYsrRw4wgeyUEJrNL3Ni7gwlijoDEt8mHWCB6ZSU2HWCGOFpS4uCKGywTGIUXMDKsYhRN
	LUguKE5KLzLWK07MLS7NS9dLzs/dxAgJ6/4djHcPWB9iTAYaN5FZSjQ5HxgXeSXxhsZmRham
	JqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUfVh/g7X5pwzi3fM
	T954vnXDnWcJVvyOF5U7kt5cfup9K8y/jvHj4zX71OsXJ1fW/dyx6ojsoxv+ol/k372unfJ+
	t8xf+YP/plwV8/46UWnXdd7FOxSlXiW/6WJ/YfpGubjhXvXc+XKWmnNW3VipoXEktW/VqwMH
	07QZzZWeaGr9azo6bdE0ZmklluKMREMt5qLiRADKjTe4gQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jAd3X53KDDXZ9N7f4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCwWbf3CbrF+xmsWB3aP378mMXpsXlLv0bdlFaPH501yASxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz5k6IL+hWqri66hxrA2ODZBcjJ4eE
	gInEhRWX2CBsMYkL99YD2VwcQgKLGCXmrGxngXDamCQ+fbkAVsUmoCvx5P1cZhBbRCBb4krj
	fTCbWSBd4sHbCawgtrCAhcSnmdPB6lkEVCXWbW0Fs3kFPCQmfJsIZHMAbVOQmDPJBiTMKWAn
	cW1bMwuILSRgKzHl6GHGCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx80z6R2M
	qxosDjEKcDAq8fAWvs0JFmJNLCuuzD3EKMHBrCTCu+JgbrAQb0piZVVqUX58UWlOavEhxmSg
	oyYyS4km5wNjOq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GC12nT7uwTB1/+HYxACdfrfkzSumPl65Om39wWIezvNvtryJ32jf2V1fNtvF/ATnx/mnRRce
	fWKiXpok6R31w88nIk1oof2m3dm9p94v0rl20+isXt/zZdOvBFhPcX9U3bDu6drZvEdm9Fsm
	cMi9+3R3YXvRW8Hsks91Ce8CjL6Gfn+xe9rZOE8lluKMREMt5qLiRAA9lH+u3wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series attempts to get rid of soc_is_exynosXXXX macros
and eventually with the help of this series we can probably get
rid of CONFIG_SOC_EXYNOSXXXX in near future.
Each Exynos SoC has ChipID block which can give information about
SoC's product Id and revision number. Currently we have single
DT binding information for this as "samsung,exynos4210-chipid".
But Exynos4 and Exynos5 SoC series have one small difference in
chip Id, with resepect to product id bit-masks. So it means we
should have separate compatible string for these different series
of SoCs. So I have added second compatible string for handling
this difference. 
This patch series is based on Kukjin Kim's for-next (3.14_rc1 tag)
and prepared on top of following patch series and it's dependent
patch series.

[1]: Map SYSRAM through generic SRAM bindings by Sachin Kamat.
	http://www.spinics.net/lists/arm-kernel/msg327677.html
[2]: Exynos PMU cleanup and refactoring.
	https://lkml.org/lkml/2014/4/30/44
[3]: Introduce drivers/soc and add QCOM GSBI driver.
	https://lkml.org/lkml/2014/4/24/520

Revision 2 and it's discussion can be found here
 - https://lkml.org/lkml/2014/5/6/100

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


Pankaj Dubey (6):
  i2c: s3c2410: Handle i2c sys_cfg register in i2c driver
  ARM: EXYNOS: Remove i2c sys configuration related code
  ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
  ARM:  EXYNOS: Remove unused header inclusion from hotplug.c
  soc: samsung: exynos-chipid: Add Exynos Chipid driver support
  ARM: EXYNOS: Refactoring to remove soc_is_exynos macros from exynos

 .../bindings/arm/samsung/exynos-chipid.txt         |   21 +++
 .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
 arch/arm/boot/dts/exynos5.dtsi                     |    7 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +
 arch/arm/mach-exynos/exynos.c                      |  119 ++++----------
 arch/arm/mach-exynos/hotplug.c                     |    2 -
 arch/arm/mach-exynos/include/mach/map.h            |    3 -
 arch/arm/mach-exynos/platsmp.c                     |   11 +-
 arch/arm/mach-exynos/pm.c                          |   36 ++---
 arch/arm/mach-exynos/regs-sys.h                    |   22 ---
 arch/arm/plat-samsung/include/plat/cpu.h           |   60 -------
 drivers/clk/samsung/clk-exynos4.c                  |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    9 +-
 drivers/cpufreq/exynos-cpufreq.h                   |    1 -
 drivers/cpufreq/exynos4x12-cpufreq.c               |    5 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   32 ++++
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   10 ++
 drivers/soc/samsung/Makefile                       |    1 +
 drivers/soc/samsung/exynos-chipid.c                |  166 ++++++++++++++++++++
 include/linux/exynos-soc.h                         |   46 ++++++
 25 files changed, 357 insertions(+), 210 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/exynos-soc.h

-- 
1.7.10.4

