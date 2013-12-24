Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3LXFnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 00:43:55 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:45630 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3LXFnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 00:43:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131223164828.GF28679@saruman.home>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
	<1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
	<CAFp+6iF+15barZ=H_0h2VfNWSyxEr=MJy7Mtfn90PqWwXFFMSA@mail.gmail.com>
	<20131223164828.GF28679@saruman.home>
Date: Tue, 24 Dec 2013 11:13:51 +0530
Message-ID: <CAFp+6iEL=+t+O51k48ADgQKigGFOmLyicg4Y2XPrasqM43SYeA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Julius Werner <jwerner@chromium.org>,
        Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Mon, Dec 23, 2013 at 10:18 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Dec 23, 2013 at 02:41:15PM +0530, Vivek Gautam wrote:
>> On Wed, Dec 4, 2013 at 3:39 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> > Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> > The new driver uses the generic PHY framework and will interact
>> > with DWC3 controller present on Exynos5 series of SoCs.
>> > Thereby, removing old phy-samsung-usb3 driver and related code
>> > used untill now which was based on usb/phy framework.
>> >
>> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > ---
>>
>> a humble ping !! :-)
>> Any comments on this patch ?
>
> This is Kishon's domain. I think he's on vacations by now...

Right, :-)

>
>> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> > index a344f3d..67e9045 100644
>> > --- a/drivers/phy/Kconfig
>> > +++ b/drivers/phy/Kconfig
>> > @@ -51,4 +51,12 @@ config PHY_EXYNOS_DP_VIDEO
>> >         help
>> >           Support for Display Port PHY found on Samsung EXYNOS SoCs.
>> >
>> > +config PHY_EXYNOS5_USB3
>> > +       tristate "Exynos5 SoC series USB 3.0 PHY driver"
>> > +       depends on ARCH_EXYNOS5
>
> I would add || COMPILE_TEST here and make sure this builds on other
> arches too.

Sure i will add this.

>
> The rest of the driver looks all right to my eyes.

Thanks Felipe for the review. :-)

>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
>
> --
> balbi



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
