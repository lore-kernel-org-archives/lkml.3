Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3KTQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:27:27 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38179 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3KTQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:27:23 -0500
Date: Wed, 20 Nov 2013 08:27:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] watchdog: bcm281xx: Watchdog Driver
Message-ID: <20131120162721.GB28683@roeck-us.net>
References: <1384888074-19696-1-git-send-email-markus.mayer@linaro.org>
 <1384888074-19696-2-git-send-email-markus.mayer@linaro.org>
 <CAPdLdqmxFnJ9HZa04buh8NecMszEAp11VRU4Q159vZ+=NG9p3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPdLdqmxFnJ9HZa04buh8NecMszEAp11VRU4Q159vZ+=NG9p3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:12:37AM -0800, Markus Mayer wrote:
> On 19 November 2013 11:07, Markus Mayer <markus.mayer@linaro.org> wrote:
> > This commit adds support for the watchdog timer used on the BCM281xx
> > family of SoCs.
> >
> > Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> > Reviewed-by: Matt Porter <matt.porter@linaro.org>
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/watchdog/Kconfig        |   22 +++
> >  drivers/watchdog/Makefile       |    1 +
> >  drivers/watchdog/bcm_kona_wdt.c |  365 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 388 insertions(+)
> >  create mode 100644 drivers/watchdog/bcm_kona_wdt.c
> >
> 
> [...]
> 
> > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > index 6c5bb27..7c860ca 100644
> > --- a/drivers/watchdog/Makefile
> > +++ b/drivers/watchdog/Makefile
> > @@ -55,6 +55,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
> >  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
> >  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
> >  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
> > +obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
> >
> >  # AVR32 Architecture
> >  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> 
> Just to let everyone know, due to the watchdog -> mainline merge a few
> days ago, there's a trivial merge conflict now in the makefile. I'll
> send out a re-based v5 of this patch once 3.13-rc1 has been tagged
> (unless you would like a rebased-to-tip version before then).
> 
Hi Markus,

Yes, I noticed when I merged it into my watchdog-next branch.

Reminds me ... v3 had a whitespace problem. I don't recall if you fixed
that in v4. If you didn't, that might be a better reason to send v5.
Take your patch and apply it with "git am" to find out.

Thanks,
Guenter
