Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaJFMy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:54:27 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:50136 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752419AbaJFMyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:54:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:334:355:368:369:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3743:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7974:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mouth23_95005b23934a
X-Filterd-Recvd-Size: 1565
Message-ID: <1412600062.2916.19.camel@joe-AO725>
Subject: Re: [PATCH] mips: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 06 Oct 2014 05:54:22 -0700
In-Reply-To: <20141006124915.GA29036@linux-mips.org>
References: <1412441442.3247.138.camel@joe-AO725>
	 <20141006124915.GA29036@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 14:49 +0200, Ralf Baechle wrote:
> On Sat, Oct 04, 2014 at 09:50:42AM -0700, Joe Perches wrote:
> 
> > Use the much more common pr_warn instead of pr_warning
> > with the goal of removing pr_warning eventually.
> 
> While I agree that only one of pr_warn and pr_warning deserves to live
> picking pr_warning introduces another logic inconsistency - for each
> pr_<foo> function there is a KERN_<FOO> severity symbol.  And that in
> this case is named KERN_WARNING, there's no KERN_WARN.

Yes, I know.  It's a consistency thing that can really
only be resolved one step at a time.

Most everything else uses _warn (dev_warn, netdev_warn,
etc...) so it'd be good to get pr_warn done too.

cheers, Joe


