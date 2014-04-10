Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379AbaDJJcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:32:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17647 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935327AbaDJJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:32:42 -0400
X-AuditID: cbfee68f-b7f156d00000276c-b4-53466538897e
Message-id: <53466539.8060100@samsung.com>
Date: Thu, 10 Apr 2014 18:32:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/27] Support new Exynos3250 SoC based on Cortex-A7 dual
 core
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkQNci1S3Y4OFtA4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYsn8te8ES2YrGU3NZGhhfi3UxcnJICJhIPF+2
	igXCFpO4cG89WxcjF4eQwFJGifNPtgI5HGBFj7qtIeLTGSW+TzrIBOG8ZpRoPn+aFaSbV0BL
	YvWVnWwgNouAqsS9TzPBprIBxfe/uAEWFxUIk1g5/QoLRL2gxI/J98BsEQENiZl/rzCCDGUW
	mMIkcfflB7CEsECIxJ2XPWALhARcJZo+7AMbxCngJvHpeytYnFlAR2J/6zQ2CFteYvOat8wQ
	7zxil3i4ShfiIAGJb5MPsUB8Iyux6QBUiaTEwRU3WCYwis1CctIsJFNnIZm6gJF5FaNoakFy
	QXFSepGxXnFibnFpXrpecn7uJkZgJJ7+96x/B+PdA9aHGJOBVk5klhJNzgdGcl5JvKGxmZGF
	qYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYAx6fL3uVP5Sd/cD
	8zaob/DP22L1On3KuvdbnVacPufGsZy7PfNxZF684mq17UGWrgs0e57+yzC/PNWe+2yTcJDI
	1YlXfsixLpf+UebrO69/sURFndH6tQ1TeBR2Z1zJ/NV1ZJOT7qSLzy8tMN++abvrqi1KJsuP
	3L4RcjRr3u+ppXtP9pcYPd+ixFKckWioxVxUnAgAB+wQ49oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQV2LVLdgg0UdGhbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi7czKjA7fH5iX1
	Hn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY8r+tewF
	S2QrGk/NZWlgfC3WxcjBISFgIvGo27qLkRPIFJO4cG89WxcjF4eQwHRGie+TDjJBOK8ZJZrP
	n2YFqeIV0JJYfWUnG4jNIqAqce/TTBYQmw0ovv/FDbC4qECYxMrpV1gg6gUlfky+B2aLCGhI
	zPx7hRFkKLPAFCaJuy8/gCWEBUIk7rzsAVsgJOAq0fRhH9ggTgE3iU/fW8HizAI6Evtbp7FB
	2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM40p9J
	7WBc2WBxiFGAg1GJh/fAMtdgIdbEsuLK3EOMEhzMSiK814LdgoV4UxIrq1KL8uOLSnNSiw8x
	JgODYCKzlGhyPjAJ5ZXEGxqbmBlZGpkbWhgZm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDo8j/hpsp3nNDvn9O/CXxP0619dqvJeWf7548wfRP82D/t+i1m76fkUo9tobD3C4m70Tm
	W9+vbFPDJ1ybNlln6QWlcEnx0yeORU8r7XJbJP1yvWkTU/CqrDdLLsQf37hvff32p4qr7Tet
	sm52/uj3duafx23BifOurvAOEVer+zs5Yt3Mom1Vb2cqsRRnJBpqMRcVJwIAxDFdIzgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Ignore this patchset because this patchset don't include all of patches.
I'll send this patchset again right now.

Sorry for my mistake.

Best Regards,
Chanwoo Choi

On 04/10/2014 06:28 PM, Chanwoo Choi wrote:
> This patchset support new Exynos3250 Samsung SoC based on Cortex-A7 dual core.
> Exynos3250 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
> for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
> and provides the best performance features.
> 
> This patchset include some patches such as:
> - Support secondary CPU of Exynos3250 (cpu up/down)
> - Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
> - Support the gpio control for Exynos3250 using pinctrl
> - Support the clock control for Exynos3250 using common clk framework
> 
> Chanwoo Choi (11):
>   ARM: EXYNOS: Add Exynos3250 SoC ID
>   ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
>   ARM: EXYNOS: Support secondary CPU boot of Exynos3250
>   ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
>   irqchip: Declare cortex-a7's irqchip to initialize gic from dt
>   ARM: dts: exynos3250: Add default interrupt-parent connected with GIC
>   ARM: dts: exynos3250: Add uart dt node to support seiral ports
>   ARM: dts: exynos3250: Add MCT dt node
>   ARM: dts: exynos3250: Add ADC dt node to read analog raw data
>   ARM: dts: exynos3250: Add CPUs dt node for Exynos3250
> 
> Hyunhee Kim (1):
>   ARM: dts: exynos3250: Add PMU dt data
> 
> Inki Dae (2):
>   ARM: dts: exynos3250: Add i2c dt node
>   ARM: dts: exynos3250: Add power domain dt nodes
> 
> Kyungmin Park (2):
>   ARM: EXYNOS: Support secondary CPU boot of Exynos4212
>   ARM: dts: exynos3250: Add Mobile Storage Host Card
> 
> Tomasz Figa (11):
>   pinctrl: exynos: Add driver data for Exynos3250
>   clk: samsung: exynos3250: Add clocks using common clock framework
>   ARM: dts: exynos3250: Add new exynos3250.dtsi file
>   ARM: dts: exynos3250: Add GIC dt node for Exynos3250
>   ARM: dts: exynos3250: Add pin control device tree data
>   ARM: dts: exynos3250: Add device tree nodes for clock controllers
>   ARM: dts: exynos3250: Move definitions of external clocks to SoC dtsi
>   ARM: dts: exynos3250: Add amba and pdma dt node
>   ARM: dts: exynos3250: Add spi dt node to support spi bus
>   ARM: dts: exynos3250: Add pwm dt node to support PWM Timer
>   ARM: dts: exynos3250: Add RTC dt node
> 
>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 ++++++++++++++++++
>  arch/arm/boot/dts/exynos3250.dtsi         | 410 ++++++++++++++++
>  arch/arm/mach-exynos/Kconfig              |  22 +
>  arch/arm/mach-exynos/exynos.c             |  18 +
>  arch/arm/mach-exynos/firmware.c           |  17 +-
>  arch/arm/mach-exynos/hotplug.c            |  13 +-
>  arch/arm/mach-exynos/include/mach/map.h   |   2 +
>  arch/arm/plat-samsung/include/plat/cpu.h  |  10 +
>  drivers/clk/samsung/Makefile              |   1 +
>  drivers/clk/samsung/clk-exynos3250.c      | 785 ++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic.c                 |   1 +
>  drivers/pinctrl/pinctrl-exynos.c          |  67 +++
>  drivers/pinctrl/pinctrl-samsung.c         |   2 +
>  drivers/pinctrl/pinctrl-samsung.h         |   1 +
>  include/dt-bindings/clock/exynos3250.h    | 256 ++++++++++
>  15 files changed, 2077 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>  create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>  create mode 100644 drivers/clk/samsung/clk-exynos3250.c
>  create mode 100644 include/dt-bindings/clock/exynos3250.h
> 

