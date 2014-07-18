Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbaGROfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:35:32 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:51582 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755033AbaGROfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:35:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3167:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7903:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:n
X-HE-Tag: shelf54_129f390c8a21a
X-Filterd-Recvd-Size: 1649
Message-ID: <1405694126.14358.30.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, apw@canonical.com, tytso@mit.edu,
        dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jul 2014 07:35:26 -0700
In-Reply-To: <20140718142459.GC31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
	 <53C92C86.2030408@metafoo.de> <20140718142459.GC31270@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 16:24 +0200, Borislav Petkov wrote:
> On Fri, Jul 18, 2014 at 04:17:42PM +0200, Lars-Peter Clausen wrote:
> > --file is a in my opinion useful option and at least I use it on a
> > regular basis.
[]
> diff -urN /dev/null $file | ./scripts/checkpatch.pl -

Using the one-liner above also makes it harder to
automate checkpatch neatening and avoid using Lindent:

Something like: https://lkml.org/lkml/2014/7/11/794

checkpatch --terse and --emacs options, useful for editing
lines where errors occur, no longer point to the line of
the file being scanned and use the stdin filename "-" and
the line # from stdin.


