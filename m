Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3CBNZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3CBNZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:18 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-e0-5131fdbc41c0
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 00/10] usb: dwc3/xhci/phy: Enable runtime power management
Date: Sat, 02 Mar 2013 18:53:01 +0530
Message-id: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkWnfPX8NAg6a/qhYH79dbNC9ez2bR
	u+Aqm8WFpz1sFpd3zWGzmL2kn8Vixvl9TBaLlrUyWzSfOMXswOkx72Sgx/65a9g9+rasYvQ4
	fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGa2LjzIW9ApWvDu8mr2B8TlvFyMnh4SAicT1m19Z
	IGwxiQv31rN1MXJxCAksZZRYPP0JO0zRg6XNzBCJ6YwSm2d+ZoJwpjBJrDl3jxGkik1AV6Lp
	7S4wW0RAVuLwld9gHcwClxglVqzYArSDg0NYwFfi8apakBoWAVWJvpMLwDbwCnhIXJvTxQax
	TUHize1nYL0SApPZJf68O80K0SAg8W3yIbA5EkALNh1ghqiXlDi44gbLBEbBBYwMqxhFUwuS
	C4qT0ouM9IoTc4tL89L1kvNzNzECA/n0v2d9OxhvHrA+xJgMNG4is5Rocj4wEvJK4g2NTcxN
	jU3NjCwtLU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVExeu1+J7V9f/wO
	zJ5j6fGYb2H2fFaL+7yP7z+93tNeL3m4ZofqftHPTdaq3VWpHF8Z1Guk7qf+e3rua8g0oWyu
	ynteUemf1VqNeXdmPNr3y2I2m+Gu65kZD46aNDt8fF7+umFTdtwJ/nuS15fHXy8+Hetq892g
	Y1WuxjyXrRqdiZ4dKe7tOUosxRmJhlrMRcWJAJfafgN6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jQd09fw0DDXYtk7E4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRuvgoY0Gv
	YMW7w6vZGxif83YxcnJICJhIPFjazAxhi0lcuLeerYuRi0NIYDqjxOaZn5kgnClMEmvO3WME
	qWIT0JVoersLzBYRkJU4fOU3M0gRs8AlRokVK7awdDFycAgL+Eo8XlULUsMioCrRd3IBO4jN
	K+AhcW1OFxvENgWJN7efMU9g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhOnknv
	YFzVYHGIUYCDUYmHN+CjQaAQa2JZcWXuIUYJDmYlEd7zVw0DhXhTEiurUovy44tKc1KLDzEm
	A22fyCwlmpwPjOG8knhDYxNzU2NTSxMLEzNL0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp
	1cAok7Smb1Hsi9zPj8rTS2o2vgh7euqaqOOdzLkMKfGNJYvviWjOkNm+V3dVf1CtfX/H6X85
	MxJWGTH3HElNdXS68V9JxeXYT50JU1f8zThosZ93gUC4UvH0iUkH6n3VpBZLPu0J4m2cIjbf
	8Eq1fNxK0zodb82c/+WTe5Y0zipe1fA72FRAUluJpTgj0VCLuag4EQDyTa2P1wIAAA==
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

Based on 'usb-next' alongwith following patch series:
  [PATCH v4 00/11] usb: dwc3: PM support patchset
  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg14676.html

  [PATCH v2] usb: xhci: add the suspend/resume functionality
  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg14614.html

  [PATCH v6 0/2] Adding USB 3.0 DRD-phy support for exynos5250
  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg15813.html

Changes from v1:
 - Adding required PHY APIs to handle runtime power management
   instead of directly twiddling with phy->dev.
 - Handling runtime power management of usb PHYs in dwc3 core
   driver instead of in any glue layer.
 - Splitting the patch "[PATCH 4/4] usb: phy: samsung: Enable runtime power management on samsung-usb"
   to required number to bifurcate functionality.

Vivek Gautam (10):
  usb: phy: Add APIs for runtime power management
  USB: dwc3: Adjust runtime pm to allow autosuspend
  usb: dwc3: Enable runtime pm only after PHYs are initialized
  usb: dwc3: Add runtime power management callbacks
  usb: dwc3: exynos: Enable runtime power management
  usb: xhci: Enable runtime pm in xhci-plat
  usb: phy: samsung: Enable runtime power management on usb3phy
  usb: phy: samsung: Add support for external reference clock
  usb: phy: samsung: Add support for PHY ref_clk gpio
  usb: phy: samsung: Add support for PHY refclk switching

 drivers/usb/dwc3/core.c           |   40 +++++++++++--
 drivers/usb/dwc3/dwc3-exynos.c    |   13 ++++
 drivers/usb/host/xhci-plat.c      |    7 ++
 drivers/usb/phy/samsung-usb3phy.c |  122 +++++++++++++++++++++++++++++++++++--
 drivers/usb/phy/samsung-usbphy.c  |   26 ++++++++
 drivers/usb/phy/samsung-usbphy.h  |    1 +
 include/linux/usb/phy.h           |   26 ++++++++
 7 files changed, 224 insertions(+), 11 deletions(-)

-- 
1.7.6.5

