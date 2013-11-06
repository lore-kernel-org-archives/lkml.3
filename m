Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3KFK44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:56:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27340 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3KFK4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:56:53 -0500
Date: Wed, 06 Nov 2013 11:56:48 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <000c01ceda8b$e54dbef0$afe93cd0$%han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, galak@codeaurora.org
Message-id: <000001cedade$e534a2f0$af9de8d0$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7aQivtGZKQYr/tTv+ZofY7RDqK4QAR9naQABUf8oA=
X-AuditID: cbfec7f5-b7ef66d00000795a-20-527a20722483
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xa7pFClVBBjfX6Vgs2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosLT3vYLM42vWG3mLbzP6vF5V1z2CxmnN/HZLFoWSuzxdojd9kt
	zvbfZrM4v6WTyeLwm3ZWi/UzXrNYdJw9yO4g6HG5r5fJY+esu+wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujNtfawveC1Vc+zaXtYFxF18XIyeHhICJRO+6hWwQtpjEhXvrgWwu
	DiGBpYwSZw9MYYJwGpgkPvw4BORwcLAJaEqsuucB0iAioCbRvPwMC0gNs8ACZoltHd1Q3ZsZ
	Je5MXwPWwClgJ9E9VRikQRjInHL7AiuIzSKgKvH19VewzbwCDhIvJ9+EsgUlfky+xwJiMwto
	SazfeZwJwpaX2LzmLTPISAkBdYlHf3UhbrCSOLhwAyNEiYjE3YbnrBMYhWYhmTQLyaRZSCbN
	QtKygJFlFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIPH7dwbj0mNUhRgEORiUe3gT5yiAh
	1sSy4srcQ4wSHMxKIrxrZKqChHhTEiurUovy44tKc1KLDzEycXBKNTDKH+fe2vd1y6t5LNvl
	53vfW/Dp5W5O5bPrjzqazJn6df60sEVnrDziFZaWRt594bNhiqE240JRl0y/RUVV3hUJ3/kl
	FH8cNZn80S5DquyzXXSKuPDrRCWmk9/LTW+VNU987H/l6NayiYxfvU7YHVe7GX/sXurXHe+6
	hTx++IY5HctOX7YmwIpXiaU4I9FQi7moOBEA+a03jaUCAAA=
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <1383668001-19141-2-git-send-email-k.debski@samsung.com>
 <000c01ceda8b$e54dbef0$afe93cd0$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Wednesday, November 06, 2013 2:03 AM
> 
> On Wednesday, November 06, 2013 1:13 AM, Kamil Debski wrote:
> >
> > Add a new driver for the Exynos USB PHY. The new driver uses the
> > generic PHY framework. The driver includes support for the Exynos
> 4x10
> > and 4x12 SoC families.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
> >  drivers/phy/Kconfig                                |   23 +-
> >  drivers/phy/Makefile                               |    4 +
> >  drivers/phy/phy-exynos-usb2.c                      |  234
> ++++++++++++++
> >  drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
> >  drivers/phy/phy-exynos4210-usb2.c                  |  272
> ++++++++++++++++
> >  drivers/phy/phy-exynos4212-usb2.c                  |  324
> ++++++++++++++++++++
> >  7 files changed, 995 insertions(+), 1 deletion(-)  create mode
> 100644
> > Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> >  create mode 100644 drivers/phy/phy-exynos-usb2.c  create mode 100644
> > drivers/phy/phy-exynos-usb2.h  create mode 100644
> > drivers/phy/phy-exynos4210-usb2.c  create mode 100644
> > drivers/phy/phy-exynos4212-usb2.c
> 
> [....]
> 
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
> > d0caae9..c87bc65 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -7,3 +7,7 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-
> video.o
> >  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> >  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> >  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> > +obj-$(CONFIG_PHY_EXYNOS5250_USB)	+= phy-exynos5250-usb.o
> 
> Hi Kamil,
> 
> Would you add 'phy-exynos5250-usb.c' file? :-)
> 
> Now, I am testing Exynos5250 USB HOST with your patchset.
> However, it makes error because there is no PHY driver for Exynos5250.
> 
>   WARNING: CPU: 0 PID: 18 at drivers/phy/phy-core.c:366
> phy_get+0x1e8/0x224()
>   Device: exynos-ehci
>   missing string
>   .....

I have to rewrite the power_on/power_off function in Exynos 5250 and I will
include it in the next version.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


