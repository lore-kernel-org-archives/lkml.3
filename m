Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122AbaDJJ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:28:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934368AbaDJJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:50 -0400
X-AuditID: cbfee68e-b7f566d000002344-4b-5346645082de
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 00/27] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Thu, 10 Apr 2014 18:28:17 +0900
Message-id: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkUDcgxS3YYP4RA4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpYfv40e8E+qYq7My4zNjB+F+li5OSQEDCRmHmn
	jQnCFpO4cG89WxcjF4eQwFJGiYedT5hhij5d2M0KkZjOKPHpznsWCKeJSaL512FGkCo2AS2J
	/S9usIHYIgIBEj+OvwOzmQVuMkocex8GYgsL+EmsmbgTKM7BwSKgKrG+JxgkzCvgKvGr8Tkb
	xDI5iQ97HrGDzJcQ6GeXWPP0Hth8FgEBiW+TD7GA9EoIyEpsOgB1nKTEwRU3WCYwCi5gZFjF
	KJpakFxQnJReZKRXnJhbXJqXrpecn7uJERjIp/8969vBePOA9SHGZKBxE5mlRJPzgZGQVxJv
	aGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY/V6tnd1j
	ePzp0kCFvUFWAhwfBKNK5O7eUYl/oHPPYUPB0xX9V8/f72DctXLZ5jVH5jCUFbY83vOwc+ql
	O2Hvo4JMq9/5ZX41ul11g8PNQ7wvf7vnBe9eu+3CNpvVecLyHZw3639tjJn+YqXfBL+eXhP7
	+ocr3PM3yqw5LLmpfGFsyXPR3hZPJZbijERDLeai4kQAq0sHqHoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jQd2AFLdgg+kn1C2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvLzp9kL
	9klV3J1xmbGB8btIFyMnh4SAicSnC7tZIWwxiQv31rN1MXJxCAlMZ5T4dOc9C4TTxCTR/Osw
	I0gVm4CWxP4XN9hAbBGBAIkfx9+B2cwCNxkljr0PA7GFBfwk1kzcCRTn4GARUJVY3xMMEuYV
	cJX41ficDWKZnMSHPY/YJzByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHCfPpHcw
	rmqwOMQowMGoxMN7YJlrsBBrYllxZe4hRgkOZiUR3mvBbsFCvCmJlVWpRfnxRaU5qcWHGJOB
	lk9klhJNzgfGcF5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1
	MDquXm3+ejdvv1Ts3DatLN75shHTvFhyduulFitc2fjdLtvGzC2wVDrhwpv0qeVOO1teKtxV
	fDQtT/KUSAHbo90cS5hvWE6VPpR//quTmd+1B/pbVkdM763IKnJYc6BrjtuKzZ/b5ti37Oz+
	F7TrieS6rKtcKfOWqbxboFLxtkF5fmFO38Hjn5RYijMSDbWYi4oTATz3B6nXAgAA
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

