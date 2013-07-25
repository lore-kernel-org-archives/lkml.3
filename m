Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3GYHwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:52:25 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60944 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3GYHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:52:21 -0400
Date: Thu, 25 Jul 2013 08:52:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 07/22] ARM: dts: Remove '0x's from Exynos4210 DTSI file
Message-ID: <20130725075215.GA3403@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <20130724150937.GO26801@laptop>
 <5075798.2aqxtybhC8@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5075798.2aqxtybhC8@amdc1227>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Tomasz Figa wrote:

> On Wednesday 24 of July 2013 16:09:37 Lee Jones wrote:
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
> Acked-by: Tomasz Figa <t.figa@samsung.com>

Thanks Tomasz.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
