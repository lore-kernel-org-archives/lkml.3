Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3AVFy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:54:28 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48193 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3AVFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <053501cdf85e$507c2560$f1747020$@samsung.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
	<20130118131013.GG4672@arwen.pp.htv.fi>
	<20130118131250.GH4672@arwen.pp.htv.fi>
	<053501cdf85e$507c2560$f1747020$@samsung.com>
Date: Tue, 22 Jan 2013 11:24:25 +0530
Message-ID: <CAFp+6iFM8g28PohX=95qMccNDkdmt86gKNg9=AJXdrCovsryPQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: balbi@ti.com, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        p.paneri@samsung.com, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Tue, Jan 22, 2013 at 10:36 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Felipe Balbi wrote:
>>
>> On Fri, Jan 18, 2013 at 03:10:13PM +0200, Felipe Balbi wrote:
>> > Hi,
>> >
>> > On Tue, Dec 18, 2012 at 09:09:40PM +0530, Vivek Gautam wrote:
>> > > This patch-set enables the samsung-usbphy driver on exynos5250,
>> > > which enables the support for USB2 type and USB3 type phys.
>> > > The corresponding phy driver patches are available at:
>> > >  1) https://lkml.org/lkml/2012/12/18/201
>> > >  2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-
>> December/024559.html
>> > >
>> > > Tested this patch-set on exynos5250 with following patch-sets for
>> > > USB 2.0 and USB 3.0:
>> > >  - https://patchwork.kernel.org/patch/1794651/
>> > >  - https://lkml.org/lkml/2012/12/18/201
>> > >  - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-
>> December/024559.html
>> > >  - http://comments.gmane.org/gmane.linux.usb.general/76352
>> > >  - https://lkml.org/lkml/2012/12/13/492
>> > >
>> > > Vivek Gautam (2):
>> > >   ARM: Exynos5250: Enabling samsung-usbphy driver
>> > >   ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver
>> >
>> > What should I do with this series ? Is it ready to apply ? If it is,
>> > then please resend with Kukjim's Acked-by.
>>
>> actually, now that I look again, it's all under arch/arm/, so Kukjim can
>> take all of those through his tree ;-)
>>
> Yes, once Vivek addresses comments from Sylwester, let me pick up into
> Samsung tree :-)
>

Sure, i shall update this patch-series based on separate drivers for
USB 3.0 PHY controller
as posted in following patch series :
[PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250



-- 
Thanks & Regards
Vivek
