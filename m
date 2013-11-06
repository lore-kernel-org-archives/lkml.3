Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3KFM64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:58:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61351 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3KFM6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:58:53 -0500
Date: Wed, 06 Nov 2013 13:58:45 +0100
From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <527A3B1C.50200@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Message-id: <2413995.ezl3Ca2YTh@amdc1227>
Organization: Samsung Poland R&D Center
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7Bit
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fb-527a3d0abcab
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xy7pctlVBBvuWGlss2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDbvFtJ3/WS0u75rDZjHj/D4mi0XLWpkt
	1h65y25xtv82m8X5LZ1MFofftLNadJw9yO4g6HG5r5fJY+esu+wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujB9fH7MXvJavWHD2PXMD4wGJLkYODgkBE4muFQJdjJxAppjEhXvr
	2boYuTiEBJYySszoeMQO4XQxSZy7vpwFpIpNQE3ic8MjNhBbREBL4vTOH8wgRcwCO5klenu6
	mUESwgJ2Eo/OH2AEsVkEVCW2zrkA1sAroCnR8eQFWA2/gLrEu21PmUBsUQE3iek/DoLFOQVU
	JFpe7gNbJiRQI3H2/mVmiF5BiR+T74HFmQXkJfbtn8oKYWtJrN95nGkCo+AsJGWzkJTNQlK2
	gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIjH3Zwbj4mNUhRgEORiUe3gT5yiAh1sSy
	4srcQ4wSHMxKIrxWBlVBQrwpiZVVqUX58UWlOanFhxiZODilGhgbKt+evdO4vaakxKLOYV3G
	vqu/JXdkLrx5VNeRLS2Pna3qPtvqrqzaXcZfpn5gYJ96PKA2L8xz3XWmN29iZhfaB/xc/S76
	ptKS/nd5a65fPJxdel7ntYTCG+mNjgZdU36d9cj64CS8d3fIaatt3xboZR6XCulaNU+9b7+I
	0yUWtXVHN1Ulr5BSYinOSDTUYi4qTgQAa8RpMo8CAAA=
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <2656549.jVSier62Qi@amdc1227> <527A3B1C.50200@ti.com>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 of November 2013 18:20:36 Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 06 November 2013 05:08 PM, Tomasz Figa wrote:
> > Hi Kishon
> >
> > On Wednesday 06 of November 2013 13:48:13 Kishon Vijay Abraham I wrote:
> >> Hi,
> >>
> >> On Tuesday 05 November 2013 09:43 PM, Kamil Debski wrote:
> >>> Add a new driver for the Exynos USB PHY. The new driver uses the generic
> >>> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> >>> SoC families.
> >>>
> >>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>> ---
> >>>    .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
> >>>    drivers/phy/Kconfig                                |   23 +-
> >>>    drivers/phy/Makefile                               |    4 +
> >>>    drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
> >>>    drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
> >>>    drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
> >>>    drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
> >>>    7 files changed, 995 insertions(+), 1 deletion(-)
> >>>    create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> >>>    create mode 100644 drivers/phy/phy-exynos-usb2.c
> >>>    create mode 100644 drivers/phy/phy-exynos-usb2.h
> >>>    create mode 100644 drivers/phy/phy-exynos4210-usb2.c
> >>>    create mode 100644 drivers/phy/phy-exynos4212-usb2.c
> > [snip]
> >>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> >>> index a344f3d..bdf0fab 100644
> >>> --- a/drivers/phy/Kconfig
> >>> +++ b/drivers/phy/Kconfig
> > [snip]
> >>> @@ -51,4 +51,25 @@ config PHY_EXYNOS_DP_VIDEO
> >>>    	help
> >>>    	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
> >>>
> >>> +config PHY_EXYNOS_USB2
> >>> +	tristate "Samsung USB 2.0 PHY driver"
> >>> +	help
> >>> +	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
> >>> +	  This driver provides common interface to interact, for Samsung
> >>> +	  USB 2.0 PHY driver.
> >>
> >> I still think we can get rid of this helper driver and have a single
> >> driver for both PHY_EXYNOS4210_USB2 and PHY_EXYNOS4212_USB2.
> >
> > This helper driver is a really nice way to avoid code duplication, while
> > still leaving the code clean and readable.
> >
> > All the Samsung USB 2.0 PHYs require exactly the same semantics
> > (isolation, reference rate configuration, power up, power on), but each
> > one has completely different layout of registers and bits inside
> > registers.
> 
> I just did a diff of registers in exynos 4210 and 4212 PHY drivers [1] 
> and couldn't find that big a difference in register layout. Of course 
> there are a few changes in HSIC bit fields and PHYFSEL but that's only 
> minimal and could well be handled in a single driver.
> 
> [1] -> http://diffchecker.com/py3tp68m

This is quite a lot of differences, especially including shifted
bitfields... In addition there is another set of available PHYs
and inter-dependencies between them.

> >
> > Making a big single driver would end up being identical to the old Exynos
> > USB2PHY driver with a lot of if and switch statements inside most of
> > functions, which is not only ugly but makes any further extension hard.
> 
> Probably we shouldn't try to over design and just convert the old exynos 
> usb2 phy driver to the generic phy framework to begin with?

The old exynos USB2 PHY driver is incomplete and has very limited
functionality. It needs a complete redesign to support remaining features
and this is the reason we decided to develop a new driver from scratch.

I believe the way Kamil's driver is designed is definitely the way to go
with Samsung's USB2 PHY drivers, especially considering that support for
more SoCs using the same framework will be added - S3C64xx, S5PV210,
and Exynos5250.

Best regards.
Tomasz

