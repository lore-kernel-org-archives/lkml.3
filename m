Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab3B0OqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:46:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8246 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935Ab3B0OqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:46:00 -0500
X-AuditID: cbfee690-b7f6b6d000004563-37-512e1c27625b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, dianders@chromium.org,
        p.paneri@samsung.com
Subject: [PATCH v6 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Wed, 27 Feb 2013 20:13:47 +0530
Message-id: <1361976229-16024-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkRlddRi/Q4HiXiMXB+/UWB2Y/ZLU4
	u+wgm0Xz4vVsFr0LrrJZXN41h81ixvl9TBaLlrUyW5zf0snkwOkxu+Eii8f+uWvYPc7PWMjo
	0bdlFaPH8RvbmTw+b5ILYIvisklJzcksSy3St0vgymhf28Bc0MZRsXbbW/YGxiNsXYycHBIC
	JhLbHh6CssUkLtxbD2RzcQgJLGWUePf/BHMXIwdY0e4b2hDx6YwSC38+ZoRwpjBJXLy9hB2k
	m01AV6Lp7S5GEFtEQFbi8JXfzCBFzAK3GCXuND9hBUkIC7hKXG+/ALaORUBVYuLh90wgNq+A
	h8Sq+bdYIM5QkHhz+xlYs4TAPHaJFc/+MEE0CEh8m3yIBeIkWYlNB5gh6iUlDq64wTKBUXAB
	I8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCgPv3v2YQdjPcOWB9iTAYaN5FZSjQ5HxgV
	eSXxhsYm5qbGpmZGlpaWpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqPKX
	WUBJSiwnpfHsM49tEgsyjk09mPch5aba9ZYbK6Y9WXb+pcwMj31b1Lye2ZiFv86beHmHe/m9
	FlbuvrxpB+yUUlO+vut683x1UfTf7coyHEFvM9gyrCRfMx9dHMNwe1uY7ku/5fbrDd73dyns
	nVbf1PPGZVfU++imX2Gnjz542Fi9KCJ0vxJLcUaioRZzUXEiAJ9k1oeAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQV11Gb1Ag5fzuSwO3q+3ODD7IavF
	2WUH2SyaF69ns+hdcJXN4vKuOWwWM87vY7JYtKyV2eL8lk4mB06P2Q0XWTz2z13D7nF+xkJG
	j74tqxg9jt/YzuTxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	9rUNzAVtHBVrt71lb2A8wtbFyMEhIWAisfuGdhcjJ5ApJnHh3nqgMBeHkMB0RomFPx8zQjhT
	mCQu3l7CDlLFJqAr0fR2FyOILSIgK3H4ym9mkCJmgVuMEnean7CCJIQFXCWut19gA7FZBFQl
	Jh5+zwRi8wp4SKyaf4sFYp2CxJvbz5gnMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcM8+kdjCubLA4xCjAwajEw7vgkk6gEGtiWXFl7iFGCQ5mJRFe2/O6gUK8KYmVValF+fFF
	pTmpxYcYk4G2T2SWEk3OB8ZzXkm8obGJuamxqaWJhYmZJWnCSuK8jKeeBAgJpCeWpGanphak
	FsFsYeLglGpg3J2wq8yt5QhDr+/9xZVXDNc8PdZkcvcaR/a8aRo9vbqzCntPX1Cfo/mq+ePF
	HxHHJ3duSGK/LC/XtCx60o8gg9+Lfh6NeGV2Sub9ObWl3Sklt+r/ij2xnyV81d16UfC9MA5h
	DvaCZdOvTVf6P31u9ZeU6VlhjP99CrOk6967mZ/94+n4ivlnjBJLcUaioRZzUXEiAGl/or/d	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'usb-next'

Changes from v5:
 - Squashed the following change from Felipe in this patch-set:
   [PATCH] usb: phy: samsung: let it be built as a module
 - Using EXPORT_SYMBOL_GPL() to export symbols in "samsung-usbphy.c"
   to allow module builds of these samsung PHY drivers.

Vivek Gautam (2):
  usb: phy: samsung: Common out the generic stuff
  usb: phy: samsung: Add PHY support for USB 3.0 controller

 drivers/usb/phy/Kconfig           |   25 +-
 drivers/usb/phy/Makefile          |    2 +
 drivers/usb/phy/samsung-usb2phy.c |  511 ++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.c  |  722 +------------------------------------
 drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
 6 files changed, 1224 insertions(+), 713 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb2phy.c
 create mode 100644 drivers/usb/phy/samsung-usb3phy.c
 create mode 100644 drivers/usb/phy/samsung-usbphy.h

-- 
1.7.6.5

