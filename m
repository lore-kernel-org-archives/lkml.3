Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbbAEMgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:36:07 -0500
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:59138 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753305AbbAEMgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:36:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3868:3870:3871:4321:4552:5007:6261:7514:7576:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12679:12683:12740:13069:13095:13311:13357:14095:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wave18_3506b4e6dc253
X-Filterd-Recvd-Size: 1525
Message-ID: <1420461363.2652.6.camel@perches.com>
Subject: Re: [PATCH 3/3] spi:spi-gpio: fixed space coding styple issue
From: Joe Perches <joe@perches.com>
To: nizamhaider786@gmail.com
Cc: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Jan 2015 04:36:03 -0800
In-Reply-To: <1420459263-2190-1-git-send-email-nizamhaider786@gmail.com>
References: <1420459263-2190-1-git-send-email-nizamhaider786@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 17:31 +0530, nizamhaider786@gmail.com wrote:
> From: Nizam Haider <nizamhaider786@gmail.com>
> 
> fixed a coding style issue

This is a checkpatch defect and not a coding styple (style) issue.

Please don't blindly take checkpatch messages as dicta.

btw: The "From: " line in your email message body isn't necessary 
     or desired.  Please be careful with spelling/typos too.

> diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
[]
> @@ -92,7 +92,7 @@ struct spi_gpio {
>  
>  /*----------------------------------------------------------------------*/
>  
> -static inline struct spi_gpio * __pure
> +static inline struct spi_gpio *__pure


