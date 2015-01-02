Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbABRmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:42:37 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58589 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbABRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:42:35 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+n2oyS+yuHhcM10XIMEsbN
Date: Fri, 2 Jan 2015 09:38:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 0/2] ARM: l2c: OMAP4/AM437x: Additional register
 programming support.
Message-ID: <20150102173859.GE3298@atomide.com>
References: <1420219072-6521-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420219072-6521-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [150102 09:20]:
> Hi,
> 
> OMAP4 and AM437x ROM code provides services to program PL310's latency
> registers and AM437x provides service for programming Address filter
> registers.
> 
> Provide support in the kernel for the same.
> 
> This provides some support to the series: http://marc.info/?l=linux-arm-kernel&m=141933190912495&w=2

Are these to be applied before Thomasz's series as fixes? If we
don't need these as fixes for the -rc, then probably makes sense
for RMK to merge them all together for v3.20.

Regards,

Tony
 
> Nishanth Menon (2):
>   ARM: l2c: OMAP4/AM437x: Introduce support for cache latency
>     programming
>   ARM: l2c: AM437x: Introduce support for cache filter programming
> 
>  arch/arm/mach-omap2/common.h       |    1 +
>  arch/arm/mach-omap2/omap-secure.h  |    2 ++
>  arch/arm/mach-omap2/omap-smc.S     |   20 ++++++++++++++++++++
>  arch/arm/mach-omap2/omap4-common.c |   36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 59 insertions(+)
> 
> Regards,
> Nishanth Menon
> 
> -- 
> 1.7.9.5
> 
