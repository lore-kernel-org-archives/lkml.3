Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbbAOBvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:51:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29070 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbAOBvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:07 -0500
X-AuditID: cbfee68e-f79b46d000002b74-eb-54b71d0884e3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 0/9] devfreq: Add generic exynos memory-bus frequency driver
Date: Thu, 15 Jan 2015 10:50:48 +0900
Message-id: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkWJdDdnuIwaEL4haP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgypjwOK3gpWLF09fvWRoYj0h1MXJySAiYSLxZ9oEFwhaTuHBv
	PVsXIxeHkMBSRol/786ywRTtPdXFDpGYzijReO4bVFUTk0T73QZWkCo2AS2J/S9ugHWICOhJ
	dB7bww5iMwv8YZJo2gS2QljAX+Lp1p2MIDaLgKrE558zmEFsXgEXidtve5kgtilILFs+kxVk
	gYTAOXaJ9YunsEE0CEh8m3wIaBAHUEJWYtMBZoh6SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3I
	SK84Mbe4NC9dLzk/dxMjMEJO/3vWt4Px5gHrQ4wCHIxKPLwOR7aGCLEmlhVX5h5iNAXaMJFZ
	SjQ5HxiHeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MHr+SDohXO+wg/ldWFaZwlr3ibn9HprNDtW+sj9XOVX8Ob5TR8f0rHz5nH8nEjzOX9Tw+jf1
	zX5bhwTfjwuu2+Y6i+yQ2XBgK6dKQuJP09SqmXPfSUwp8XzPsl1j5vWQdF2m2CgNZuF3HCvO
	/+641pH09sbbYuZHYXu70nZnNny7E2yuIrv7hhJLcUaioRZzUXEiAJoJAqqLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBi+e8Fo8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGhMdpBS8VK56+fs/S
	wHhEqouRk0NCwERi76kudghbTOLCvfVsXYxcHEIC0xklGs99g3KamCTa7zawglSxCWhJ7H9x
	gw3EFhHQk+g8tgesm1ngD5NE0yYWEFtYwF/i6dadjCA2i4CqxOefM5hBbF4BF4nbb3uZILYp
	SCxbPpN1AiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB8fdMagfjygaLQ4wCHIxK
	PLwOR7aGCLEmlhVX5h5ilOBgVhLhfftpW4gQb0piZVVqUX58UWlOavEhRlOg7ROZpUST84Gp
	Ia8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgTFQWfD5K9+fexuD
	FjI/25Ih/Cjj8K6txfu6DyZKK4vG52b3Zm9ilHukJfZxz6uF3/+J9f26Z8BRmHDla4p4vzDf
	g3277Sd/YJAMW3zsyOmcl6u0FFTvSx5l/RPAe+rbr4/LWUxmG3wq0vtUu1Nlt5O315ul4gt9
	ru1dHl3HItkkfFg4/tiFKE8lluKMREMt5qLiRADndXJT1QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds the generic exynos bus frequency driver for memory bus
with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
support the memory bus frequency driver for Exynos SoCs.

Each memory bus block has a clock for memory bus speed and frequency
table which is changed according to the utilization of memory bus on runtime.
And then each memory bus group has the one more memory bus blocks and
OPP table (including frequency and voltage), regulator, devfreq-event
devices.

There are a little difference about the number of memory bus because each Exynos
SoC have the different sub-IP and different memory bus speed. In spite of this
difference among Exynos SoCs, we can support almost Exynos SoC by adding
unique data of memory bus to devicetree file.

Depend on:
- [PATCHv8 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
  : https://lkml.org/lkml/2015/1/7/795

Changelog:

Changes from v3:
(https://lkml.org/lkml/2015/1/7/872)
- Change the driver name and path by comment
  : drivers/devfreq/exynos-busfreq.c -> drivers/devfreq/exynos/exynos-bus.c
- Disable regulator when entering suspend state in exynos-bus.c
  and enable it after wake-up from suspend state.
- Add 'exynos,saturation-ratio' property to calibrate the performance count
  against cycle count.
- Add new patch to remove unused old driver
  : drivers/devfreq/exynos/exynos4_bus.{c|h}
- Clean-up code for minor issue
- Add acked tag by Myungjoo Ham (DEVFREQ maintainer)

Changes from v2:
(https://lkml.org/lkml/2014/12/31/2)
- Support the memory bus frequency feature for Exynos3250-based Monk board
- Fix build warning about variable uninitialized

Changes from v1:
(https://lkml.org/lkml/2014/12/23/178)
- This patchset is rebased on v3.19-rc2.
- Fix bug after wake-up from suspend state. If devfreq device fail to get event,
  exynos-busfreq retry to set the event for starting.
- Add memory bus group of Exynos4x12/Exynos4210
- Add divider clock id for Exynos4 memory bus frequency
- Support memory bus frequency driver on Exynos4412-based TRATS2 board
- This patch-set has the dependency on following patch-set[1]:
  [1] [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
  : https://lkml.org/lkml/2014/12/28/139

Chanwoo Choi (9):
  devfreq: exynos: Add generic exynos memory bus frequency driver
  devfreq: exynos: Add documentation for generic exynos memory bus frequency driver
  ARM: dts: Add memory bus node for Exynos3250
  clk: samsung: exynos4: Add divider clock id for memory bus frequency
  ARM: dts: Add memory bus node for Exynos4x12
  ARM: dts: Add memory bus node for Exynos4210
  ARM: dts: Add the support for exynos busfreq on Exynos3250-based Rinato/Monk board
  ARM: dts: Add the support for exynos busfreq on Exynos4412-based TRATS2 board
  devfreq: exynos: Remove unused exynos4 memory busfreq driver

 .../devicetree/bindings/devfreq/exynos-bus.txt     |  188 ++++
 arch/arm/boot/dts/exynos3250-monk.dts              |   12 +
 arch/arm/boot/dts/exynos3250-rinato.dts            |   12 +
 arch/arm/boot/dts/exynos3250.dtsi                  |  125 +++
 arch/arm/boot/dts/exynos4210.dtsi                  |   93 ++
 arch/arm/boot/dts/exynos4412-trats2.dts            |   12 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |  121 +++
 drivers/clk/samsung/clk-exynos4.c                  |   10 +-
 drivers/devfreq/Kconfig                            |   17 +-
 drivers/devfreq/Makefile                           |    1 +
 drivers/devfreq/exynos/Makefile                    |    2 +-
 drivers/devfreq/exynos/exynos-bus.c                |  598 +++++++++++
 drivers/devfreq/exynos/exynos4_bus.c               | 1055 --------------------
 drivers/devfreq/exynos/exynos4_bus.h               |  110 --
 include/dt-bindings/clock/exynos4.h                |    7 +-
 15 files changed, 1184 insertions(+), 1179 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-bus.txt
 create mode 100644 drivers/devfreq/exynos/exynos-bus.c
 delete mode 100644 drivers/devfreq/exynos/exynos4_bus.c
 delete mode 100644 drivers/devfreq/exynos/exynos4_bus.h

-- 
1.8.5.5

