Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3J2KOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:14:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40937 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3J2KOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:14:48 -0400
Date: Tue, 29 Oct 2013 11:14:45 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC PATCH 2/5] phy: Add WIP Exynos 5250 support to the Exynos USB
 PHY driver
In-reply-to: <526F8609.5010106@ti.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>
Message-id: <030b01ced48f$b1e17e00$15a47a00$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7UjQIJFAnI9VUgQy6TcjjR9BwhuAAAHn2w
X-AuditID: cbfec7f4-b7f0a6d000007b1b-e6-526f8a97a0e8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xq7rTu/KDDCYtYreYf+Qcq0XblYPs
	Fm+/b2G3uPC0h83ibNMbdotpO/+zWlzeNYfNYsb5fUwWi5a1MlusPXKX3eJs/202i8Nv2lkt
	1s94zeLA67Fz1l12j74tqxg9jt/YzuTxeZNcAEsUl01Kak5mWWqRvl0CV8bU+6vYCqaqVcx/
	cYGtgfGDbBcjJ4eEgInEh7kHWSBsMYkL99azdTFycQgJLGWU+PtzPTOE08AkcathAmMXIwcH
	m4CmxKp7HiANIgJREn/nXmUBqWEW2M8scXjlVCaQhJDAP0aJHS/CQWxOATWJ7Q92sYLYwgIx
	Eo8XvGEEsVkEVCXenfgOtplXwEHi0a1P7BC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMcoOE
	gLrEo7+6EDcYSUzsOcMMUSIicbfhOesERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kREl9fdjAuPmZ1iFGAg1GJh9eCLT9IiDWxrLgy9xCjBAezkghvcyNQ
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pt1B+CXPLPzLlKmqRPeIfyPwsu4nlcceN3Vpu/pFTn
	3nsrMx/fDE8JeJj+78pkNl2XY9Jpbl/zjhe6JVif3XPoffYa8yqv6IhUhZqi1bd/vnp28Qhr
	RFrXu3tmeRI7nim785iFn9XUZxWO/HSm3nbfmj3cs6ZuU3HUD9vbxHdy8eTr91hSriuxFGck
	GmoxFxUnAgDZkZIQjQIAAA==
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-3-git-send-email-k.debski@samsung.com>
 <526A91B9.1060901@ti.com>
 <CAFp+6iF2agMNaNhg=6Xx79erV45V=TobH=+GdziFx8j70g8MDw@mail.gmail.com>
 <526F8609.5010106@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Tuesday, October 29, 2013 10:55 AM
