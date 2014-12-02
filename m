Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaLBIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaLBIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:00 -0500
X-AuditID: cbfee68d-f79296d000004278-e5-547d7d355e41
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 00/19] arm64: Add the support for new 64-bit Exynos5433 SoC
Date: Tue, 02 Dec 2014 17:49:37 +0900
Message-id: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWyRsSkRNe0tjbE4MBME4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGU8vbqF
	veCBakX3ttIGxsVyXYycHBICJhJvH85lgrDFJC7cW8/WxcjFISSwlFFi+qXtjDBFz5Z9YIFI
	TGeUOND/hAUkISTQxCQx+54QiM0moCWx/8UNNhBbRMBZomFqIxNIA7PAG2aJPfd3gzUIC/hK
	PFq3hB3EZhFQlfjVfoC5i5GDg1fARaJ3iSXEMgWJZctnsoL0Sgj8ZZfYOnUxK0S9gMS3yYdY
	QOolBGQlNoG0gtRLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBsXX6
	37PeHYy3D1gfYhTgYFTi4T15viZEiDWxrLgy9xCjKdCGicxSosn5wAjOK4k3NDYzsjA1MTU2
	Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMfz0fVWdG57NEVLh0ZY1S6xv
	XnPzaLr3XEH8Ku9uB4+DW7ZedMtQnNt2UDjCctLx1w+TygP2u+2yV11TKNcYmR54p1jvdqfq
	9q9V05gkXWd8mWqa1XVRXVJ/1aUf/x3yKjetOLpdd1me1o64bdHpvLc+vl/r8eh79+NfEhcN
	yteuDLl0be/Cd0osxRmJhlrMRcWJAHWMYY+oAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQV3T2toQg2/zNS0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx4+nVLewFD1QrureVNjAuluti5OSQEDCReLbsAwuELSZx4d56
	ti5GLg4hgemMEgf6n4AlhASamCRm3xMCsdkEtCT2v7jBBmKLCDhLNExtZAJpYBZ4wyyx5/5u
	sAZhAV+JR+uWsIPYLAKqEr/aDzB3MXJw8Aq4SPQusYRYpiCxbPlM1gmM3AsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBEfuM6kdjCsbLA4xCnAwKvHwnjhfEyLEmlhWXJl7iFGCg1lJ
	hPeXcW2IEG9KYmVValF+fFFpTmrxIUZToOUTmaVEk/OBSSWvJN7Q2MTMyNLI3NDCyNhcSZz3
	xs3cECGB9MSS1OzU1ILUIpg+Jg5OqQZG3if7RZf+X5XBLyfFvUZF7Eq1Rv3jU9J9OQ8Wy8m5
	qJa+zioMZeQuKXGc9qqf29FiaseD8Bijb/np9kvWp84Tf6vtda2/9KvT5OsXTedL33q7YR2n
	cIdI7ocb5spPZ1ppfOnZbDc7+8UZeZUS2YXxvKWBooEBwiw9vjNSNd+Jna/Yqzm5PUyJpTgj
	0VCLuag4EQBqvAO18gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds new 64-bit Exynos5433 Samsung SoC which contains quad
Cortex-A57 and quad Cortex-A53. It is desigend with the 20nm low power process.

This patchset include some patches such as:
- Support booting of Exynos5433
- Support UART/MCT/GIC/HSI2C/SPI/PDMA/MSHC
- Support the clock control for Exynos5433 using common clk framework

This patchst is based on linux-samsung.git (branch: v3.19-next/dt-samsung-64)

This patchset has the dependency as following list:
: The Exynos7 patchset[1] specified dependent patchset for 64-bit SoC.
 So, this patchset used same dependent patchset of Exynos7 patchset and Exynos7
 patchset about pinctrl patch. Additionally, SPI/MMC/PDMA patch [2-5] is used
 for kernel booting and mounting rootfs.

