Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaJ0XRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:17:24 -0400
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:55931 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752741AbaJ0XRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:17:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3867:3872:4321:4385:5007:6261:7809:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13019:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: deer38_7a1f446f7af12
X-Filterd-Recvd-Size: 2660
Message-ID: <1414451837.18896.14.camel@perches.com>
Subject: Re: [PATCH v2 8/8] MAINTAINERS: add at91 power and memory entries
From: Joe Perches <joe@perches.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 27 Oct 2014 16:17:17 -0700
In-Reply-To: <1414451377-11053-9-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
	 <1414451377-11053-9-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 00:09 +0100, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -871,6 +871,25 @@ M:	Boris Brezillon <boris.brezillon@free-electrons.com>
>  S:	Maintained
>  F:	drivers/clk/at91
>  
> +ARM/ATMEL AT91 Poweroff driver
> +M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/power/reset/at91-poweroff.c
> +
> +ARM/ATMEL AT91 Reset driver
> +M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/power/reset/at91-reset.c

It's traditional to use upper case section descriptions.

Do these 2 really need to be separate entries?

> +
> +ARM/ATMEL AT91 SDRAM Controller driver
> +M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/memory/atmel-sdramc.c
> +F:	include/soc/atmel/memory.h
> +
>  ARM/CALXEDA HIGHBANK ARCHITECTURE
>  M:	Rob Herring <robh@kernel.org>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)



