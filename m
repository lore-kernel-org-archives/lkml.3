Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaGHVYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:24:14 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:54698 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753137AbaGHVYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:24:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2687:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:9025:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: view20_5d777e62ab34d
X-Filterd-Recvd-Size: 2013
Message-ID: <1404854640.932.58.camel@joe-AO725>
Subject: Re: [PATCH 2/2] checkpatch: Add ability to insert and delete lines
 to patch/file
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 14:24:00 -0700
In-Reply-To: <20140708140758.cc0bcd1d7af956afde149815@linux-foundation.org>
References: <cover.1404840958.git.joe@perches.com>
	 <678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
	 <20140708132409.625c8c90c49b9db9efe6eb8d@linux-foundation.org>
	 <1404853064.932.49.camel@joe-AO725>
	 <20140708140758.cc0bcd1d7af956afde149815@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 14:07 -0700, Andrew Morton wrote:
> On Tue, 08 Jul 2014 13:57:44 -0700 Joe Perches <joe@perches.com> wrote:
> > I've suggested Lindent be removed from the tree.
> > https://lkml.org/lkml/2013/2/11/390
> 
> Maybe it's fixable, dunno - I don't recall ever seeing anyone get down
> and poke at it.  Of course, indent itself is open source...

As open source projects go, indent is pretty dead.

indent's been looking hopelessly/helplessly for a
new maintainer for a long time.

I think the last time Lindent as run over any bit
of kernel code was when Linus made a mess of the
reiserfs code.

It was setup reasonably well for 132 columns, but
Lindent made it unreadable with all sorts of
			foo.
			bar
			[baz]
			= func(
			arg1,
			arg2);
lines.