1. [PATCH v7 0/7] Enable support for Samsung Exynos7 SoC
- [1] http://www.spinics.net/lists/linux-samsung-soc/msg38734.html
2. [PATCH] spi: s3c64xx: add support for exynos7 SPI controller
- [2] http://www.spinics.net/lists/linux-samsung-soc/msg38607.html
3. [PATCH V7] mmc: dw_mmc: Add IDMAC 64-bit address mode support
- [3] https://lkml.org/lkml/2014/10/20/58
4. [PATCH] mmc: dw_mmc: exynos: Add support for exynos7
- [4] http://www.spinics.net/lists/linux-mmc/msg28294.html
5. [PATCH] dmaengine: pl330: Correct device assignment
- [5] https://lkml.org/lkml/2014/11/6/207

Changes from v1:
- Merge two patches (patch2, patch3) to solve incomplete description [by Arnd]
- Exynos5433 Clock driver
 : Fix wrong register and code clean by using space instead of tab [Pankaj]
 : Add CLK_IGNORE_UNUSED flag to pclk_sysreg_* clock for accessing system control register
 : Remove duplicate definition on the patch for CMU_BUS{0|1|2} domain
- Exynos5433 SoC DTS
 : Remove un-supported properties of arch_timer [by Marc and Mark]
 : Remove 'clock-frequency' property from 'cpus' dt node
 : Fix interrupt type from edge rising triggering to level high triggering
   because Cortex-A53/A57 use level triggering.
 : Fix defult address-size/size-celss from 1 to 2 because Exynos5433 is 64-bit SoC
 : Modify 'fin_pll' dt node to remove un-needed and ugly code
 : Move 'chipid' dt node under 'soc'
 : Use lowercase on all case in exynos5433.dtsi
 : Add PSCI dt node for secondary cpu boot
 : Add 'samsung,exynos5433' compatible to MCT dt node
- Divide pinctrl patch from this patchset
- Add new following patches:
  : clocksource: exynos_mct: Add the support for Exynos 64bit SoC
  : arm64: Enable Exynos5433 SoC in the defconfig

Chanwoo Choi (18):
  clk: samsung: exynos5433: Add clocks using common clock framework
  clk: samsung: exynos5433: Add MUX clocks of CMU_TOP domain
  clk: samsung: exynos5433: Add clocks for CMU_PERIC domain
  clk: samsung: exynos5433: Add clocks for CMU_PERIS domain
  clk: samsung: exynos5433: Add clocks for CMU_G2D domain
  clk: samsung: exynos5433: Add clocks for CMU_MIF domain
  clk: samsung: exynos5433: Add clocks for CMU_DISP domain
  clk: samsung: exynos5433: Add clocks for CMU_AUD domain
  clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
  clk: samsung: exynos5433: Add missing clocks for CMU_FSYS domain
  clk: samsung: exynos5433: Add clocks for CMU_G3D domain
  clk: samsung: exynos5433: Add clocks for CMU_GSCL domain
  arm64: exynos5433: Enable ARMv8-based Exynos5433 SoC support
  arm64: dts: exynos: Add dts files for 64-bit Exynos5433 SoC
  arm64: dts: exynos: Add SPI/PDMA dt node for Exynos5433
  serial: samsung: Add the support for Exynos5433 SoC
  clocksource: exynos_mct: Add the support for Exynos 64bit SoC
  arm64: Enable Exynos5433 SoC in the defconfig

Jaehoon Chung (1):
  arm64: dts: exynos: Add MSHC dt node for Exynos5433

 .../devicetree/bindings/clock/exynos5433-clock.txt |  167 +
 arch/arm64/Kconfig                                 |   10 +
 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi |  698 ++++
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         |  675 ++++
 arch/arm64/configs/defconfig                       |    1 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5433.c               | 3369 ++++++++++++++++++++
 drivers/clocksource/Kconfig                        |    1 -
 drivers/clocksource/exynos_mct.c                   |    4 +
 drivers/tty/serial/samsung.c                       |   56 +-
 include/dt-bindings/clock/exynos5433.h             |  843 +++++
 11 files changed, 5804 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5433.c
 create mode 100644 include/dt-bindings/clock/exynos5433.h

-- 
1.8.5.5

