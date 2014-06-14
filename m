Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaFNUeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:34:05 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:45138 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841AbaFNUeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:34:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2829:3138:3139:3140:3141:3142:3352:3865:3866:3870:3873:4321:4362:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12114:12438:12517:12519:12555:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: view53_5b0f721a7109
X-Filterd-Recvd-Size: 2005
Message-ID: <1402778036.2756.24.camel@joe-AO725>
Subject: Re: [PATCH] serial: samsung: Fix compile error with
 SERIAL_SAMSUNG_DEBUG
From: Joe Perches <joe@perches.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Jun 2014 13:33:56 -0700
In-Reply-To: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
References: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg?  Can you please apply this soon?

Thanks.

On Sat, 2014-06-14 at 22:07 +0200, Christian Engelmayer wrote:
> Commit e4ac92d (serial: samsung: Neaten dbg uses) contains a typo in the
> changed dbg() function regarding the name of the used character buffer.
> This breaks the build if actually compiled with CONFIG_SERIAL_SAMSUNG_DEBUG.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested. Applies against branch tty-next in tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> ---
>  drivers/tty/serial/samsung.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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



