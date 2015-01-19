Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbASJtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:49:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48925 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbASJt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:49:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-fa-54bcd2f264cb
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
Subject: [alsa-devel] [PATCH v2 0/3] Sound support for Exynos4412 Trats2 board
Date: Mon, 19 Jan 2015 18:48:19 +0900
Message-id: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkQPfzpT0hBp1OFlcuHmKymPrwCZvF
	/CPnWC363yxktTjwZwejxa6/9xktzr1ayWjR//g1s8W3Kx1MFpseX2O1uLxrDpvFjPP7mCxu
	X+a1WHr9IpPFhOlrWSw6d/WzWrTuPcJucfhNO6vFxRVfmCxebn7D5CDiseFzE5vHmnlrGD1a
	mnvYPC739TJ57Jx1l91j5fIvbB6bVnWyedy5tofNY/OSeo99b5exefRtWcXosfl0tcfnTXIB
	vFFcNimpOZllqUX6dglcGX/f9DAW9HJVHPjxhq2B8Ql7FyMnh4SAicTftr+MELaYxIV769m6
	GLk4hASWMkpsnnGdFaaof81UFojEdEaJ1j3TmSCcOUwS5z69YAapYhPQkPj+eTOQzcEhIiAv
	ceh9HkgNs8AVZomPK2aB1QgL+El0vXnHBmKzCKhKzDt2Cmw1r4CbxOXzl1ggtmlL7GuYCXaG
	hMBUDokjd54xQTQISHybfIgFZIGEgKzEpgPMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGR
	XnFibnFpXrpecn7uJkZgDJ7+96xvB+PNA9aHGAU4GJV4eDf47gkRYk0sK67MPcRoCrRhIrOU
	aHI+MNLzSuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg
	nPutwST30hPrt/dPPWPNF7xVYxR7dIN1VIs2/+tXKqeV/rGqz2ZW+/Jx3vKNIa1X9fh2iKsJ
	3HS4KvycS1r9PZvIlblSyu2ORy58E/oetjNfxrRh/l5mz1tfdaUy16fMPiyYUx3YHmiXuDdF
	Z8Ok746uum3tJ53maH9llo8rcotjkfPx1zyqxFKckWioxVxUnAgA71dp57wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd1Pl/aEGHw/bGJx5eIhJoupD5+w
	Wcw/co7Vov/NQlaLA392MFrs+nuf0eLcq5WMFv2PXzNbfLvSwWSx6fE1VovLu+awWcw4v4/J
	4vZlXoul1y8yWUyYvpbFonNXP6tF694j7BaH37SzWlxc8YXJ4uXmN0wOIh4bPjexeayZt4bR
	o6W5h83jcl8vk8fOWXfZPVYu/8LmsWlVJ5vHnWt72Dw2L6n32Pd2GZtH35ZVjB6bT1d7fN4k
	F8Ab1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0
	rZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4++bHsaCXq6KAz/esDUw
	PmHvYuTkkBAwkehfM5UFwhaTuHBvPVsXIxeHkMB0RonWPdOZIJw5TBLnPr1gBqliE9CQ+P55
	M5DNwSEiIC9x6H0eSA2zwBVmiY8rZoHVCAv4SXS9eccGYrMIqErMO3aKEcTmFXCTuHz+EtQ2
	bYl9DTPZJjByL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHOPPpHYwrmywOMQowMGo
	xMPLEbAnRIg1say4MvcQowQHs5IIL+MFoBBvSmJlVWpRfnxRaU5q8SFGU6DtE5mlRJPzgekn
	ryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBceXW/pmRceod4i93
	1T4u+2EQ+2bvy9Oih752LWDcVXSvcvbOA7MztrXuWZm3PcSqjvFzsLjDsTPP+h4x1ltO4kz5
	M03+q0F84N+efUXfG/8YCM4RDGUtsjIRO3/F6Op3n4tiuo6LPkSm8b9l3SvCJnFys1bo84Vy
	SXFNwdZG08zTd+3/067OqcRSnJFoqMVcVJwIACAOQasHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds basic sound support for the Trats2 boards.
It just support primary I2s and external speaker playback.

Changes in v2:
  - Remove unnecessary lines in Trats2 machine driver
  - move clock enable/disable to .startup / .shutdown
  - Fix code style issues
  - Remove mclk DT property in Trats2 sound and add MCLK1 property in WM1811 node.
    (MCLK1 is optional property in WM8994 node - refer: Document/devicetree/bindings/sound/wm8994.txt)
  - Use mclk that defined in WM1811 DT node.
  - Add "samsung,audio-codec" property to required properties.

Inha Song (3):
  ASoC: samsung: Add machine driver for Trats2
  ASoC: samsung: Document Trats2 audio subsystem bindings
  ARM: dts: Add sound nodes for exynos4412-trats2

 .../bindings/sound/samsung,trats2-wm1811.txt       |  25 +++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  39 ++++
 sound/soc/samsung/Kconfig                          |   8 +
 sound/soc/samsung/Makefile                         |   2 +
 sound/soc/samsung/trats2_wm1811.c                  | 218 +++++++++++++++++++++
 5 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

-- 
2.0.0.390.gcb682f8

