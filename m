Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbaKUNnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:43:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14709 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaKUNnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:43:17 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-de-546f4172039c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 00/11] Exynos7: Adding USB 3.0 support
Date: Fri, 21 Nov 2014 19:05:43 +0530
Message-id: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkTrfIMT/E4PphE4uD9+st5h85x2rR
	duUgu0Xz4vVsFr0LrrJZXHjaw2ZxedccNovZS/pZLGac38dksWhZK7NF694j7BaH37SzWkz4
	fYHNYtWuP4wOfB47Z91l99i0qpPNY//cNewes+/+YPTo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBlnNhxgq1gikjF3Qe/2BoYP/N3MXJySAiYSHT+fcgKYYtJXLi3nq2LkYtDSGAp
	o8T9ZROYYIrWrrgBZgsJTGeUODU5BaJoApPEzolL2UASbAK6Ek1vdzGC2CICsxkl2g4KgRQx
	C9xjlPj8/jsLSEJYwEziwMkLzCA2i4CqxPvtH8BsXgEPiSW7G4GaOYC2KUjMmWQD0ishcIhd
	4unp9WwQ9QIS3yYfYoGokZXYdIAZ4jhJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchErzgxt7g0
	L10vOT93EyMwHk7/ezZhB+O9A9aHGAU4GJV4eD9MzwsRYk0sK67MPcRoCrRhIrOUaHI+MOry
	SuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWBDcIZmj
	EfnxwFqFM26HXRc33G356/FM7/Xb2emKOR2qiVOPSVUbHT351dTb5/rqO2L89YZORzQ3+mQ1
	L0qaEdozZUrN/287PleuKFaoObtDqnzi0TaZj3vqlGYENC41ey8UvV7L1uHfqt8rIoK+zIyV
	F1p+lvP/JjPvU5OCihrFF7xOT6o/osRSnJFoqMVcVJwIAM/Y6fmCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd0ix/wQgxNbtC0O3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWrXuPsFscftPOajHh
	9wU2i1W7/jA68HnsnHWX3WPTqk42j/1z17B7zL77g9Gjb8sqRo/jN7YzeXzeJBfAHtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLOSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePEjhNsBVNEKu4++MXWwPiZv4uRk0NC
	wERi7YobTBC2mMSFe+vZQGwhgemMEqcmp3QxcgHZE5gkdk5cCpZgE9CVaHq7ixHEFhGYzSjR
	dlAIpIhZ4B6jxOf331lAEsICZhIHTl5gBrFZBFQl3m//AGbzCnhILNndCNTMAbRNQWLOJJsJ
	jNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH2zOpHYwrGywOMQpwMCrx8H6Ynhci
	xJpYVlyZe4hRgoNZSYS3XDg/RIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wESQVxJvaGxi
	bmpsamliYWJmqSTOe+NmboiQQHpiSWp2ampBahFMHxMHp1QDo6Vd1M7v10zYT/cZ3FRfwcC4
	+HOmhV2w72uZX62BXWlrJRrqwq1ZWr7f0Ffui85dx6PAEGHGvE4679eW6psbOlLfLOfcm9GW
	pyEx4/DEaSZpX/lCOpZmPlD0Dg5aLNPV9sRg0zGmr6arbDvPOHKLPu6fvbDxs2fOmenfGS/G
	LtNLuf1zorSQEktxRqKhFnNRcSIA6glnX8wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series has dependency on
a) "[PATCH v7 0/7] Enable support for Samsung Exynos7 SoC"
   http://www.spinics.net/lists/linux-samsung-soc/msg38734.html
b) "[GIT PULL] Samsung clock changes for 3.19" - specifically the clock dt
   bindings header.
   http://comments.gmane.org/gmane.linux.kernel.samsung-soc/39142
c) "tty: serial: samsung: Clean-up selection of number of available UARTs"
   http://www.spinics.net/lists/linux-samsung-soc/msg37418.html
d) "dts, kbuild: Implement support for dtb vendor subdirs"(merged in linux-next)
   https://lkml.org/lkml/2014/10/21/654
e) "Samsung pinctrl patches for v3.19"
   http://www.spinics.net/lists/linux-samsung-soc/msg38744.html

Tested on Exynos7-espresso board with 3.18-rc5 and above dependencies.

Clubbing the pinctrl, clk, and usb driver changes alongwith the dt changes
together in this series only so as to avoid having 'n' number of dependencies.

The USB driver patches in this series were part of [1] sent earlier.
[1] [PATCH v2 0/4] usb: dwc3/phy-exynos5-usbdrd: Extend support to Exynos7
    https://lkml.org/lkml/2014/10/7/191

Vivek Gautam (11):
  pinctrl: exynos: Add BUS1 pin controller for exynos7
  dwc3: exynos: Remove local variable for clock from probe
  dwc3: exynos: Add provision for suspend clock
  dwc3: exynos: Add provision for AXI UpScaler clock on exynos7
  phy: exynos5-usbdrd: Add pipe-clk, utmi-clk and itp-clk support
  phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
  phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS
  clk: exynos7: Add required clock tree for USB
  arm64: exynos: Add bus1 pinctrl node on exynos7
  arm64: dts: Enable USB 3.0 controller on exynos7
  arm64: dts: exynos7-espresso: Add regulators for Vbus and Vbus-Boost

 .../devicetree/bindings/phy/samsung-phy.txt        |    6 +
 .../devicetree/bindings/usb/exynos-usb.txt         |    6 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   43 +++++++
 arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi    |   26 ++++
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   42 ++++++
 drivers/clk/samsung/clk-exynos7.c                  |   64 +++++++++
 drivers/phy/Kconfig                                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |  136 +++++++++++++++++---
 drivers/pinctrl/samsung/pinctrl-exynos.c           |   12 ++
 drivers/usb/dwc3/dwc3-exynos.c                     |   39 +++++-
 include/dt-bindings/clock/exynos7-clk.h            |    9 +-
 11 files changed, 354 insertions(+), 31 deletions(-)

-- 
1.7.10.4

