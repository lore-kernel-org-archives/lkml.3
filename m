Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaJTD3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:29:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaJTD3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:29:17 -0400
X-AuditID: cbfee691-f79b86d000004a5a-67-5444818b07f9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        cw00.choi@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com
Subject: [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
Date: Mon, 20 Oct 2014 12:29:04 +0900
Message-id: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkULe70SXE4FIzr8XfScfYLSatO8Bk
	cf3Lc1aLPxNa2Sx2/b3PaDHp/gQWix0NR1gtbvxqY7XoXXCVzeJs0xt2iyl/ljNZbHp8jdXi
	8q45bBYzzu9jsrh9mddi6fWLTBZPJ1xkszh1/TNQfPJLNotjM5YwWqza9YfRYu/OyYwOYh5r
	5q1h9Ghp7mHz+P1rEqPH31UvmD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCuKC6b
	lNSczLLUIn27BK6MOU9XMxe0C1RsmNnP1sC4jaeLkZNDQsBEYs2is4wQtpjEhXvr2UBsIYGl
	jBJT/hnC1NxdeY69i5ELKD6dUeLKgyvMEE4Tk0TTso0sIFVsAloS+1/cAOsWEciWuNJ4H6yI
	WeAgs8THTz3sIAlhAV+J98smga1jEVCVmPJ5IyuIzSvgKnH5ZzcrxDo5iQ97HoGtkxDo5ZA4
	/+AKK0SDgMS3yYeAtnEAJWQlNh1ghqiXlDi44gbLBEbBBYwMqxhFUwuSC4qT0otM9YoTc4tL
	89L1kvNzNzECo+/0v2cTdzDeP2B9iFGAg1GJh3eHmUuIEGtiWXFl7iFGU6ANE5mlRJPzgTGe
	VxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/fsG2X/
	RSZt1Lz5YZfo6QYz9wnK/qlv/Jduv7NhdrT32mkXp8lcdzJp1RLPfO8Tp5h8oO6GY0xPN8tn
	9dlOd3jjXFSELlrefvLkkjLPt60XU//NktDf4ys1iTEs1MDuSfXnGQXLLjyZ+jzWOvWo49HU
	jsrsklCNWa06y2Yc6NCz3mxeH7Y2UomlOCPRUIu5qDgRABRX2VW5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd3uRpcQg2ZJi7+TjrFbTFp3gMni
	+pfnrBZ/JrSyWez6e5/RYtL9CSwWOxqOsFrc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dkcfsyr8XS6xeZLJ5OuMhmcer6Z6D45JdsFsdmLGG0WLXrD6PF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCPKimUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz5jxdzVzQLlCxYWY/WwPjNp4uRk4O
	CQETibsrz7FD2GISF+6tZ+ti5OIQEpjOKHHlwRVmCKeJSaJp2UYWkCo2AS2J/S9usIHYIgLZ
	Elca74MVMQscZJb4+KkHbJSwgK/E+2WTGEFsFgFViSmfN7KC2LwCrhKXf3azQqyTk/iw5xH7
	BEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/uZ9A7GVQ0WhxgFOBiVeHh3mLmE
	CLEmlhVX5h5ilOBgVhLh/ZcBFOJNSaysSi3Kjy8qzUktPsRoCrR9IrOUaHI+MO3klcQbGpuY
	GVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgnNO7ui1csCGpvPKMUfrhgz/b
	752umS/vJvuo53uGt71RVWpD0H/eVctkV0Z5/NDTnSP5MOvT5gv7Jl9ezeK/KnpiheuL228a
	d26Vtd7Y5x0w3/a1WvF+x9X2C9x+S/tcrV/eHlqS+MA0p+4uw+FZei+WCxxzPHep50Fe8fQ5
	+q+fc3FlXDm/SImlOCPRUIu5qDgRAIsqoXgDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos4415 Samsung SoC based on Cortex-A9 quad cores.
Exynos4415 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
and provides the best performance features.

This patchset include some patches such as:
- Support booting of Exynos4415
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/ehci/ohci/pwm/amba
- Support the clock controller for Exynos4415 using common clk framework
- Support the gpio control for Exynos4415 using pinctrl subsystem

Chanwoo Choi (4):
  ARM: EXYNOS: Add EXYNOS4415 SoC ID
  clk: samsung: exynos4415: Add clocks using common clock framework
  clk: samsung: Document binding for Exynos4415 clock controller
  ARM: dts: Add dts files for Exynos4415 SoC

Tomasz Figa (1):
  pinctrl: exynos: Add support for Exynos4415

 .../devicetree/bindings/clock/exynos4415-clock.txt |   49 +
 arch/arm/boot/dts/exynos4415-pinctrl.dtsi          |  613 +++++++++++
 arch/arm/boot/dts/exynos4415.dtsi                  |  627 +++++++++++
 arch/arm/mach-exynos/Kconfig                       |    5 +
 arch/arm/mach-exynos/common.h                      |    8 +
 arch/arm/mach-exynos/exynos.c                      |    2 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos4415.c               | 1133 ++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-exynos.c           |   78 ++
 drivers/pinctrl/samsung/pinctrl-samsung.c          |    2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h          |    1 +
 include/dt-bindings/clock/exynos4415.h             |  360 +++++++
 12 files changed, 2879 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos4415.c
 create mode 100644 include/dt-bindings/clock/exynos4415.h

-- 
1.8.0

