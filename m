Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBXDq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:46:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37594 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBXDqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:46:53 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fe-530ac0aafe00
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v7 0/3] Exynos 5410 support
Date: Mon, 24 Feb 2014 12:43:52 +0900
Message-id: <1393213435-20863-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7qrDnAFG1ycpmQxad0BJouH62+y
	WMw/co7Vov/NQlaL/49es1qce7WS0aJ3wVU2i7NNb9gtNj2+xmqxsG0Ji8XlXXPYLGac38dk
	cfsyr8XS6xeZLJ5OuMhmMWH6WhaLdS+ns1i07j3CbrHlZwejxe+eT8wW65+fYrRYP+M1i8Wx
	GUsYLabO+MHuIOGxZt4aRo+W5h42j8t9vUwef1e9YPbYOesuu8fK5V/YPDat6mTzeLV6JqvH
	nWt72Dw2L6n3eHWNxaNvyypGj+3X5jF7fN4kF8AXxWWTkpqTWZZapG+XwJVxZ+dUloI2wYqO
	fQdZGxjf83QxcnJICJhIPFk9nQnCFpO4cG89WxcjF4eQwFJGiXsT7rFCOL1MEmd/fGfvYuTg
	YBPQltiywwukQURAQWJz7zOwGmaBT2wSP1Y1gU0SBqrZuWACM4jNIqAq8fX1YbA4r4CrxKVt
	P1ghtilKdD+bwDaBkXsBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAo+bqDcekxq0OM
	AhyMSjy8EtVcwUKsiWXFlbmHGCU4mJVEeGvKgEK8KYmVValF+fFFpTmpxYcYmTg4pRoY88TY
	G5dLVAn0G99UqZN+/zWppK/ooUWU8PRTz9a1yVvlNRYG8c7wOJKZ/sQqkuvl8cWlPfHvJ4u/
	ZZBaFG65ceNMkx0v6h8ZLEk9ueiK4vVb0hMWSFkHKWnnXpXwaWvvLW4wen6m4/jOnfNEGbl9
	Jr45KXlKj6V+aa6YwYJ9AUnPZvjufJmpxFKckWioxVxUnAgALCRt0nACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture

Patches add new platform description, support of clock controller and device 
tree for Exynos 5410.

Has been build on Linux Kernel v3.14-rc1 (Samsung kernel,
	for-next branch,
	commit aaeeda6f57833c7c0e16fef3d76205f36882c21b,
	"Merge branch 'v3.15-next/cleanup-samsung' into for-next")
Has been tested on Exynos 5410 reference board (exynos_defconfig)

I hope, this is enough clean and hasn't any dependencies to go through 
Samsung tree.

Tarek.

Changelog:

v7:
	small changes for resolving conflicts related to changes in 
	Samsung tree.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   54 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   72 +++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  140 +++++++++++++
 arch/arm/mach-exynos/Kconfig                       |   10 +
 arch/arm/mach-exynos/common.c                      |   18 ++
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    1 +
 arch/arm/mach-exynos/platsmp.c                     |    2 +
 arch/arm/plat-samsung/include/plat/cpu.h           |    8 +
 arch/arm/plat-samsung/include/plat/map-s5p.h       |    3 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  208 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   32 +++
 14 files changed, 551 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.10.4

