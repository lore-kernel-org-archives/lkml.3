Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJFJEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:04:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30871 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJFJEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:04:01 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-be-54325afeccfb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, b29396@freescale.com,
        boris.brezillon@free-electrons.com,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'VIKAS SAJJAN C'" <vikas.sajjan@samsung.com>, naushad@samsung.com,
        "'Thomas P Abraham'" <thomas.ab@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, "'Stephen Warren'" <swarren@nvidia.com>,
        "'Doug Anderson'" <dianders@chromium.org>
References: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
 <CAD=FV=VYc+5qwZ==vTgXkXzbX1wALRpqsaTe8LR-N00nKiyycQ@mail.gmail.com>
In-reply-to: <CAD=FV=VYc+5qwZ==vTgXkXzbX1wALRpqsaTe8LR-N00nKiyycQ@mail.gmail.com>
Subject: RE: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Mon, 06 Oct 2014 14:32:54 +0530
Message-id: <004101cfe144$5aa3e570$0febb050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDZRVlgp8/5Ih7zB/yalgUesapzCwIFgLtNnf+5T+A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWyRsSkTvdflFGIwY5tvBZ/Jx1jt3i4s5/F
	4sCLhSwWZ5cdZLOYO3sSo0XvgqtsFve/HmW06LzQwWqx6fE1VovLu+awWcw4v4/J4vZlXotP
	R/+zWtyY3sJq0bGM0WLVrj+MFjefbWdyEPRoae5h8/j9axKjx+yGiyweTzZdZPT4d7ifyWPi
	WV2PnbPusnvcubaHzWPzknqP3uZ3bB59W1YxenzeJBfAE8Vlk5Kak1mWWqRvl8CVsXbXTraC
	Rs2Kr//XsDUwnlXoYuTgkBAwkVh1jb2LkRPIFJO4cG89WxcjF4eQwFJGiWV/j7JCJEwknrSv
	Y4ZILGKU6Pjcyg7h/GWUOLT6DiNIFZuArsST93OZQWwRATWJm3tmMYEUMQtcZJF4s/0OE0RH
	P6PEtCc7wTo4BYIleq7/BusQFgiTuL76PgvITSwCqhIHJoSAhHkFLCWWfTrCCmELSvyYfI8F
	xGYWUJeYNG8RM4StLfHk3QWoUxUkdpx9zQhxhJXEsheNjBA14hKTHjwEu1pC4AmHxJ7O52AJ
	FgEBiW+TD7FAwkJWYtMBZog5khIHV9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCel
	F5noFSfmFpfmpesl5+duYgSmmNP/nk3YwXjvgPUhRgEORiUe3sgdhiFCrIllxZW5hxhNgS6a
	yCwlmpwPTGR5JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLg
	lGpg9C5aMOlg1C0DKSPt3Qw6cTO8O7ZPUlo3e2fuofymQ/uEXGKVr6/Olyn+zvluBvu2jRMf
	HSjvtZKx/iie3sCvYskfmC84gcOrT2OfsfnfKW/FkqccUDfQvedx7VygbXVL4arYw+euWlWq
	3ilbYnxk6ZfzjRI9oqfWfLkm4G4aWnru3dUJbxZcUmIpzkg01GIuKk4EACMg6FEsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd1/UUYhBkv3Mln8nXSM3eLhzn4W
	iwMvFrJYnF12kM1i7uxJjBa9C66yWdz/epTRovNCB6vFpsfXWC0u75rDZjHj/D4mi9uXeS0+
	Hf3PanFjegurRccyRotVu/4wWtx8tp3JQdCjpbmHzeP3r0mMHrMbLrJ4PNl0kdHj3+F+Jo+J
	Z3U9ds66y+5x59oeNo/NS+o9epvfsXn0bVnF6PF5k1wAT1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GNKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMIaxoy1u3ayFTRqVnz9v4atgfGsQhcjJ4eEgInEk/Z1zBC2mMSFe+vZ
	uhi5OIQEFjFKdHxuZYdw/jJKHFp9hxGkik1AV+LJ+7lgHSICahI398xiAiliFrjIIvFm+x0m
	iI5+RolpT3aCdXAKBEv0XP8N1iEsECZxffV9li5GDg4WAVWJAxNCQMK8ApYSyz4dYYWwBSV+
	TL7HAmIzC6hLTJq3iBnC1pZ48u4CK8SpChI7zr5mhDjCSmLZi0ZGiBpxiUkPHrJPYBSahWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSnsmfQOxlUNFocYBTgY
	lXh4I3YYhgixJpYVV+YeYpTgYFYS4Q31MAoR4k1JrKxKLcqPLyrNSS0+xGgK9OhEZinR5Hxg
	es0riTc0NjE3NTa1NLEwMbNUEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cCofHGpN9OGPUIf
	DhzR5lLV3bc39OymG/E1VWt/H3urtlaoZ+bzs6535WXWR9nfvfZ6kbmO0q9bXmfvH6h1fX5+
	T/Kq+zfeu1nX6oYyqyzXL1gfyCbNfsCd1YaxcYZYYn3PEyFGZ6UVi+bZ3D/NseB6dczG/i6p
	Xdmf93nsfhxfZObwqGib/NTbSizFGYmGWsxFxYkAc+qPvXcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tuesday, September 30, 2014 9:39 PM Doug Anderson wrote,
