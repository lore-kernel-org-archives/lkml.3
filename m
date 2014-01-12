Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaALSEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:04:41 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:59383 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaALSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:04:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3868:3870:4321:4362:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stew77_7f051fea90032
X-Filterd-Recvd-Size: 1795
Message-ID: <1389549871.24849.0.camel@joe-AO722>
Subject: Re: [PATCH] [trivial] scripts: Fix comment and message typo in
 checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 12 Jan 2014 10:04:31 -0800
In-Reply-To: <1389547435-23207-1-git-send-email-standby24x7@gmail.com>
References: <1389547435-23207-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 02:23 +0900, Masanari Iida wrote:
> This patch corrected a spelling typo in comment
> and messages in checkpatch.pl.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4218,7 +4218,7 @@ sub process {
>  			}
>  		}
>  
> -# check for case / default statements not preceeded by break/fallthrough/switch
> +# check for case / default statements not preceded by break/fallthrough/switch
>  		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
>  			my $has_break = 0;
>  			my $has_statement = 0;
> @@ -4239,7 +4239,7 @@ sub process {
>  			}
>  			if (!$has_break && $has_statement) {
>  				WARN("MISSING_BREAK",
> -				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
> +				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
>  			}
>  		}

Thanks.

