Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbbAWFD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:03:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51937 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbAWFDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:47 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-34-54c1d6302b55
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
Subject: [alsa-devel] [PATCH v4 0/3] Sound support for Exynos4412 Trats2 board
Date: Fri, 23 Jan 2015 14:03:27 +0900
Message-id: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkWNfg2sEQg60XLCyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDIOnz/CWHCbp6L/RiNTA+NLzi5GTg4JAROJth3rmSBsMYkL99az
	dTFycQgJLGWU6H7yjA2m6G73VhaIxHRGicnf/rNCOHOYJCbOWA1WxSagIfH982bmLkYODhEB
	eYlD7/NAapgFrjBLfFwxixmkRljAT+Jk5xqwdSwCqhJ7V1wE6+UVcJP48qOHEWKbtsS+hplg
	Z0gIzOSQ2DyznxmiQUDi2+RDLCALJARkJTYdYIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KL
	TPSKE3OLS/PS9ZLzczcxAqPw9L9nE3Yw3jtgfYhRgINRiYe3YcvBECHWxLLiytxDjKZAGyYy
	S4km5wNjPa8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYztu589mBXjsupr6KKSY9ts5PLTvz1t9V53x/bdokXf2HY7pF37G+bMetllQpz9fFX90JX7
	niY+bjauX9i9eO/PTxkTHNyZTi1v9qoSqFmh6xrpu+34xr/a87Yf6LrMd/HhjZN7wx7WlR1L
	5/WLqNwmy93XU2PxmIErfNoJwc05vf0FcXWGJsuUWIozEg21mIuKEwFo3RGcvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQV2DawdDDN506ltcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOHz+CGPBbZ6K/huNTA2M
	Lzm7GDk5JARMJO52b2WBsMUkLtxbz9bFyMUhJDCdUWLyt/+sEM4cJomJM1azgVSxCWhIfP+8
	mbmLkYNDREBe4tD7PJAaZoErzBIfV8xiBqkRFvCTONm5hgnEZhFQldi74iJYL6+Am8SXHz2M
	ENu0JfY1zGSbwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwjD+T2sG4ssHiEKMA
	B6MSD2/DloMhQqyJZcWVuYcYJTiYlUR4nxwACvGmJFZWpRblxxeV5qQWH2I0Bdo+kVlKNDkf
	mH7ySuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pRoYQ+/e/mr6X+ep
	08fCZ6nWk7uLuH81Rfv4ux6aV2CcZRTC+KS/+Lxb5CH132UnBeNumTlde/w77/aWt2zlXUse
	Cuz7/0I5TS9MzCJoXv6mm8JGK2K/fnA2fr0o7oynbebBmPrebKs36cVON20PuZqJtyQVXc28
	sMas7sCDb/Lb+DUz33w0Tp+gxFKckWioxVxUnAgAuXUGnwcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds basic sound support for the Trats2 boards.
It just support primary I2s and external speaker playback.

Changes in v4:
  - Move to clock out parent settings in exynos4412-trats2.dts
  - Remove unnecessary lines in Trats2 machine driver.
  - Change name of dai stream to more cleary.
  - Add MFD_WM8994 to select in machine driver kconfig.

Changes in v3:
  - Set clock out parent to XUSBXTI in pmu_system_controller DT node.

Changes in v2:
  - Remove unnecessary lines in Trats2 machine driver.
  - move clock enable/disable to .startup / .shutdown.
  - Fix code style issues.
  - Remove mclk DT property in Trats2 sound and add MCLK1 property in WM1811 node.
    (MCLK1 is optional property in WM8994 node - refer: Document/devicetree/bindings/sound/wm8994.txt)
  - Use mclk that defined in WM1811 DT node.
  - Add "samsung,audio-codec" property to required properties.

Inha Song (3):
  ASoC: samsung: Add machine driver for Trats2
  ASoC: samsung: Document Trats2 audio subsystem bindings
  ARM: dts: Add sound nodes for exynos4412-trats2

 .../bindings/sound/samsung,trats2-wm1811.txt       |  25 +++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  42 ++++
 sound/soc/samsung/Kconfig                          |   9 +
 sound/soc/samsung/Makefile                         |   2 +
 sound/soc/samsung/trats2_wm1811.c                  | 211 +++++++++++++++++++++
 5 files changed, 289 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

-- 
2.0.0.390.gcb682f8

