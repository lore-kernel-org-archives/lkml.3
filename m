Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaFBJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38201 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724AbaFBJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:35:08 -0400
Date: Mon, 2 Jun 2014 11:35:03 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140602093503.GA24919@kwain>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140602092913.GA933@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602092913.GA933@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:29:13AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 02, 2014 at 11:21:02AM +0200, Antoine Ténart wrote:
> > diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> > index d3c5f14dc142..e3733692f67a 100644
> > --- a/arch/arm/mach-berlin/Kconfig
> > +++ b/arch/arm/mach-berlin/Kconfig
> > @@ -4,6 +4,7 @@ config ARCH_BERLIN
> >  	select GENERIC_IRQ_CHIP
> >  	select DW_APB_ICTL
> >  	select DW_APB_TIMER_OF
> > +	select SMP
> 
> Please don't add selects of symbols which aren't absolutely necessary.
> 
> Since this has been merged without SMP support and presumably works without
> SMP support, it would appear that SMP support is not mandatory for the
> platform to work.

It can work without SMP, I'll remove this.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