> 
> Hi,
> 
> On Monday 28 October 2013 08:11 PM, Vivek Gautam wrote:
> > Hi Kishon,
> >
> >
> > On Fri, Oct 25, 2013 at 9:13 PM, Kishon Vijay Abraham I
> <kishon@ti.com> wrote:
> >> Hi,
> >>
> >> On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> >>> Add support for Exynos 5250. This is work-in-progress commit. Not
> >>> for merging.
> >>>
> >>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>> ---
> >>>  drivers/phy/Kconfig              |    7 +
> >>>  drivers/phy/Makefile             |    1 +
> >>>  drivers/phy/phy-exynos-usb.c     |   10 +
> >>>  drivers/phy/phy-exynos-usb.h     |    1 +
> >>>  drivers/phy/phy-exynos5250-usb.c |  411
> >>> ++++++++++++++++++++++++++++++++++++++
> >>>  5 files changed, 430 insertions(+)
> >>>  create mode 100644 drivers/phy/phy-exynos5250-usb.c
> >>>
> >>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig index
> >>> 2f7ac0a..0f598d0 100644
> >>> --- a/drivers/phy/Kconfig
> >>> +++ b/drivers/phy/Kconfig
> >>> @@ -36,4 +36,11 @@ config PHY_EXYNOS4212_USB
> >>>       help
> >>>         Enable USB PHY support for Exynos 4212
> >>>
> >>> +config PHY_EXYNOS5250_USB
> >>> +     bool "Support for Exynos 5250"
> >>> +     depends on PHY_EXYNOS_USB
> >>
> >> This should be a separate driver. Not necessary to use
> PHY_EXYNOS_USB.
> >>> +     depends on SOC_EXYNOS5250
> >>> +     help
> >>> +       Enable USB PHY support for Exynos 5250
> >>> +
> >>>  endmenu
> >>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
> >>> ca3dc82..0dff0dd 100644
> >>> --- a/drivers/phy/Makefile
> >>> +++ b/drivers/phy/Makefile
> >>> @@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_PHY)     += phy-core.o
> >>>  obj-$(CONFIG_PHY_EXYNOS_USB)         += phy-exynos-usb.o
> >>>  obj-$(CONFIG_PHY_EXYNOS4210_USB)     += phy-exynos4210-usb.o
> >>>  obj-$(CONFIG_PHY_EXYNOS4212_USB)     += phy-exynos4212-usb.o
> >>> +obj-$(CONFIG_PHY_EXYNOS5250_USB)     += phy-exynos5250-usb.o
> >>> diff --git a/drivers/phy/phy-exynos-usb.c
> >>> b/drivers/phy/phy-exynos-usb.c index d4a26df..172b774 100644
> >>> --- a/drivers/phy/phy-exynos-usb.c
> >>> +++ b/drivers/phy/phy-exynos-usb.c
> >>> @@ -212,6 +212,10 @@ extern const struct uphy_config
> >>> exynos4210_uphy_config;  extern const struct uphy_config
> >>> exynos4212_uphy_config;  #endif
> >>>
> >>> +#ifdef CONFIG_PHY_EXYNOS5250_USB
> >>> +extern const struct uphy_config exynos5250_uphy_config; #endif
> >>> +
> >>>  static const struct of_device_id exynos_uphy_of_match[] =
> {  #ifdef
> >>> CONFIG_PHY_EXYNOS4210_USB
> >>>       {
> >>> @@ -225,6 +229,12 @@ static const struct of_device_id
> exynos_uphy_of_match[] = {
> >>>               .data = &exynos4212_uphy_config,
> >>>       },
> >>>  #endif
> >>> +#ifdef CONFIG_PHY_EXYNOS5250_USB
> >>> +     {
> >>> +             .compatible = "samsung,exynos5250-usbphy",
> >>> +             .data = &exynos5250_uphy_config,
> >>> +     },
> >>> +#endif
> >>>       { },
> >>>  };
> >>>
> >>> diff --git a/drivers/phy/phy-exynos-usb.h
> >>> b/drivers/phy/phy-exynos-usb.h index f45cb3c..a9febfa 100644
> >>> --- a/drivers/phy/phy-exynos-usb.h
> >>> +++ b/drivers/phy/phy-exynos-usb.h
> >>> @@ -42,6 +42,7 @@ enum samsung_cpu_type {
> >>>       TYPE_S3C64XX,
> >>>       TYPE_EXYNOS4210,
> >>>       TYPE_EXYNOS4212,
> >>> +     TYPE_EXYNOS5250,
> >>
> >> No cpu types here.
> >
> > One question here.
> > In case we move to single driver for Exynos4 SoCs (4210, 4212 and
> 4412
> > later) as well as S5PV210,
> > there will be certain things changing from one SoC to another, how
> > should we target that in case we don't have CPU types ?
> > May be i am misinterpreting your suggestion ?
> 
> We should be using the IP revision register or check for compatible
> values.
> 

In case of this driver the compatible is checked. Maybe it is not as
straight forward, but the choice is based on compatible value.
Compatible is matched to an appropriate data entry in the of_device_id
table. The data entry contains a cpu field which contains the information
which PHY version we have. Maybe the "cpu" name is confusing and should be
changed to something like "version" or "revision".

For example:
"samsung,exynos4212-usbphy" compatible is matched to exynos4212_uphy_config
via data field of of_device_id, and the cpu field of exynos4212_uphy_config
is equal to TYPE_EXYNOS4212.
This way in the code all what is needed is to check the value of cpu field.
It already got matched through the compatible.

Still, Tomasz Figa's idea sound good - using a boolean flag
"has_mode_switch".

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

