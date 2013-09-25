Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3IYTsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:48:46 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:36867 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992Ab3IYTso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:48:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:421:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2987:3138:3139:3140:3141:3142:3353:3622:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12295:12517:12519:12663:12679:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rock52_4b5965b54562c
X-Filterd-Recvd-Size: 2534
Message-ID: <1380138515.17366.22.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 12:48:35 -0700
In-Reply-To: <20130925193035.GA11905@thunk.org>
References: <1380047934.3575.100.camel@joe-AO722>
	 <20130925152432.GY13318@ZenIV.linux.org.uk>
	 <1380123344.17366.5.camel@joe-AO722>
	 <20130925161949.GZ13318@ZenIV.linux.org.uk>
	 <1380136920.17366.15.camel@joe-AO722> <20130925193035.GA11905@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 15:30 -0400, Theodore Ts'o wrote:
> On Wed, Sep 25, 2013 at 12:22:00PM -0700, Joe Perches wrote:
> > 
> > > 	* labels a-la Enomem, etc.  I've been using those and I will
> > > keep doing so, checkpatch.pl and its users be damned.
> > 
> > Good on you.
> 
> I'm with Al.  This is just silly to add to checkpatch.
> 
> > Fine by me.  Don't use checkpatch.  No stress from me.
> 
> I still get some of your minions sending patches asking to "fix" ext4
> from time to time.  It wastes everyone's time.

ext4 still has several code style nits that could be
improved.  Up to you to do anything about them though.

no space after comma, pointer spaces, and split strings
are nits.

> BTW, checkpatch barfs on pretty much everything in
> linux/trace/events/*.h

include/trace/events/*.h

As I've said multiple times, checkpatch is a stupid
little tool that can be ignored by anyone with
different tastes.

And, shrug.  I think straining for alignment like below
doesn't really add much.

$ ./scripts/checkpatch.pl -f include/trace/events/jbd.h
ERROR: space prohibited after that open parenthesis '('
#17: FILE: trace/events/jbd.h:17:
+		__field(	dev_t,	dev			)

ERROR: space prohibited before that close parenthesis ')'
#17: FILE: trace/events/jbd.h:17:
+		__field(	dev_t,	dev			)

ERROR: space prohibited after that open parenthesis '('
#18: FILE: trace/events/jbd.h:18:
+		__field(	int,	result			)



