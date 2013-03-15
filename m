Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3COIE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:04:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37789 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3COIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:04:18 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-f5-5142d600b815
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v5 0/3] ARM: Exynos5250: Enabling dwc3-exynos driver
Date: Fri, 15 Mar 2013 13:32:11 +0530
Message-id: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkVpfhmlOgwd9XahYL25awWFzeNYfN
	Ysb5fUwWi5a1MjuweHzeJBfAGMVlk5Kak1mWWqRvl8CVMXV1P2vBBq6Kxfe/sjYwTuLoYuTk
	kBAwkZixfR8ThC0mceHeejYQW0hgKaPE3nfxXYwcYDVfTwZ2MXIBhRcxStw8NhOqZgqTxKYT
	WSA2m4CuRNPbXYwgtohAusSCzx/AZjILfGeU2LOXE8QWFnCRuNNzlxnEZhFQlWi9950FxOYV
	8JD40fyXDeIGBYk3t58xQ9jX2SSO7HGBqBeQ+Db5EAvEPbISmw5AlUhKHFxxg2UCo+ACRoZV
	jKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIGhdvrfs/4djHcPWB9iTAYaN5FZSjQ5HxiqeSXx
	hsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg9POc67N/
	q+XqBdOeOrO84Fs7we6j6tcXM+Uu7Pf7FBIscl8sTU6SoWDC6X9Tr/Ue3ryn89VMQ5NKraQf
	szlc8vetVhRXn+vHbGHMXm1hKx2+YMWJ6Z+yip5Xn4ibHakUXLnquQmftf8yB05+tueNlQqZ
	r/gOmQqXCa+qOXbQOmtV1MvJq/JeKbEUZyQaajEXFScCAE0H5xtLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAV2Ga06BBm92SFosbFvCYnF51xw2
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8bU1f2sBRu4Khbf/8rawDiJo4uRg0NCwETi68nALkZOIFNM4sK99WxdjFwcQgKLGCVuHpvJ
	BpIQEpjCJLHpRBaIzSagK9H0dhcjiC0ikC6x4PMHJhCbWeA7o8SevZwgtrCAi8SdnrvMIDaL
	gKpE673vLCA2r4CHxI/mv2wQyxQk3tx+xjyBkXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOBgfia1g3Flg8UhRgEORiUe3gP9DoFCrIllxZW5hxglOJiVRHg9vRwDhXhTEiurUovy
	44tKc1KLDzEmA22fyCwlmpwPjLS8knhDYxNzU2NTSxMLEzNL0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamA8bvsmuvf38w+M128eDxT8W7NvQ3iPrJTMTL4/5Se/zflhvnQ/q+5br8db
	D/FwckUsWML1KGZnVmJFU1/yjru1LzW+fVr5v/tDrmvIHL0j2W8DU2RZjnfM+cjsmF5ScFMp
	98s8vp2xXp7iFyavOVCly9PLsNdGa+U2/j/MIWn7VrlPffk27H2GEktxRqKhFnNRcSIAR3Bo
	AaoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set is in continuation with patch-series:
[PATCH v4 0/4] Enable ehci, ohci and dwc3 devices on exynos5250
out of which follwowing patches have been picked up:
ARM: Exynos5250: Enabling ehci-s5p driver
ARM: Exynos5250: Enabling ohci-exynos driver

Based on following patch-set for Samsung's usb PHY enablement:
[PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy

and further depends on dwc3-exynos driver patch-set:
[PATCH 0/2] dwc3: exynos: Device tree fixes

Changes from v4:
 - Aligning with the recently merged common clock framework, thereby
   no place for clock file changes. ;-)
 - Adding proper binding documentation as per latest bindings changes in
   dwc3 driver (dwc3/core.c as well as for dwc3-exynos.c change reflected
   by above patch-set.
 - Bifurcating the patch to separate our Documentation, arch and dts changes.

Vivek Gautam (3):
  usb: Add device tree bindings for dwc3-exynos
  ARM: exynos5250: dts: Enabling dwc3-exynos driver
  ARM: exynos5: Enable XHCI support on exynos5

 .../devicetree/bindings/usb/exynos-usb.txt         |   34 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |   20 ++++++++++-
 arch/arm/mach-exynos/Kconfig                       |    1 +
 3 files changed, 53 insertions(+), 2 deletions(-)

-- 
1.7.6.5

