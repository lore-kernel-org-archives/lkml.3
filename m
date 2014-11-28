Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaK1R4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:56:41 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:50613 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbaK1R4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:56:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2734:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3872:4321:5007:6261:7809:7903:9010:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12555:12740:13069:13163:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mind98_39bea3e5a810d
X-Filterd-Recvd-Size: 2529
Message-ID: <1417197395.4305.5.camel@perches.com>
Subject: Re: [PATCH v2] MAINTAINERS: ARM Versatile Express platform
From: Joe Perches <joe@perches.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Nov 2014 09:56:35 -0800
In-Reply-To: <1417003985-21564-1-git-send-email-pawel.moll@arm.com>
References: <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
	 <1417003985-21564-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 12:13 +0000, Pawel Moll wrote:
> This patch adds a separate section for the ARM
> Versatile Express platform maintainers, listing
> all different bits and bobs used by it.
> 
> Acked-by: Liviu Dudau <liviu.dudau@arm.com>
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Acked-by: Michael Turquette <mturquette@linaro.org>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ff630d..924454f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1503,6 +1503,18 @@ S:	Maintained
>  F:	drivers/clk/ux500/
>  F:	include/linux/platform_data/clk-ux500.h
>  
> +ARM/VERSATILE EXPRESS PLATFORM
> +M:	Liviu Dudau <liviu.dudau@arm.com>
> +M:	Sudeep Holla <sudeep.holla@arm.com>
> +M:	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	arch/arm/boot/dts/vexpress*
> +F:	arch/arm/mach-vexpress/
> +F:	*/*/vexpress*
> +F:	drivers/clk/versatile/clk-vexpress-osc.c
> +F:	drivers/clocksource/versatile.c

Your original submission had:

F:     drivers/power/reset/vexpress-poweroff.c

This file is not matched by:

F:	*/*/vexpress*


