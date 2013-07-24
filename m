Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3GXPFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:05:08 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53272 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3GXPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:05:06 -0400
Date: Wed, 24 Jul 2013 16:05:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>, arnd@arndb.de,
        linus.walleij@stericsson.com, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 07/22] ARM: Exynos4210: Remove '0x's from Exynos4110
 DTSI file
Message-ID: <20130724150500.GN26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <20130724123931.GL26801@laptop>
 <6156493.tCYrm4xD5A@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6156493.tCYrm4xD5A@amdc1227>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Tomasz Figa wrote:

> On Wednesday 24 of July 2013 13:39:31 Lee Jones wrote:
> > ... for the sake of consistency and assumed convention.
> > 
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: linux-samsung-soc@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> > b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> > --- a/arch/arm/boot/dts/exynos4210.dtsi
> > +++ b/arch/arm/boot/dts/exynos4210.dtsi
> > @@ -72,7 +72,7 @@
> >                 };
> >         };
> > 
> > -       clock: clock-controller@0x10030000 {
> > +       clock: clock-controller@10030000 {
> >                 compatible = "samsung,exynos4210-clock";
> >                 reg = <0x10030000 0x20000>;
> >                 #clock-cells = <1>;
> 
> Looks good to me, except the subject which is still wrong - 
> s/Exynos4110/Exynos4210/.

Ah, I get you know. My bad, will fix.

> I guess it might be fixed when applying, though.


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
