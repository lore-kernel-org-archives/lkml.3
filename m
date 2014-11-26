Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaKZMET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:04:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39662 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKZMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:04:17 -0500
Message-ID: <1417003449.3972.1.camel@arm.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
From: Pawel Moll <pawel.moll@arm.com>
To: Joe Perches <joe@perches.com>
Cc: Mike Turquette <mturquette@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2014 12:04:09 +0000
In-Reply-To: <1416967146.8358.19.camel@perches.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
	 <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
	 <20141126015452.12298.30373@quantum> <1416967146.8358.19.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 01:59 +0000, Joe Perches wrote:
> On Tue, 2014-11-25 at 17:54 -0800, Mike Turquette wrote:
> > Quoting Pawel Moll (2014-11-25 10:17:35)
> > > This patch adds a separate section for the ARM
> > > Versatile Express platform maintainers, listing
> > > all different bits and bobs used by it.
> []
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > > +ARM/VERSATILE EXPRESS PLATFORM
> []
> > > +F:     arch/arm/boot/dts/vexpress-*
> > > +F:     arch/arm/mach-vexpress/*
> > > +F:     drivers/bus/vexpress-config.c
> > > +F:     drivers/clk/versatile/clk-vexpress-osc.c
> > > +F:     drivers/clocksource/versatile.c
> > > +F:     drivers/cpufreq/vexpress-spc-cpufreq.c
> > > +F:     drivers/hwmon/vexpress.c
> > > +F:     drivers/mfd/vexpress-sysreg.c
> > > +F:     drivers/misc/vexpress-vexpress-syscfg.c
> > > +F:     drivers/power/reset/vexpress-poweroff.c
> > > +F:     drivers/regulator/vexpress.c
> > > +F:     include/linux/vexpress.h
> > >
> 
> maybe
> F:	arch/arm/boot/dts/vexpress*

Ok.

> F:	arch/arm/mach-vexpress/

Right, of course. Whole directory.

> F:	*/*/vexpress*

Cool, didn't think about multiple wildcards. 

> F:	*/*/*/*vexpress*

I'd keep the clk-vexpress-osc.c explicit - it's an odd one, and don't
feel comfortable with the wildcard before vexpress.

> F:	drivers/clocksource/versatile.c

Thanks for the suggestion, sill spin the patch in a second.

Pawel

