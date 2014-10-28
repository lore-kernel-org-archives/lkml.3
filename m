Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaJ1EqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:46:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49187 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020AbaJ1EqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:46:14 -0400
X-AuditID: cbfee68f-f791c6d000004834-e6-544f1f9454c2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 0/2] ARM: EXYNOS: Support new Exynos4415 SoC based on
 Cortex-A9 quad cores
Date: Tue, 28 Oct 2014 13:46:08 +0900
Message-id: <1414471570-5135-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkQHeKvH+IQdMSdYu/k46xW1z/8pzV
	Ytff+4wWk+5PYLHY0XCE1aJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWaw9cpfdYun1i0wW
	p65/BopNfslmsWrXH0aLvTsnMzoIeKyZt4bR4/evSYweO2fdZffYvKTe48qJJlaPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgyvh66ARrwXmein/PH7A3MK7h6mLk5JAQMJFY8/E9O4QtJnHh
	3nq2LkYuDiGBpYwSd+7PYIIpWr51KQtEYjqjxOK+E+wQThOTxI6119lAqtgEtCT2v7gBZosI
	SEo0NfxhBrGZBRqZJRrahUFsYYE4ibf/DjCC2CwCqhKNN3azdjFycPAKuEg8Ws4JsUxBYtny
	mawg8yUEzrFLzJzawAZRLyDxbfIhFpB6CQFZiU0HmCHqJSUOrrjBMoFRcAEjwypG0dSC5ILi
	pPQiY73ixNzi0rx0veT83E2MwBg5/e9Z/w7GuwesDzEKcDAq8fAaPPQLEWJNLCuuzD3EaAq0
	YSKzlGhyPjAS80riDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwLj04m/jl6/yH79T3HNvp4nK5pfNB7tvVKSaHutPXLDuo8sy64R9l1aUcr7xEEpxfmc+
	RTUiS/NswJEbm//U20ac4ONktWLQfSlrFM7KGjpHPU5v1uff5eks624+cjQJ3bf8X9Y7m7qd
	s4VezVBbqHannueX3Fdx3+OeW/dzXn20tM/V0X/FnU9KLMUZiYZazEXFiQC22NnqjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jQd0p8v4hBlvWyln8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMr4dOsBac56n49/wB
	ewPjGq4uRk4OCQETieVbl7JA2GISF+6tZ+ti5OIQEpjOKLG47wQ7hNPEJLFj7XU2kCo2AS2J
	/S9ugNkiApISTQ1/mEFsZoFGZomGdmEQW1ggTuLtvwOMIDaLgKpE443drF2MHBy8Ai4Sj5Zz
	QixTkFi2fCbrBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/CZ9A7GVQ0WhxgF
	OBiVeHgNH/qFCLEmlhVX5h5ilOBgVhLh9doBFOJNSaysSi3Kjy8qzUktPsRoCrR8IrOUaHI+
	MDnklcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgVAjJWcl5oMr/
	+0OPz19yj//X+/tDqf/UzNUt8hm/zor/1UnSYV7nLGdwRTTxZ/t3vZkTvj9nNnlXzmEw+1Li
	+3eHT1hvkt74anmxhLzPA09hmU+5G3Yq1pSISUbeTz0uw/p647vPHNaLLl0/cMlCLOX+u6nm
	xxjTVxf3X12R/Ub+QuKL/qV2mkosxRmJhlrMRcWJAK2vZBLWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos4415 Samsung SoC based on Cortex-A9 quad cores.
Exynos4415 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate
process
and provides the best performance features.

This patchset include some patches such as:
- Support booting of Exynos4415
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/ehci/ohci/pwm/amba

Changes from v2:
- Modify the name of first patch

Changes from v1:
- Remove legacy helper function to identify SoC
- Separate out the clock patches[2] from Exynos4415 patchset[1] and sent it [2]
- Separate out the pinctrl patch[3] from Exynos4415 patchset[1] and sent it [3]
 [1] [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
 : https://lkml.org/lkml/2014/10/19/253
 [2] [PATCHv3 1/2] clk: samsung: exynos4415: Add clocks using common clock framework
 : https://lkml.org/lkml/2014/10/26/159
 [3] [PATCHv2] pinctrl: exynos: Add support for Exynos4415
 : https://lkml.org/lkml/2014/10/26/160

Chanwoo Choi (2):
  ARM: EXYNOS: Add EXYNOS4415 SoC
  ARM: dts: Add dts files for Exynos4415 SoC

 arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 613 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4415.dtsi         | 627 ++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/Kconfig              |   5 +
 arch/arm/mach-exynos/exynos.c             |   2 +
 4 files changed, 1247 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi

-- 
1.8.5.5

