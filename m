Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaDNHSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:18:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52539 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDNHR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:17:57 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-29-534b8ba25834
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
Subject: [PATCH v8 0/3] Exynos 5410 support
Date: Mon, 14 Apr 2014 11:17:37 +0400
Message-id: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xq7qLur2DDf6tNbSYtO4Ak8XD9TdZ
	LOYfOcdq0f9mIavF/0evWS3OvVrJaNG74CqbxdmmN+wWmx5fY7VY2LaExeLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFk8nXGSzmDB9LYvFupfTWSxa9x5ht9jys4PR4nfPJ2aL9c9PMVqsn/GaxeLY
	jCWMFlNn/GB3kPBYM28No0dLcw+bx+W+XiaPv6teMHvsnHWX3WPl8i9sHptWdbJ5vFo9k9Xj
	zrU9bB6bl9R7vLrG4tG3ZRWjx/Zr85g9Pm+SC+CL4rJJSc3JLEst0rdL4Mp4era6YAV/xanl
	c9kaGBdydzFyckgImEj8+PecCcIWk7hwbz1bFyMXh5DAUkaJD49vsEI4nUwSt9e/AMpwcLAJ
	aEts2eEF0iAioCCxufcZWA2zwCc2iR+rmsAmCQPVrP91nRXEZhFQlXjUsoINxOYVcJXo3XOf
	GWSOBFDznEk2Exi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQIiZCvOxiXHrM6xCjA
	wajEw8ux1TNYiDWxrLgy9xCjBAezkgjvtgyvYCHelMTKqtSi/Pii0pzU4kOMTBycUg2M+0S+
	eMpyfe6evOuIzMZaz7ULe36vf9E3J8Do0e5v0235fdqaGoMaI203nYqN2sh3d3/sxfb9ARlW
	6eUPmH7cVBFLKdv3MK9Ch3Or8B5Rxt3Tp65zs06Vqw/6+W3CpATFDe1y/aINreIW3y5n6i0w
	Wlk392eVu47ajdgNV11bLnbxveCyfWGvxFKckWioxVxUnAgAX9owg24CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture

Patches add new platform description, support of clock controller and device
tree for Exynos 5410.

Has been build on Linux Kernel v3.15-rc1
Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
		    2) Odroid-XU board (exynos_defconfig)

I hope, this will be commited to Linux v3.15...

Tarek.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   51 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   65 ++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  140 ++++++++++++
 arch/arm/mach-exynos/Kconfig                       |    8 +
 arch/arm/mach-exynos/exynos.c                      |   12 ++
 arch/arm/mach-exynos/hotplug.c                     |    4 +-
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/platsmp.c                     |   10 +-
 arch/arm/mach-exynos/regs-pmu.h                    |    4 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |   11 +-
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  223 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   33 +++
 14 files changed, 556 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.9.5

