Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbaDJJiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:38:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18692 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965708AbaDJJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:52 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-a2-5346666eac3a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 00/27] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Thu, 10 Apr 2014 18:37:11 +0900
Message-id: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWyRsSkUDcvzS3Y4MFlEYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpYfv40e8E+qYq7My4zNjB+F+li5OSQEDCR+PCu
	ixnCFpO4cG89WxcjF4eQwFJGifsPdjDDFJ3bvYMdIjGdUeJay1uoqiYmiYadJ1hBqtgEtCT2
	v7jBBmKLCARI/Dj+DsxmFrjJKHHsfRiILSzgJ7Fm4k6wOIuAqsTfJUsZQWxeAVeJuV+uMUJs
	k5P4sOcR2DYJgX52if2tXSwQDQIS3yYfArI5gBKyEpsOQF0nKXFwxQ2WCYyCCxgZVjGKphYk
	FxQnpReZ6hUn5haX5qXrJefnbmIEhvLpf88m7mC8f8D6EGMy0LiJzFKiyfnAWMgriTc0NjOy
	MDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZUjaz/m/7sb7js
	IVJ3bfbR7zd4QsNcT/AzWp92DiyZ/vmkxOHZn7Yx5JbV1tUmn5587/7lPTXMsuzXNX9tmNmx
	Iax+e+vrrVr1Ppmpz2sXuLYrXPKWcrbwOb6lhHv/kZ/OWXGTkthe/uZ+xrj7bFwX9ybl20+K
	ok/NEJ6aHGUzKzzzG5O5hboSS3FGoqEWc1FxIgAvYTCtewIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9jQd28NLdgg8nvuS2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvLzp9kL
	9klV3J1xmbGB8btIFyMnh4SAicS53TvYIWwxiQv31rN1MXJxCAlMZ5S41vIWymlikmjYeYIV
	pIpNQEti/4sbbCC2iECAxI/j78BsZoGbjBLH3oeB2MICfhJrJu4Ei7MIqEr8XbKUEcTmFXCV
	mPvlGiPENjmJD3sesU9g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhSnknvYFzV
	YHGIUYCDUYmH98Ay12Ah1sSy4srcQ4wSHMxKIrzXgt2ChXhTEiurUovy44tKc1KLDzEmA22f
	yCwlmpwPjOK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDM
	Xj1xsu6O/v/dN0zfXHlwkLdpVce2p7yvLtTeW2/2wXfX6aPp3bmvrOeoxH5pu8P/yLd94jQW
	hwelwhOvBs3Nrdvjty38Wej24oQDiuWbVl1+EvT7iE7+gqAzW1YtaRZ/rz5FU+q+Xkiup9nM
	MO6nvVqvjCMCXvk63RdYfuTzQpV7uQuclpz1UmIpzkg01GIuKk4EAGlbFWXYAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos3250 Samsung SoC based on Cortex-A7 dual core.
Exynos3250 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
and provides the best performance features.

This patchset include some patches such as:
- Support secondary CPU of Exynos3250 (cpu up/down)
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
- Support the gpio control for Exynos3250 using pinctrl
- Support the clock control for Exynos3250 using common clk framework

Chanwoo Choi (11):
  ARM: EXYNOS: Add Exynos3250 SoC ID
  ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
  ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
  ARM: EXYNOS: Support secondary CPU boot of Exynos3250
  ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
  irqchip: Declare cortex-a7's irqchip to initialize gic from dt
  ARM: dts: exynos3250: Add default interrupt-parent connected with GIC
  ARM: dts: exynos3250: Add uart dt node to support seiral ports
  ARM: dts: exynos3250: Add MCT dt node
  ARM: dts: exynos3250: Add ADC dt node to read analog raw data
  ARM: dts: exynos3250: Add CPUs dt node for Exynos3250

Hyunhee Kim (1):
  ARM: dts: exynos3250: Add PMU dt data

Inki Dae (2):
  ARM: dts: exynos3250: Add i2c dt node
  ARM: dts: exynos3250: Add power domain dt nodes

Kyungmin Park (2):
  ARM: EXYNOS: Support secondary CPU boot of Exynos4212
  ARM: dts: exynos3250: Add Mobile Storage Host Card

Tomasz Figa (11):
  pinctrl: exynos: Add driver data for Exynos3250
  clk: samsung: exynos3250: Add clocks using common clock framework
  ARM: dts: exynos3250: Add new exynos3250.dtsi file
  ARM: dts: exynos3250: Add GIC dt node for Exynos3250
  ARM: dts: exynos3250: Add pin control device tree data
  ARM: dts: exynos3250: Add device tree nodes for clock controllers
  ARM: dts: exynos3250: Move definitions of external clocks to SoC dtsi
  ARM: dts: exynos3250: Add amba and pdma dt node
  ARM: dts: exynos3250: Add spi dt node to support spi bus
  ARM: dts: exynos3250: Add pwm dt node to support PWM Timer
  ARM: dts: exynos3250: Add RTC dt node

 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 ++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         | 410 ++++++++++++++++
 arch/arm/mach-exynos/Kconfig              |  22 +
 arch/arm/mach-exynos/exynos.c             |  18 +
 arch/arm/mach-exynos/firmware.c           |  17 +-
 arch/arm/mach-exynos/hotplug.c            |  13 +-
 arch/arm/mach-exynos/include/mach/map.h   |   2 +
 arch/arm/plat-samsung/include/plat/cpu.h  |  10 +
 drivers/clk/samsung/Makefile              |   1 +
 drivers/clk/samsung/clk-exynos3250.c      | 785 ++++++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                 |   1 +
 drivers/pinctrl/pinctrl-exynos.c          |  67 +++
 drivers/pinctrl/pinctrl-samsung.c         |   2 +
 drivers/pinctrl/pinctrl-samsung.h         |   1 +
 include/dt-bindings/clock/exynos3250.h    | 256 ++++++++++
 15 files changed, 2077 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h

-- 
1.8.0

