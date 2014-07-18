Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779AbaGRO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:57:19 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:35504 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965730AbaGRO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:57:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3167:3291:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:7903:8985:9025:10007:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:
X-HE-Tag: aunt58_3f5cfe063d651
X-Filterd-Recvd-Size: 1972
Message-ID: <1405695433.14358.40.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, apw@canonical.com, tytso@mit.edu,
        dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jul 2014 07:57:13 -0700
In-Reply-To: <20140718144920.GE31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
	 <53C92C86.2030408@metafoo.de> <20140718142459.GC31270@pd.tnic>
	 <1405694126.14358.30.camel@joe-AO725> <20140718144920.GE31270@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 16:49 +0200, Borislav Petkov wrote:
> On Fri, Jul 18, 2014 at 07:35:26AM -0700, Joe Perches wrote:
> > Using the one-liner above also makes it harder to
> > automate checkpatch neatening and avoid using Lindent:
> 
> automated checkpatch?? More idiocy... we want less, in case you've
> forgotten.

"we" is a subset of "all of us".

> <snip more pointless justification attempts>

Those are not at all pointless if you intend to fix
any issue found by the tool.

I think your viewpoint is a bit tainted as you're the
same guy that wrote "fuck readability".

https://lkml.org/lkml/2013/11/19/116

> It is about time people understood that and dropped the senseless frenzy
> of creating patches with less time spent on thinking about them than
> preparing them.

I suggest you try writing some documentation
patches instead of acrid emails.

cheers, Joe

