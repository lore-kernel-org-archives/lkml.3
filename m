Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaKZB7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:59:11 -0500
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:59419 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510AbaKZB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:59:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2734:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3872:4321:5007:6261:7809:7903:9010:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cap39_15725838a7e15
X-Filterd-Recvd-Size: 2233
Message-ID: <1416967146.8358.19.camel@perches.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
From: Joe Perches <joe@perches.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, arm@kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Nov 2014 17:59:06 -0800
In-Reply-To: <20141126015452.12298.30373@quantum>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
	 <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
	 <20141126015452.12298.30373@quantum>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 17:54 -0800, Mike Turquette wrote:
> Quoting Pawel Moll (2014-11-25 10:17:35)
> > This patch adds a separate section for the ARM
> > Versatile Express platform maintainers, listing
> > all different bits and bobs used by it.
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > +ARM/VERSATILE EXPRESS PLATFORM
[]
> > +F:     arch/arm/boot/dts/vexpress-*
> > +F:     arch/arm/mach-vexpress/*
> > +F:     drivers/bus/vexpress-config.c
> > +F:     drivers/clk/versatile/clk-vexpress-osc.c
> > +F:     drivers/clocksource/versatile.c
> > +F:     drivers/cpufreq/vexpress-spc-cpufreq.c
> > +F:     drivers/hwmon/vexpress.c
> > +F:     drivers/mfd/vexpress-sysreg.c
> > +F:     drivers/misc/vexpress-vexpress-syscfg.c
> > +F:     drivers/power/reset/vexpress-poweroff.c
> > +F:     drivers/regulator/vexpress.c
> > +F:     include/linux/vexpress.h
> >

maybe
F:	arch/arm/boot/dts/vexpress*
F:	arch/arm/mach-vexpress/
F:	*/*/vexpress*
F:	*/*/*/*vexpress*
F:	drivers/clocksource/versatile.c


