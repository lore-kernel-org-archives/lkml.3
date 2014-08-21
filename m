Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaHUPCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:02:00 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:40889 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750978AbaHUPB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:01:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3866:3867:3868:3870:4321:5007:7514:7652:7903:10004:10400:10848:11026:11232:11658:11914:12114:12438:12517:12519:12555:12740:13019:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seat73_2e38632f79e1e
X-Filterd-Recvd-Size: 1740
Message-ID: <1408633316.23250.35.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: update $allowed_asm_includes macros, add
 reboot.h and time.h
From: Joe Perches <joe@perches.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Aug 2014 08:01:56 -0700
In-Reply-To: <1408606992-9977-1-git-send-email-ryazanov.s.a@gmail.com>
References: <1408606992-9977-1-git-send-email-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 11:43 +0400, Sergey Ryazanov wrote:
> Several architectures (e.g. x86, MIPS, Blackfin) have asm/reboot.h and
> asm/time.h header files, which are not included in linux/reboot.h and
> linux/time.h headers. This lead to generation of false positive errors.

I've no objection.

> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  scripts/checkpatch.pl | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 31a731e..29d6b56 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -425,7 +425,9 @@ foreach my $entry (@mode_permission_funcs) {
>  
>  our $allowed_asm_includes = qr{(?x:
>  	irq|
> -	memory
> +	memory|
> +	time|
> +	reboot
>  )};
>  # memory.h: ARM has a custom one
>  



