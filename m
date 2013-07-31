Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab3GaKVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:21:09 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49418 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GaKVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:21:07 -0400
Date: Wed, 31 Jul 2013 11:21:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
Message-ID: <20130731102100.GD13298@lee--X1>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
 <20130730115403.GA29992@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130730115403.GA29992@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Pavel Machek wrote:

> On Fri 2013-07-19 14:58:32, Lee Jones wrote:
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Why?

Convention.

> > diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> > index 3d580d6..46fd8af 100644
> > --- a/arch/arm/boot/dts/hrefv60plus.dts
> > +++ b/arch/arm/boot/dts/hrefv60plus.dts
> > @@ -26,7 +26,7 @@
> >  
> >  	soc {
> >  		i2c@80110000 {
> > -			bu21013_tp@0x5c {
> > +			bu21013_tp@5c {
> >  				reset-gpio = <&gpio4 15 0x4>;
> >  			};
> >  		};
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
