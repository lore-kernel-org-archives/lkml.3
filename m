Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaJUQkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:40:16 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:43787 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933074AbaJUQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:40:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2196:2197:2199:2200:2201:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3653:3865:3868:3871:3872:3874:4321:4385:5007:6261:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river51_58ce1eb3a7962
X-Filterd-Recvd-Size: 1610
Message-ID: <1413909608.12828.5.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Improve warning message for "needless if"
 case
From: Joe Perches <joe@perches.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: festevam@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 09:40:08 -0700
In-Reply-To: <1413902024-2932-1-git-send-email-fabio.estevam@freescale.com>
References: <1413902024-2932-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 12:33 -0200, Fabio Estevam wrote:
> Break the sentence so that it looks better:
> 
> WARNING: debugfs_remove(NULL) is safe. This check is probably not required
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4446,7 +4446,7 @@ sub process {
>  			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
>  			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
>  				WARN('NEEDLESS_IF',
> -				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
> +				     "$1(NULL) is safe. This check is probably not required\n" . $hereprev);
>  			}
>  		}
>  

Mixing sentences with and without periods is jarring.
I'd prefer a comma or a dash.

