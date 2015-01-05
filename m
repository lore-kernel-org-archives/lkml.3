Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbbAELZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:25:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39109 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbAELZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:25:40 -0500
X-AuditID: cbfee68d-f79296d000004278-2b-54aa74b1db50
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
Subject: [alsa-devel] [PATCH 0/3] Sound support for Exynos4412 Trats2 board
Date: Mon, 05 Jan 2015 20:25:14 +0900
Message-id: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkUHdTyaoQg50sFlcuHmKymPrwCZvF
	/CPnWC363yxktTjwZwejxa6/9xktzr1ayWjR//g1s8W3Kx1MFpseX2O1uLxrDpvFjPP7mCxu
	X+a1WHr9IpPFhOlrWSw6d/WzWrTuPcJucfhNO6vFxRVfmCxebn7D5CDiseFzE5vHmnlrGD1a
	mnvYPC739TJ57Jx1l91j5fIvbB6bVnWyedy5tofNY/OSeo99b5exefRtWcXosfl0tcfnTXIB
	vFFcNimpOZllqUX6dglcGV+v32crOMFW0XXoO2sD4y+WLkZODgkBE4nmfd/YIGwxiQv31gPZ
	XBxCAksZJX7vfcXYxcgBVrTugilEfBGjxL8/sxghnDlMEmv7roF1swloSHz/vJkZpEFEQF7i
	0Ps8kBpmgSvMEh9XzGIGqREW8Jb4dfMg2GYWAVWJxl3rwGxeATeJIxNvQ12kLbGvYSbYFRIC
	Mzkkvp99wATRICDxbfIhFoiLZCU2HWCGqJeUOLjiBssERsEFjAyrGEVTC5ILipPSiwz1ihNz
	i0vz0vWS83M3MQIj8PS/Z707GG8fsD7EKMDBqMTD63FiZYgQa2JZcWXuIUZToA0TmaVEk/OB
	cZ5XEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj+FHz
	Zu8Wkb3LPqpu4MmqXHxgeu/1nP06uYqvd8kuul5Qt0DSv/aqe+0C6fTZ7J6td19e6NTfEujH
	82o1X8oTda67k/RvBZW/UpSJSdNYbfFRcLHV+w36wgdDxYJ4Z6WJsXj8vXJe8NLtuiityI4l
	htZ2p7RXs/lcuyO8csVj3/M5lule++YosRRnJBpqMRcVJwIA/YuZ6bsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd2NJatCDJoOG1tcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Hr9PlvBCbaKrkPfWRsY
	f7F0MXJwSAiYSKy7YNrFyAlkiklcuLeerYuRi0NIYBGjxL8/sxghnDlMEmv7rrGBVLEJaEh8
	/7yZGaRZREBe4tD7PJAaZoErzBIfV8xiBqkRFvCW+HXzIAuIzSKgKtG4ax2YzSvgJnFk4m0W
	iG3aEvsaZrJNYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4wp9J72Bc1WBxiFGA
	g1GJh9fjxMoQIdbEsuLK3EOMEhzMSiK8r9JXhQjxpiRWVqUW5ccXleakFh9iNAXaPpFZSjQ5
	H5h88kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGMX2tkW16mel
	qc41e3Umxvjq//ad21XSD4TPqi64Id1t1FngHGjfJaKxe1uyQfyxHY4d72JN+Xnf/v+x2I+9
	6YFJVnY1x6ONBXtaV2jH7/7suM/hWO6Dp6EvknVikmLUMthrajWnHJaYP/GfHaPsocdxx/3W
	VAnGFAtvTTj50WlaY6OXWMElJZbijERDLeai4kQAleRSQwYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds basic sound support for the Trats2 boards.
It just support primary I2s and external speaker playback.

Inha Song (3):
  ASoC: samsung: Add machine driver for Trats2
  ASoC: samsung: Document Trats2 audio subsystem bindings
  ARM: dts: Add sound nodes for exynos4412-trats2

 .../bindings/sound/samsung,trats2-wm1811.txt       |  31 +++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  38 ++++
 sound/soc/samsung/Kconfig                          |   8 +
 sound/soc/samsung/Makefile                         |   2 +
 sound/soc/samsung/trats2_wm1811.c                  | 216 +++++++++++++++++++++
 5 files changed, 295 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
 create mode 100644 sound/soc/samsung/trats2_wm1811.c

-- 
2.0.0.390.gcb682f8

