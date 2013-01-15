Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3AONca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:32:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40088 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab3AONc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:32:26 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d2-50f55a68bb2d
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v4 0/4] Enable ehci, ohci and dwc3 devices on exynos5250
Date: Tue, 15 Jan 2013 19:08:28 +0530
Message-id: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkVjcj6muAwa+F+haXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZTxY2MNSMJ2z4u7Z3UwNjJ3sXYycHBICJhIT
	Nn5mhLDFJC7cW8/WxcjFISSwlFHia/Ny1i5GDrCiwytLQGqEBBYxSixrkYComcwk8ej8fRaQ
	BJuArkTT211gg0QEVCU+ty0AW8AscIhR4tRUd5A5wgIeEo1v7EHCLEAl76ZMByvnBQovaHkN
	dYOCxJvbz5ghagQkvk0+xAJxgqzEpgPMIGslBI6wSezY/IQZol5S4uCKGywTGAUXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAgMsdP/nknvYFzVYHGIUYCDUYmH96bulwAh1sSy4spc
	oBs5mJVEeDWMvgYI8aYkVlalFuXHF5XmpBYfYvQBumQis5Rocj4w/PNK4g2NTcxNjU0tjYzM
	TE1xCCuJ8zKeehIgJJCeWJKanZpakFoEM46Jg1OqgXFLtROXyIJV7y8JX/25PTOgddq3sBe3
	9dvZqi9/bLvZdu5Q1GPbMJnNJxpStsTf9DNckMnmbSr26HvcLu1bgkySMrU9k3j17HZOc79w
	82v3i0u7s7/6vbvmbJG5uH7z4vSvyjW6h74HvlAIupAUk31/p4oM08KgRz6eQf6FHPY3OHSu
	6PJPCFViKc5INNRiLipOBACIHD5vXgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAd2MqK8BBs+nq1pc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxYGEP
	S8F0zoq7Z3czNTB2sncxcnBICJhIHF5Z0sXICWSKSVy4t54NxBYSWMQosaxFoouRC8iezCTx
	6Px9FpAEm4CuRNPbXYwgtoiAqsTntgXsIDazwCFGiVNT3UFmCgt4SDS+sQcJswCVvJsyHayc
	Fyi8oOU1I8QuBYk3t58xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOICfSe9g
	XNVgcYhRgINRiYf3pu6XACHWxLLiylygnRzMSiK8GkZfA4R4UxIrq1KL8uOLSnNSiw8x+gBt
	n8gsJZqcD4yuvJJ4Q2MTc1NjU0sTCxMzSxzCSuK8jKeeBAgJpCeWpGanphakFsGMY+LglGpg
	tPs8wa3QQDPq6qpyA+f2V9qmaQYv9pnuve9b1vLVdeeKmo2aabs+hEZuDntuPY+Pd91Fa4sS
	T5eXt2MCDvnW+t4W7Z8armL5ja/q4DSv+wWp7D7ZPm3bf/9v59JW+yWRZjDrldyxsKmt99kO
	6ixUEP09f0V7l33q7GX8C5vvv/KrXS+5ppJbiaU4I9FQi7moOBEAEvBhc40CAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v3:
 - Clubbed together arch enable patches for ehci/ohci and dwc3:
   [PATCH v3 0/2] Enable ehci and ohci devices for exynos5250, and
   [PATCH v3] ARM: Exynos5250: Enabling dwc3-exynos driver
 - Dropped OF_DEV_AUXDATA entry in mach-exysno5-dt since we don't
   need it.
 - Splitted the patch "ARM: Exynos5250: Enabling dwc3-exynos drive"
   into clock patch and device enabling patch.
 - Rebased on top of 'for-next' of linux-samsung tree.

Vivek Gautam (4):
  ARM: Exynos5250: Enabling ehci-s5p driver
  ARM: Exynos5250: Enabling ohci-exynos driver
  ARM: Exynos5250: Add clock information for dwc3-exynos
  ARM: Exynos5250: Enabling dwc3-exynos driver

 .../devicetree/bindings/usb/exynos-usb.txt         |   54 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |   18 +++++++
 arch/arm/mach-exynos/Kconfig                       |    1 +
 arch/arm/mach-exynos/clock-exynos5.c               |   24 +++++++++
 5 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt

-- 
1.7.6.5