> Subject: Re: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
> devices
> 
> Pankaj,
> 
> On Tue, Sep 30, 2014 at 1:35 AM, Pankaj Dubey <pankaj.dubey@samsung.com>
> wrote:
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain use cases it is desirable to make a device used with another
> > driver a syscon interface provider.
> >
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks, coprocessor
> > power control, etc. In such case, there is a need to have a dedicated
> > driver for such system controller but also share registers with other
> > drivers. The latter is where the syscon interface is helpful.
> >
> > In case of DT based platforms, this patch decouples syscon object from
> > syscon platform driver, and allows to create syscon objects first time
> > when it is required by calling of syscon_regmap_lookup_by APIs and
> > keep a list of such syscon objects along with syscon provider
> > device_nodes and regmap handles.
> >
> > For non-DT based platforms, this patch keeps syscon platform driver
> > structure so that syscon can be probed and such non-DT based drivers
> > can use syscon_regmap_lookup_by_pdev API and access regmap handles.
> > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > we can completely remove platform driver of syscon, and keep only
> > helper functions to get regmap handles.
> >
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > Patch v6 and related discussions can be found here [1].
> >
> > Change since v5:
> >  - Addressed review comments from "Heiko Stuebner".
> >  - Updated commit description.
> >  - Including Arnd's and Heiko's Reviewed-by.
> >
> > Change since v5:
> >  - Dropping creation of dummy platform device in of_syscon_register.
> >  - As we are changing syscon to decouple from platform_device, creation of
> >    dummy platform_device does not look good option, and as suggested by Arnd,
> >    I made another attempt so that regmap_mmio_init API should work with NULL
> >    dev pointer itself. Since regmap needs to know about Syscon device node
> >    properties so let's parse device node of syscon in syscon itself for any
> >    such properties and using regmap_config parameter pass all such information
> >    to regmap. Other concern of crashes due to NULL dev pointer in regmap already
> >    addressed in separate patches of regmap. Please see [2] and [3].
> >
> > Changes since v4:
> >  - Addressed Tomasz Figa's comments for v4.
> >  - Added error handing in of_syscon_register function.
> >  - Using devm_regmap_init_mmio instead of regmap_init_mmio.
> >
> > Changes since v3:
> >  - Addressed Arnd's comment for v2.
> >  - Updated of_syscon_register for adding dev pointer in regmap_init_mmio.
> >  - For early users created dummy platform device.
> >
> > Changes since v2:
> >  - Added back platform device support from syscon, with one change that
> >    syscon will not be probed for DT based platform.
> >  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
> >    users of syscon will not be broken.
> >  - Removed unwanted change in syscon.h.
> >  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
> >    Arnd Bergmann.
> >  - Added Tested-by of Vivek Gautam for testing on Exynos platform.
> >
> > Changes since v1:
> >  - Removed of_syscon_unregister function.
> >  - Modified of_syscon_register function and it will be used by syscon.c
> >    to create syscon objects whenever required.
> >  - Removed platform device support from syscon.
> >  - Removed syscon_regmap_lookup_by_pdevname API support.
> >  - As there are significant changes w.r.t patchset v1, I am taking over
> >    author for this patchset from Tomasz Figa.
> >
> > [1]: https://lkml.org/lkml/2014/9/29/99
> > [2]: https://lkml.org/lkml/2014/9/18/130
> > [3]: https://lkml.org/lkml/2014/9/27/2
> >  drivers/mfd/syscon.c |   96
> ++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 74 insertions(+), 22 deletions(-)
> 
> You probably already have enough tags, but just in case.  ;)  On an rk3288-based
> system (this patch backported to 3.14):
> 
> Tested-by: Doug Anderson <dianders@chromium.org>

I think now we can take have this patch in. So will you please take this patch.

Thanks,
Pankaj Dubey

