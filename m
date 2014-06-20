Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013AbaFTUTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:19:00 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:46636 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753696AbaFTUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:18:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3352:3622:3868:3873:4321:4605:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nail87_4e35ed5fee52a
X-Filterd-Recvd-Size: 1770
Message-ID: <1403295536.4076.8.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Also suggest 'else if' when if follows
 brace
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2014 13:18:56 -0700
In-Reply-To: <1403294665-18344-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403294665-18344-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 22:04 +0200, Rasmus Villemoes wrote:
> This might help a kernel hacker think twice before blindly adding a
> newline.

Sure, fine by me.

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  scripts/checkpatch.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 010b18e..e1924eb 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3601,7 +3601,7 @@ sub process {
>  # if should not continue a brace
>  		if ($line =~ /}\s*if\b/) {
>  			ERROR("TRAILING_STATEMENTS",
> -			      "trailing statements should be on next line\n" .
> +			      "trailing statements should be on next line (or did you mean 'else if'?)\n" .
>  				$herecurr);
>  		}
>  # case and default should not have general statements after them



