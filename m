Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaESDhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:37:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaESDhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:37:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-b6-53797c865910
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
Subject: [PATCH v9 0/3] Exynos 5410 support
Date: Mon, 19 May 2014 07:37:17 +0400
Message-id: <1400470640-30611-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7ptNZXBBkv/c1pMWneAyeLh+pss
	FvOPnGO16H+zkNXi/6PXrBbnXq1ktOhdcJXN4mzTG3aLTY+vsVosbFvCYnF51xw2ixnn9zFZ
	3L7Ma7H0+kUmi6cTLrJZTJi+lsVi3cvpLBate4+wW2z52cFo8bvnE7PF+uenGC3Wz3jNYnFs
	xhJGi6kzfrA7SHismbeG0aOluYfN43JfL5PH31UvmD12zrrL7rFy+Rc2j02rOtk8Xq2eyepx
	59oeNo/NS+o9Xl1j8ejbsorRY/u1ecwenzfJBfBFcdmkpOZklqUW6dslcGUsufaPtaCDr2LS
	l26mBsbTXF2MnBwSAiYS99uvMUPYYhIX7q1n62Lk4hASWMooseDQM0YIp4NJYmvneSCHg4NN
	QFtiyw4vkAYRAQWJzb3PWEFqmAU+sUn8WNXEBJIQBqrZMfUaO4jNIqAqce3OFTCbV8BV4tqT
	n2wgcySAmudMspnAyL2AkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkiMfNnBuPiY1SFG
	AQ5GJR7eDwmVwUKsiWXFlbmHGCU4mJVEeD95A4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwmrrf
	nPs7/aLwv/zfMlL/tQz+rbl8Yqlk+Jnzh9bv/Ww1rS6k3Mg3+aFoz2yLktV/fba1RTQVb02P
	yrmZ+0mN6fKfIu+w9s+zzdc19YS4bNyVfcjBWq/deguP0IsVQZapB5n/bYv4NJUvOE6zaO2y
	2YeOTyvLTrm4UmUtW2HIzvVRkqf2951rVGIpzkg01GIuKk4EAJ9dBxNvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture

Patches add new platform description, support of clock controller and device
tree for Exynos 5410.

Has been build on Samsung Linux Kernel
  (branch: for-next, commit: ccf5511 ARM: EXYNOS: Add MCPM call-back functions)
Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
		    2) Odroid-XU board (exynos_defconfig)

Tarek.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   51 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   65 ++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  158 ++++++++++++++
 arch/arm/mach-exynos/Kconfig                       |    8 +
 arch/arm/mach-exynos/exynos.c                      |    1 +
 arch/arm/mach-exynos/platsmp.c                     |    4 +
 arch/arm/plat-samsung/include/plat/cpu.h           |   11 +-
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  223 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   33 +++
 11 files changed, 555 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.9.5

