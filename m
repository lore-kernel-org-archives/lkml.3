Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3ANMyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:54:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8838 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3ANMyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:54:03 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d1-50f3ffe9c755
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        av.tikhomirov@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Mon, 14 Jan 2013 18:29:35 +0530
Message-id: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkRvfl/88BBoc/6ltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlTH371XGgiaBinvbrzM3MH7i6WLk5JAQMJFo
	/vKXFcIWk7hwbz1bFyMXh5DAUkaJq+9bWGGKTu89xwiRWMQo0fjmPAuEM5lJYs3ZFkaQKjYB
	XYmmt7vAbBEBWYnDV34zgxQxC2xiktj2r4UdJCEs4Crx7U8fmM0ioCrRd/c3G4jNK+AhcX3u
	S3aIdQoSb24/Y4aoEZD4NvkQ0DYOoLisxKYDYDMlBI6wSSyd/oYFol5S4uCKGywTGAUXMDKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgMtdP/nkntYFzZYHGIUYCDUYmHd1LE5wAh1sSy
	4srcQ4wSHMxKIrxxr4FCvCmJlVWpRfnxRaU5qcWHGH2ALpnILCWanA+Mg7ySeENjE3NTY1NL
	IyMzU1McwkrivIynngQICaQnlqRmp6YWpBbBjGPi4JRqYCyOqTDduP2lkubGDZ17O1W8/l/k
	4o3dwqjGK1r68dHUXc2v+3M2B71evMba/talG4krdZc86i3YKdgakMeSNe//jGfquxWy3t16
	eWH9k49/mav++Vg/SznoLtM6KV/h6kP1io2/TAM/t9yaPytF/6Kpn8jlnz9YE8QWuhzdeJZr
	MedbKd/VGsFKLMUZiYZazEXFiQArUb/sYgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd2X/z8HGLw8pGhxedccNosZ5/cx
	WSxa1srswOzxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG3L9X
	GQuaBCrubb/O3MD4iaeLkZNDQsBE4vTec4wQtpjEhXvr2boYuTiEBBYxSjS+Oc8C4Uxmklhz
	tgWsik1AV6Lp7S4wW0RAVuLwld/MIEXMApuYJLb9a2EHSQgLuEp8+9MHZrMIqEr03f3NBmLz
	CnhIXJ/7kh1inYLEm9vPmCcwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzIz6R2
	MK5ssDjEKMDBqMTDOynic4AQa2JZcWXuIUYJDmYlEd6410Ah3pTEyqrUovz4otKc1OJDjD5A
	2ycyS4km5wOjLK8k3tDYxNzU2NTSxMLEzBKHsJI4L+OpJwFCAumJJanZqakFqUUw45g4OKUa
	GGe7zw9ceHX/fj+mEhblI5e0Yxb7XuJ/fuv8rHPPAwv3KHLJ37rKbmpS4HVQhJ1ZcbmXtmvI
	bqG4b7GcnYfXr1Rzabr8cv3lGZ2qqTEu17yavaU05SetvajHNTW1MeRbV6Hc0Y+qsxacZzI/
	cWi5m3RPykyd5gj7utlJ2+ZfSJYp3M3bdNKhVomlOCPRUIu5qDgRAGj4G3iRAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:
 - Renaming 'samsung-usbphy.c' driver to 'samsung-usb2.c' indicating
   usb 2.0 phy controller's driver for Samsung's SoCs.
 - Moving the register definitions and strcuture definitions to
   common header file 'samsung-usbphy.h' to be used across
   usb 2.0 and usb 3.0 phy.
 - Keeping common exported function definitions in samsung-usbphy.c
   which can be used across usb 2.0 and usb 3.0 phy.
 - Writting separate driver file for Samsung's USB 3.0 phy controller.
   and making it dependent on USB_DWC3.

Rebased on top of usb-next followed by following patches/patch-threads:
	-- [PATCH v9 1/2] usb: phy: samsung: Introducing usb phy driver for hsotg
	-- [PATCH] usb: phy: samsung: Add support to set pmu isolation (version 6)
	-- [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250

Changes form v1:
 - Moved architecture related patch out of this patch-set.
 - Replaced unnecessary multi-line macro definitions by
   single line definitions.
 - Creating new data structure for USB 3.0 phy type and embedding
   it in 'samsung_usbphy' structure.
 - Adding a flag in 'samsung_usbphy' structure to check if device
   has usb 3.0 type phy or not.
 - Restructuring probe sequence for USB 3.0 phy, such that we are
   initializing only when device has usb3.0 type phy.

Vivek Gautam (2):
  usb: phy: samsung: Common out the generic stuff
  usb: phy: samsung: Add PHY support for USB 3.0 controller

 drivers/usb/phy/Kconfig          |    8 +
 drivers/usb/phy/Makefile         |    3 +-
 drivers/usb/phy/samsung-usb2.c   |  511 +++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usb3.c   |  349 +++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.c |  713 +-------------------------------------
 drivers/usb/phy/samsung-usbphy.h |  328 +++++++++++++++++
 6 files changed, 1205 insertions(+), 707 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb2.c
 create mode 100644 drivers/usb/phy/samsung-usb3.c
 create mode 100644 drivers/usb/phy/samsung-usbphy.h

-- 
1.7.6.5

