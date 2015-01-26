Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbbAZBLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 20:11:25 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:15478 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbbAZBLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 20:11:22 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "peda@axentia.se" <peda@axentia.se>
Subject: RE: [PATCH 05/12] ARM: at91: move select SRAM to ARCH_AT91
Thread-Topic: [PATCH 05/12] ARM: at91: move select SRAM to ARCH_AT91
Thread-Index: AQHQNInhdPHKSa69TkmodYmpLSZThJzM/lYAgASiEIA=
Date: Mon, 26 Jan 2015 01:10:06 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD32739@penmbx01>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-6-git-send-email-wenyou.yang@atmel.com>
 <20150123102426.GG19922@piout.net>
In-Reply-To: <20150123102426.GG19922@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

Thank you for your review.

> -----Original Message-----
> From: Alexandre Belloni [mailto:alexandre.belloni@free-electrons.com]
> Sent: Friday, January 23, 2015 6:24 PM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; sylvain.rochet@finsecur.com; peda@axentia.se
> Subject: Re: [PATCH 05/12] ARM: at91: move select SRAM to ARCH_AT91
> 
> On 20/01/2015 at 16:16:58 +0800, Wenyou Yang wrote :
> > Because the CONFIG_AT91_SLOW_CLOCK will be removed to simply the PM
> > config, so move select SRAM.
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> > ---
> >  arch/arm/mach-at91/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > index 56dcede..7d5e201 100644
> > --- a/arch/arm/mach-at91/Kconfig
> > +++ b/arch/arm/mach-at91/Kconfig
> > @@ -6,6 +6,7 @@ config ARCH_AT91
> >  	select PINCTRL
> >  	select PINCTRL_AT91
> >  	select USE_OF
> > +	select SRAM if PM
> >  	bool
> >
> >  menuconfig SOC_SAM_V7
> > @@ -128,7 +129,6 @@ comment "AT91 Feature Selections"
> >
> >  config AT91_SLOW_CLOCK
> >  	bool "Suspend-to-RAM disables main oscillator"
> > -	select SRAM
> >  	depends on SUSPEND
> >  	help
> >  	  Select this if you want Suspend-to-RAM to save the most power
> > --
> > 1.7.9.5
> >
> 
> --
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
Best Regards,
Wenyou Yang
