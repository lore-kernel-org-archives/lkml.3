Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3FEVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:45:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:38848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab3FEVpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:45:21 -0400
Date: Wed, 5 Jun 2013 23:45:06 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Message-ID: <20130605214506.GC14209@lukather>
References: <201306030055.15413.heiko@sntech.de>
 <201306030102.20890.heiko@sntech.de>
 <20130605091119.18432af4@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130605091119.18432af4@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Jun 05, 2013 at 09:11:19AM +0200, Thomas Petazzoni wrote:
> Dear Heiko Stübner,
> 
> On Mon, 3 Jun 2013 01:02:20 +0200, Heiko Stübner wrote:
> > index 0000000..a2d8c70
> > --- /dev/null
> > +++ b/arch/arm/mach-rockchip/Makefile.boot
> > @@ -0,0 +1,3 @@
> > +zreladdr-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60408000
> > +params_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60088000
> > +initrd_phys-$(CONFIG_ARCH_ROCKCHIP)	:= 0x60800000
> 
> Thanks to the AUTO_ZRELADDR thing that you're using as part of the
> MULTIPLATFORM support, this Makefile.boot file is no longer useful. See
> mach-socfpga, mach-mvebu, mach-bcm2835, mach-bcm, mach-highbank, etc.
> 
> Cc'ing Maxime Ripard, since I see that mach-sunxi does have a
> Makefile.boot, even though I believe it is not needed.

Yes, it is a left-over and should be removed obviously.

Thanks for reminding it to me :)

Maxime
