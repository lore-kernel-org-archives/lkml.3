Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3GWI4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:56:02 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55929 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3GWIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:55:58 -0400
Date: Tue, 23 Jul 2013 09:55:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 07/22] ARM: exynos: Remove '0x's from Exynos4110 DTSI file
Message-ID: <20130723085552.GF26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <2350088.9z671SCjFz@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2350088.9z671SCjFz@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Tomasz Figa wrote:

> Hi Lee,
> 
> On Monday 22 of July 2013 11:52:26 Lee Jones wrote:
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: linux-samsung-soc@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/exynos4210.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> > b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> > --- a/arch/arm/boot/dts/exynos4210.dtsi
> > +++ b/arch/arm/boot/dts/exynos4210.dtsi
> > @@ -72,7 +72,7 @@
> >  		};
> >  	};
> > 
> > -	clock: clock-controller@0x10030000 {
> > +	clock: clock-controller@10030000 {
> >  		compatible = "samsung,exynos4210-clock";
> >  		reg = <0x10030000 0x20000>;
> >  		#clock-cells = <1>;
> 
> This looks fine, but please fix commit message - it should be Exynos4210. 
> Also some explanation why this change is needed would be good, even if 
> it's obvious.

Hi Tomasz,

I'm happy to fixup the $SUBJECT line, but do we really have to enter
an explanation if it's obvious? Seems a little belt and braces.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
