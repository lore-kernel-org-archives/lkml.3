Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbbAVLS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:18:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbbAVLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:18:23 -0500
X-AuditID: cbfee68e-f79b46d000002b74-3b-54c0dc7cf783
From: Inha Song <ideal.song@samsung.com>
To: alsa-devel@alsa-project.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        s.nawrocki@samsung.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        ideal.song@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [alsa-devel] [PATCH v3 0/4] Sound support for Exynos4412 Trats2 board
Date: Thu, 22 Jan 2015 20:17:58 +0900
Message-id: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWLfmzoEQg8mLFS2uXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDLWtR9jLrjAXbHs7XfWBsY3HF2MnBwSAiYSh68uYoewxSQu3FvP
	1sXIxSEksJRRYuOxZnaYoq9/l7FAJBYxSjRuPcUGkhASmMMksaI5FcRmE9CQ+P55M3MXIweH
	iIC8xKH3eSD1zAJXmCU+rpjFDFIjLOAnsejEb1YQm0VAVWLD8n2MIDavgJvExv6VbBDLtCX2
	NcyEsudySBz+JQJRLyDxbfIhFpD5EgKyEpsOMEOUSEocXHGDZQKj4AJGhlWMoqkFyQXFSelF
	RnrFibnFpXnpesn5uZsYgRF4+t+zvh2MNw9YH2IU4GBU4uHNKD4QIsSaWFZcmXuI0RRow0Rm
	KdHkfGCc55XEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wCjYHh7tVSs4/dNm14cZf44wspUFcIvWLo1f0eGn+urqv7/ME5a4bp644IhVk/YV4Q+vXos9
	rV594OPqhB/fxdqL7/TV1oR2ijza+m3xswP+ecujlZX+NuR59DxinHFW4+6yU2bOsy0vC2ls
	m83Bs67+MpvfH+7P7cuiFkRf99L90N73Q1ptQ4ASS3FGoqEWc1FxIgC5TAg8uwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd2aOwdCDJouiVtcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWNd+jLngAnfFsrffWRsY
	33B0MXJySAiYSHz9u4wFwhaTuHBvPVsXIxeHkMAiRonGrafYQBJCAnOYJFY0p4LYbAIaEt8/
	b2buYuTgEBGQlzj0Pg+knlngCrPExxWzmEFqhAX8JBad+M0KYrMIqEpsWL6PEcTmFXCT2Ni/
	kg1imbbEvoaZbBMYuRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7wZ9I7GFc1WBxi
	FOBgVOLhzSg+ECLEmlhWXJl7iFGCg1lJhNf0BFCINyWxsiq1KD++qDQntfgQoynQ9onMUqLJ
	+cDkk1cSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwLh2LatZRv6i
	Aw/WPuB+p94yw+XraqalN1rENj98srQxdE6XU79W7MlF8Z9NWlYW7o6ad53v/Znndm3JzWs2
	6DSs33qzMqEtKL+puXlqtMiBjpvTvGq0Jyt7h54TX/v92bq2RZP6rQ782nBys+I+yeDzCR1m
	AUzbQ8zYMyZ9U4qcL3WfycT241YlluKMREMt5qLiRAB3TDoPBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds basic sound support for the Trats2 boards.
It just support primary I2s and external speaker playback.

Changes in v3:
  - Set clock out parent to XUSBXTI in pmu_system_controller DT node.

Changes in v2:
  - Remove unnecessary lines in Trats2 machine driver
  - move clock enable/disable to .startup / .shutdown
  - Fix code style issues
  - Remove mclk DT property in Trats2 sound and add MCLK1 property in WM1811 node.
    (MCLK1 is optional property in WM8994 node - refer: Document/devicetree/bindings/sound/wm8994.txt)
  - Use mclk that defined in WM1811 DT node.
  - Add "samsung,audio-codec" property to required properties.

Inha Song (4):
  ASoC: samsung: Add machine driver for Trats2
  ASoC: samsung: Document Trats2 audio subsystem bindings
  ARM: dts: set clock out parent to XUSBXTI
  ARM: dts: Add sound nodes for exynos4412-trats2

 .../bindings/sound/samsung,trats2-wm1811.txt       |  25 +++
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  37 ++++
 sound/soc/samsung/Kconfig                          |   8 +
 sound/soc/samsung/Makefile                         |   2 +
 sound/soc/samsung/trats2_wm1811.c                  | 218 +++++++++++++++++++++
 6 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

-- 
2.0.0.390.gcb682f8

