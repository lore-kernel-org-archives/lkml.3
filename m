Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3AVMzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:55:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21657 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AVMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:55:22 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-c9-50fe8c39df08
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v8 0/4] Adding usb2.0 host-phy support for exynos5250
Date: Tue, 22 Jan 2013 18:30:39 +0530
Message-id: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkWtey51+Awb5ZHBaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZew8+5Wl4IlQxZHPfWwNjG94uxg5OSQETCR+
	tG9ng7DFJC7cWw9kc3EICSxllPh77SgLTNHG++eYIBLTGSWutZ2GqprMJPHlxQ9WkCo2AV2J
	pre7GEFsEQFZicNXfjODFDEL/GWSeLyqnx0kISzgKtE07RIziM0ioCrxrmcBmM0r4C7x/9RL
	Zoh1ChJvbj+Dsk+wSezu94aoF5D4NvkQ0EkcQHFZiU0HoEokJQ6uuMEygVFwASPDKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzAQDv975nUDsaVDRaHGAU4GJV4eC0e/Q0QYk0sK67MPcQo
	wcGsJMKrW/8vQIg3JbGyKrUoP76oNCe1+BBjMtDyicxSosn5wCjIK4k3NDYxNzU2tTQyMjM1
	JU1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2McmW7HsROZqwUMWp6LC9ioy0S8FO0q63j
	U9DOuzEbQqN7Sg5uTbQs2LPf8qEqm1NF6Ly6Ce7/Ar37TRelrLphscMl6s/sd0GPWp9fWy43
	r+6R4lJvYbEru1kLwxYEPbjqKh+x48bVG+xzT8VsTn2ZUa7pZc1r48LjGvv/+dW8n3+/dRa8
	3TNXiaU4I9FQi7moOBEAE2hi+3gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV2Lnn8BBmt2Gltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix8+xX
	loInQhVHPvexNTC+4e1i5OSQEDCR2Hj/HBOELSZx4d56ti5GLg4hgemMEtfaTkM5k5kkvrz4
	wQpSxSagK9H0dhcjiC0iICtx+MpvZpAiZoG/TBKPV/WzgySEBVwlmqZdYgaxWQRUJd71LACz
	eQXcJf6feskMsU5B4s3tZ8wTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO5GdS
	OxhXNlgcYhTgYFTi4bV49DdAiDWxrLgy9xCjBAezkgivbv2/ACHelMTKqtSi/Pii0pzU4kOM
	yUDbJzJLiSbnA6MsryTe0NjE3NTY1NLEwsTMkjRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUwql/prJl1fhvr2eVb9qWZbstb8rxVpovh9LWdDZGm/Kq+u6M1VVr/f/c4tewta1dhIduT
	qU4LUpzW8lr6LUl/MWOCkVj3k8Bl/0q6zvmWvb0cuWLbcplpDZVnxNYWRzY2Xmd7XTX/9eT3
	V9Yule2baNBR/kMyLHEq596Du9SXLN06/d6bH6IqWUosxRmJhlrMRcWJAG7S65eoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v7:
 - Rebased on 'xceive' of Balbi's usb tree.
 - Placing proper Acked By's received for each patch.

Changes from v6:
 - Changing macro names from 'HOST_CTRL0_FSEL_CLKSEL_XX' to 'FSEL_CLKSEL_XX'
   since it's being used by HOST and OTG block to prepare reference clock.
 - Directly Assigning 'FSEL_CLKSEL_XX' to refclk_freq in
   samsung_usbphy_get_refclk_freq() instead of ORing them since we are
   anyways using macros:
        "HOST_CTRL0_FSEL(_x)                    ((_x) << 16)"
        "OTG_SYS_FSEL(_x)                       ((_x) << 4)"

Changes from v5:
 - Adding hostphy enable mask and hostphy register offsets
   to driver data in order to access the HOSTPHY CONTROL register.

 - Adding member 'otg' to struct samsung-usbphy so that its consumers
   can call otg->set_host so as to make 'phy' aware of the consumer type:
        HOST/DEVICE

 - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
   which keeps track of 'otg' of the controllers' phy. This then sets
   the host.

 - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exynos
   to phy driver itself where based on phy_type it is called.

 - Added separate macro definition for USB20PHY_CFG register to select
   between host/device type usb link.

 - Removing unnecessary argument 'phy_type' from samsung_usbphy_set_type()
   and samsung_usbphy_cfg_sel().

 - Addressed few nits:
        -- added macro for 'KHZ'
        -- removing useless 'if' from samsung_usbphy_cfg_sel()
        -- keeping the place of clk_get intact and requesting driver
           data before that.

Vivek Gautam (4):
  ARM: EXYNOS: Update & move usb-phy types to generic include layer
  usb: phy: samsung: Add host phy support to samsung-phy driver
  USB: ehci-s5p: Add phy driver support
  USB: ohci-exynos: Add phy driver support

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
 drivers/usb/host/ehci-s5p.c                        |   81 +++-
 drivers/usb/host/ohci-exynos.c                     |   85 +++-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/samsung-usbphy.c                   |  513 ++++++++++++++++++--
 include/linux/usb/samsung_usb_phy.h                |   16 +
 6 files changed, 636 insertions(+), 73 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

-- 
1.7.6.5

