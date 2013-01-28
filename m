Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3A1Lgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:36:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58324 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3A1Lgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:36:38 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-1f-510662c4742e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Subject: [PATCH 0/4] usb: dwc3/xhci: Enable runtime power management
Date: Mon, 28 Jan 2013 17:12:24 +0530
Message-id: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWyRsSkRvdIElugwZ8WXYvLu+awWcxe0s9i
	MeP8PiaLRctamR1YPD5vkgtgjOKySUnNySxLLdK3S+DK6GncwVZwnafiy7kTbA2Mc7i6GDk5
	JARMJFYuW80KYYtJXLi3nq2LkYtDSGApo0TDqgamLkYOsKJjF30g4osYJQ7/XMIM0iAkMJlJ
	4tAedRCbTUBXountLkYQW0RAVuLwld/MIA3MAhOZJHoWgQzi5BAWcJFYsHwPG4jNIqAq8fTg
	b7A4r4CHxJT2I+wQVyhIvLn9DKxZQuA6m8S9U59YIRoEJL5NPsQCcZGsxKYDzBD1khIHV9xg
	mcAouICRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGYMCd/vdMegfjqgaLQ4wCHIxKPLw/
	0lgChVgTy4orcw8xSnAwK4nwCsSwBQrxpiRWVqUW5ccXleakFh9iTAZaPpFZSjQ5HxgNeSXx
	hsYm5qbGppZGRmampqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBMUxZZp7IiVexwglP
	e4XfT2mZ/OvMSk2P3c3tF3994rjCq+nVc95p/Yk9Hl4LPx2YEjbTwXLKafv7B5f11WywVv2h
	tGiC7xPH9MpEu3NfZD5L5bok/K5hPcJxyPPoXOkbSg9ErnBtnFeSpqW+OoavULci/+RPVZsZ
	3evW6bmd3dLbdbxssRbbeiWW4oxEQy3mouJEALerJ2d8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd0jSWyBBrd3KFlc3jWHzWL2kn4W
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y0ZP4w62gus8FV/OnWBrYJzD1cXIwSEhYCJx7KJPFyMnkCkmceHeerYuRi4OIYFFjBKHfy5h
	BkkICUxmkji0Rx3EZhPQlWh6u4sRxBYRkJU4fOU3M0gDs8BEJomeRQ1MIAlhAReJBcv3sIHY
	LAKqEk8P/gaL8wp4SExpP8IOsU1B4s3tZ8wTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAgO52fSOxhXNVgcYhTgYFTi4f2RxhIoxJpYVlyZe4hRgoNZSYRXIIYtUIg3JbGyKrUo
	P76oNCe1+BBjMtD2icxSosn5wFjLK4k3NDYxNzU2tTSxMDGzJE1YSZyX8dSTACGB9MSS1OzU
	1ILUIpgtTBycUg2Ms5q5/RP/cz0+HaKVUvJJZndXlXtMaPBEBSbDl2c/BtW85eo/ljTVsoVD
	O/fpJ0tj/tcWCdX/3pfMW6M5OXzF0f8TI+YdP7OC/2fsDq17K/9OsOb9GjoxzWa6P09RjV4J
	h9cH5YXOWgkXZsgvK+q6Mqm6+p0aj0PaL0a725qN88w2GZ747iqmxFKckWioxVxUnAgAj/7H
	IqsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-series enables runtime power management on xhci-plat,
dwc3-core, dwc3-exynos as well as on samsung-usb3 type PHY.
This allows usb 3.0 host ports to be power managed at runtime.
We also turn off the PHY ref_clk PLL, which supplies reference clock
to USB3 type phy, when ports are not in use.

This patch-series is based on 'usb-next' with follwing patches:

usb: phy: samsung: Introducing usb phy driver for hsotg
usb: phy: s3c-hsotg: adding phy driver support

usb: phy: samsung: Add support to set pmu isolation
ARM: EXYNOS: Update & move usb-phy types to generic include layer
usb: phy: samsung: Add host phy support to samsung-phy driver
USB: ehci-s5p: Add phy driver support
USB: ohci-exynos: Add phy driver support
usb: phy: samsung: Remove __devinit, __devexit_p and __exit annotations

[PATCH v4 1/2] usb: phy: samsung: Common out the generic stuff
[PATCH v4 2/2] usb: phy: samsung: Add PHY support for USB 3.0 controller

Vivek Gautam (4):
  usb: xhci: Enable runtime pm in xhci-plat
  USB: dwc3: Adjust runtime pm the dwc3 driver to allow runtime suspend
  usb: dwc3: exynos: Enable runtime power management
  usb: phy: samsung: Enable runtime power management on samsung-usb3

 drivers/usb/dwc3/core.c          |    4 +-
 drivers/usb/dwc3/dwc3-exynos.c   |   47 +++++++++++++++++
 drivers/usb/host/xhci-plat.c     |    9 +++
 drivers/usb/phy/samsung-usb3.c   |  107 +++++++++++++++++++++++++++++++++++--
 drivers/usb/phy/samsung-usbphy.c |   26 +++++++++
 drivers/usb/phy/samsung-usbphy.h |    1 +
 6 files changed, 187 insertions(+), 7 deletions(-)

-- 
1.7.6.5

