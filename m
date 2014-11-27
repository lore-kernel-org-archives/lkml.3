Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaK0Hfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaK0HfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:22 -0500
X-AuditID: cbfee68d-f79296d000004278-90-5476d43692ee
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 00/19] arm64: Add the support for new 64-bit Exynos5433 SoC
Date: Thu, 27 Nov 2014 16:34:57 +0900
Message-id: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkQNfsSlmIwdc+BYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtM+bOcyWLT
	42usFpd3zWGzmHF+H5PF0usXmSxOXf/MZnH4TTurxYzJL9ksjs1YwmixatcfRouXH0+wOIh5
	rJm3htHj969JjB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABHFJdNSmpOZllqkb5d
	AlfGnSW/mAp2yVb8WHKZtYHxsXgXIyeHhICJxLZDjWwQtpjEhXvrgWwuDiGBpYwS197OYYIp
	WnTzPVRiOqNE29kTrCAJIYEmJom3a21AbDYBLYn9L26ATRIRcJZomNrIBNLALPCRWaJh2kWw
	BmEBb4ktU6exgNgsAqoSKza9BLN5BVwl9q5ugNqmILFs+UxWkGYJgUYOifOTLrFBNAhIfJt8
	CKiBAyghK7HpADNEvaTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERhp
	p/89693BePuA9SFGAQ5GJR5eiwNlIUKsiWXFlbmHGE2BNkxklhJNzgfGc15JvKGxmZGFqYmp
	sZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxuKVrpzkKLJ+XHXlO886lw
	+YsdQgyegWsPsDzet9XaWq2mveTDswtTHBsz+580qWyPPVEsU/QqfP+nB8fiDRctnXWFa+25
	xIC1K47rdioEFf+rmjMxQHsaJ9fz40JfqutSBZXbF9Ut4A+7YdBY8039iZHJPmPz32rT7GuE
	Tacq/JZQ/HyyileJpTgj0VCLuag4EQAH4VeXrwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV2zK2UhBrOvC1s8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZtxZ8oupYJdsxY8ll1kbGB+LdzFyckgImEgsuvme
	DcIWk7hwbz2QzcUhJDCdUaLt7AlWkISQQBOTxNu1NiA2m4CWxP4XN8AaRAScJRqmNjKBNDAL
	fGSWaJh2EaxBWMBbYsvUaSwgNouAqsSKTS/BbF4BV4m9qxuYILYpSCxbPpN1AiP3AkaGVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBcfxMegfjqgaLQ4wCHIxKPLwWB8pChFgTy4orcw8x
	SnAwK4nwSi0CCvGmJFZWpRblxxeV5qQWH2I0Bdo+kVlKNDkfmGLySuINjU3MjCyNzA0tjIzN
	lcR5b9zMDRESSE8sSc1OTS1ILYLpY+LglGpgTH37sCxtVvF6t6SjD+7VJ9R/Xjwrcf6bjKQb
	HXfnbMhgm/ukxGpZqoYZg9TU/6muTde63910LvklOf392a5Js54HLfq02fjA2jrny7OzGjIn
	Z/DOY9/uZcxZ+jSdbebDvlvx/FJlOvs0Ne1+N7/YEnAlP1WydyfHj92/c2QenRU+WGKeq6se
	q8RSnJFoqMVcVJwIADzcZF75AgAA
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

This patchst is based on Exynos7 patchset[1] because Exynos5433 has similiar
feature with Exynos7. Exynos7 did already specify the dependent patchset list.

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

Chanwoo Choi (18):
  pinctrl: exynos: Add support for Exynos5433
  clk: samsung: Add binding documentation for Exynos5433 clock controller
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

Jaehoon Chung (1):
  arm64: dts: exynos: Add MSHC dt node for Exynos5433

 .../devicetree/bindings/clock/exynos5433-clock.txt |  167 +
 arch/arm64/Kconfig                                 |   10 +
 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi |  698 ++++
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         |  684 ++++
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5433.c               | 3409 ++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  163 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          |    2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h          |    1 +
 drivers/tty/serial/samsung.c                       |   56 +-
 include/dt-bindings/clock/exynos5433.h             |  867 +++++
 11 files changed, 6038 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
 create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5433.c
 create mode 100644 include/dt-bindings/clock/exynos5433.h

-- 
1.8.5.5

