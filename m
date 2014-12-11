Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaLKMKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:10:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22790 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:10:30 -0500
X-AuditID: cbfee691-f79b86d000004a5a-b6-548989b30cd2
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kishon@ti.com, k.debski@samsung.com, kgene@kernel.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/4] phy: samsung-usb2: Add support for Vbus regulator
Date: Thu, 11 Dec 2014 17:32:43 +0530
Message-id: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkSndzZ2eIwdEZOhbzj5xjtWi7cpDd
	4vLCS6wWP15fYLPof/ya2eLC0x42i8u75rBZzDi/j8li0bJWZovWvUfYHbg8Nq3qZPPo27KK
	0eP4je1MHp83yQWwRHHZpKTmZJalFunbJXBl/HhqWDCNp6L/+D7WBsb9nF2MHBwSAiYSCzYZ
	dzFyApliEhfurWfrYuTiEBJYyiixoXkFM0TCROLA6QPMEIlFjBJtD7pZIZwJTBLt/ReYQKrY
	BHQlmt7uYgSxRQRqJKbcusIOUsQs0Mso8e/DOVaQhLCAm8Surd/AGlgEVCX6Gq+BxXkF3CV+
	rDnODrFOTmLLrUdgzRIC3ewSLXsnsUE0CEh8m3yIBeJuWYlNB6DOk5Q4uOIGywRGwQWMDKsY
	RVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAkP59L9nE3cw3j9gfYhRgINRiYc3I74zRIg1say4
	MvcQoynQhonMUqLJ+cCIySuJNzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgVHv5POJnw4vmKjqr/p4bcQs4wlBi77xLZM8KlH9PaKjh41LKWenSM8l2YLn
	Kge0u7ZXXpaMqOpbJju1fc2evqy71ZpHnY22nU/J8zwY6Z9drfk/48VtOf515Wbhj5f7Z+1M
	XseyN7k3VeZcSvqFW9+nrZrG7HnTLHXezIDrIr4L0yIjTKcvy1ViKc5INNRiLipOBADIQHx7
	YAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd3NnZ0hBnOfqVjMP3KO1aLtykF2
	i8sLL7Fa/Hh9gc2i//FrZosLT3vYLC7vmsNmMeP8PiaLRctamS1a9x5hd+Dy2LSqk82jb8sq
	Ro/jN7YzeXzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
	q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePHU8OC
	aTwV/cf3sTYw7ufsYuTkkBAwkThw+gAzhC0mceHeerYuRi4OIYFFjBJtD7pZIZwJTBLt/ReY
	QKrYBHQlmt7uYgSxRQRqJKbcusIOUsQs0Mso8e/DOVaQhLCAm8Surd/AGlgEVCX6Gq+BxXkF
	3CV+rDnODrFOTmLLrUfsExi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjpVn0jsY
	VzVYHGIU4GBU4uHNiO8MEWJNLCuuzD3EKMHBrCTCaxUBFOJNSaysSi3Kjy8qzUktPsRoCrR9
	IrOUaHI+MI7zSuINjU3MTY1NLU0sTMwslcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pRoY80wj
	8jb2TOu/ctOA06pPNmdK9h7HZ/vXxV7w7Anndjm9MU/g9l4Nh4/x6trFT9nX1T7X8OWUuym8
	TGUy38q36jtW9+kcqPW3EYrW5LeyYY1y2jq7mcVgS+blb5KKHw5wXTxzznvLt2TJFGGz3WrT
	c/2+ND3+9GbzTh+z9T1LEpf32U+TTn+rxFKckWioxVxUnAgArQ2/qasCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been on my to-do list for sometime.
Until now the host controller (specifically ehci-exynos) is responsible
for enabling VBUS supply. This opens up one more issue which is, when
only ohci-exynos is enabled and ehci-exynosis disabled then VBUS was
never enabled (since ohci did not have the code to enabled the VBUS supply).

Rather it should be wise to move the VBUS related stuff to phy driver and
let phy take care of enabling it.

This patch series adds that VBUS regulator to phy-samsung-usb2 driver,
adds necessary binding information as well as vbus-supply properties
to phy nodes on exynos5250 systems.
Also we have removed the samsung,vbus-gpio property from usb2 (ehci) node
on exynos5250 systems.

**[The older code in ehci-exynos for vbus setting is left intact to keep
supporting older dt bindings].

Vivek Gautam (4):
  Doc/devicetree: bindings: Update bindings information for USB3.0 DRD
    PHY
  phy: samsung-usb2: Add facility for VBUS supply
  arm: dts: exynos5250: Use regulator for USB 2.0 VBUS supply
  arm: dts: exynos5250: Remove vbus gpio property from usb 2.0 host

 .../devicetree/bindings/phy/samsung-phy.txt        |   12 ++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   22 ++++++++++++--
 arch/arm/boot/dts/exynos5250-snow.dts              |   22 ++++++++++++--
 drivers/phy/phy-samsung-usb2.c                     |   30 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.h                     |    1 +
 5 files changed, 83 insertions(+), 4 deletions(-)

-- 
1.7.10.4

