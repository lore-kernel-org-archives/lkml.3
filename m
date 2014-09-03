Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaICECR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:02:17 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35849 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaICECP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140902143711.GD16872@saruman.home>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
	<1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
	<CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
	<CAFp+6iHsfg6Ru0LBN=JviV=-mSdmuSo9Te3EXYF+X8jssD_BYQ@mail.gmail.com>
	<20140902143711.GD16872@saruman.home>
Date: Wed, 3 Sep 2014 09:32:14 +0530
X-Google-Sender-Auth: QWanxRd7Xp0t_Z4mCzYfLrS5_Kg
Message-ID: <CAFp+6iE4V4bWHGasr2qNC14mGNAfjQbgerCDMLLatnQQJ86NuA@mail.gmail.com>
Subject: Re: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for Exynos7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Daniele Forsi <dforsi@gmail.com>, USB list <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Sep 01, 2014 at 01:30:21PM +0530, Vivek Gautam wrote:
>> On Thu, Aug 28, 2014 at 8:36 PM, Daniele Forsi <dforsi@gmail.com> wrote:
>> > 2014-08-28 10:02 GMT+02:00 Vivek Gautam:
>> >
>> >> This USB 3.0 PHY controller is also present on Exynos7
>> >> platform, so adding the dependency on ARCH_EXYNOS7 for this driver.
>> >
>> >> +++ b/drivers/phy/Kconfig
>> >> @@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
>> >>
>> >>  config PHY_EXYNOS5_USBDRD
>> >>         tristate "Exynos5 SoC series USB DRD PHY driver"
>> >> -       depends on ARCH_EXYNOS5 && OF
>> >> +       depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF
>> >
>> > shouldn't that prompt and its help text be updated to mention also Exynos7?
>>
>> Right, even that has to be updated accordingly. Will update the same in next
>> version of the patch. Thanks for pointing this.
>
> I would rather change that to ARCH_EXYNOS, unless Kishon doesn't like
> that idea. The thing is that this will likely need to be patches for
> exynos8, 9, 10, 11...

Yes, after we have the 2nd version of Exynos7 support patches, it makes
more sense to keep dependency on ARCH_EXYNOS.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
