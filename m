Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3BEMii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:38:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3BEMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:38:35 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-01-5110fd490fd9
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v5 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Tue, 05 Feb 2013 18:14:14 +0530
Message-id: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkStfrr0CgwdRCi8u75rBZzDi/j8li
	0bJWZgdmj8+b5AIYo7hsUlJzMstSi/TtErgy7s8RLnjOWdH8eQFbA+Mf9i5GTg4JAROJtlV7
	2SBsMYkL99YD2VwcQgJLGSVutm9khSl6vXISE0RiEaPE3893WEASQgKTmSROdAaA2GwCuhJN
	b3cxgtgiArISh6/8ZgZpYBZ4xCTxZd9zsAZhAVeJC+9egtksAqoSPX0PgNZxcPAKeEhMWJQL
	sUxB4s3tZ2C9EgJn2CQ+Tj/BBFEvIPFt8iEWkHoJoAWbDjBD1EtKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGIEhdvrfM+kdjKsaLA4xCnAwKvHw/rjMHyjEmlhWXJl7
	iFGCg1lJhLf6i0CgEG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OB4Z9XEm9obGJuamxqaWRk
	ZmpKmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhgbp7RYS9oe8Qr8Udt0v2a5viCfhs8O
	q5t6B8tkWde4HRMV4XvyaYPu9Nb257MYI12f6unXP2fYtupOs3ma862zZ4ty7S4vETindfHE
	4+Tta/3U5CzWLqz09bomdyfhzRX5p8YN7Gv+Vtrd3Zq47NuGUpm5Zse3nb6reZPr/buJlrbV
	kfO1J5QqsRRnJBpqMRcVJwIAFO6OP3UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV3PvwKBBmtf6lpc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxf45w
	wXPOiubPC9gaGP+wdzFyckgImEi8XjmJCcIWk7hwbz1bFyMXh5DAIkaJv5/vsIAkhAQmM0mc
	6AwAsdkEdCWa3u5iBLFFBGQlDl/5zQzSwCzwiEniy77nYA3CAq4SF969BLNZBFQlevoeAE3l
	4OAV8JCYsCgXYpmCxJvbz5gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcws+k
	dzCuarA4xCjAwajEw/vjMn+gEGtiWXFl7iFGCQ5mJRHe6i8CgUK8KYmVValF+fFFpTmpxYcY
	k4GWT2SWEk3OB8ZXXkm8obGJuamxqaWJhYmZJWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLg
	lGpgNPjHL9R0/d7ZnliF0uJfaxJKdPeqpDZ9sTYUUG1evoSTdecqG03zDw81DHfGv2UU9tk9
	WdlT94DWDL1Jk/ZdOfr/9U0dcbGrVwK5VlcduOv9urc1/dTpDq8dbRvyLtwr2LmP99XPnP87
	/h8NVws/ZpT67/lqrTP5LjOX3/f97fh10YLtT7NbDyixFGckGmoxFxUnAgDQUd8npQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'usb-next'

Changes from v4:
 - Modifying function names and driver names to follow a common
   naming convention.
        "usb2phy" for samsung-usb2phy driver
        "usb3phy" for samsung-usb3phy driver
 - Changing file names "samsung-usb2.c" to "samsung-usb2phy.c" and,
   "samsung-usb3.c" to "samsung-usb3phy.c"
 - Removing dependencies for SAMSUNG_USB2PHY and SAMSUNG_USB3PHY.
 - Arranging SAMSUNG_USB2PHY and SAMSUNG_USB3PHY to select SAMSUNG_USBPHY,
   which is the usb-phy helper driver.

Vivek Gautam (2):
  usb: phy: samsung: Common out the generic stuff
  usb: phy: samsung: Add PHY support for USB 3.0 controller

 drivers/usb/phy/Kconfig           |   25 +-
 drivers/usb/phy/Makefile          |    2 +
 drivers/usb/phy/samsung-usb2phy.c |  511 ++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.c  |  717 +------------------------------------
 drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
 6 files changed, 1219 insertions(+), 713 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb2phy.c
 create mode 100644 drivers/usb/phy/samsung-usb3phy.c
 create mode 100644 drivers/usb/phy/samsung-usbphy.h

-- 
1.7.6.5

