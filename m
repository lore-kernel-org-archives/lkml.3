Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232AbaH0QhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:37:19 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:38795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934868AbaH0QhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:37:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3868:3870:3874:4250:4321:4823:5007:6119:6120:7652:7901:7904:10004:10400:10848:11232:11658:11914:12043:12294:12517:12519:12555:12740:13019:13069:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chain27_3f4d528e03d4a
X-Filterd-Recvd-Size: 2306
Message-ID: <1409157433.25751.7.camel@joe-AO725>
Subject: Re: [PATCH resend] checkpatch: Enable whitespace checks for DTS
 files
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Aug 2014 09:37:13 -0700
In-Reply-To: <1409152106-9424-1-git-send-email-geert+renesas@glider.be>
References: <1409152106-9424-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Andrew Morton)

On Wed, 2014-08-27 at 17:08 +0200, Geert Uytterhoeven wrote:
> When run on *.dtsi or *.dts files, the whitespace checks were skipped,
> while they are valid for DTS files.  Hence stop skipping them.
> 
> I ran checkpatch on all in-tree DTS files, and didn't notice any error or
> warning messages that are inappropriate for DTS files.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Joe Perches <joe@perches.com>

> ---
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 31a731e06f50..ded90b6d7e17 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2338,7 +2338,7 @@ sub process {
>  		}
>  
>  # check we are in a valid source file if not then ignore this hunk
> -		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
> +		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
>  
>  #line length limit
>  		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
> @@ -2399,7 +2399,7 @@ sub process {
>  		}
>  
>  # check we are in a valid source file C or perl if not then ignore this hunk
> -		next if ($realfile !~ /\.(h|c|pl)$/);
> +		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
>  
>  # at the beginning of a line any tabs must come first and anything
>  # more than 8 must use tabs.



