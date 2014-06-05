Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaFEBUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:20:47 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:36747 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbaFEBUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:20:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:3873:4250:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13161:13229:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: song68_2360f5c0cc333
X-Filterd-Recvd-Size: 2110
Message-ID: <1401931241.26329.16.camel@joe-AO725>
Subject: Re: [PATCH] serial: samsung: fix typo in debug code
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Date: Wed, 04 Jun 2014 18:20:41 -0700
In-Reply-To: <10455941.RzodM59Z3O@wuerfel>
References: <10455941.RzodM59Z3O@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 11:53 +0200, Arnd Bergmann wrote:
> commit e4ac92df2791 ("serial: samsung: Neaten dbg uses") introduced
> a regression in the conversion from vsprintf to vsnprintf.
> 
> This fixes the build error by passing the correct variable name.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Joe Perches <joe@perches.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> 
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index 3293377..c1d3ebd 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -66,7 +66,7 @@ static void dbg(const char *fmt, ...)
>  	char buff[256];
>  
>  	va_start(va, fmt);
> -	vscnprintf(buff, sizeof(buf), fmt, va);
> +	vscnprintf(buff, sizeof(buff), fmt, va);
>  	va_end(va);
>  
>  	printascii(buff);

Greg?

The original has ended up in Linus' -next branch.

Can you please apply this sooner rather than later?

Sorry for the bother.  Dunno how it happened.

I thought I compiled it with the appropriate CONFIG
settings.


