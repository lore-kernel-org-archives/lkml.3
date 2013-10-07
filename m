Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3JGVmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:42:06 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:49007 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752564Ab3JGVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:42:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3291:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4823:5007:6120:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: size41_111fe70b08b1f
X-Filterd-Recvd-Size: 2025
Message-ID: <1381182115.2081.218.camel@joe-AO722>
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Josh Triplett <josh@joshtriplett.org>, torvalds@linux-foundation.org,
        gregkh@linux-foundation.org, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Oct 2013 14:41:55 -0700
In-Reply-To: <1381181602.2081.214.camel@joe-AO722>
References: <20131007191835.GA28737@jtriplet-mobl1>
	 <1381174106.2081.207.camel@joe-AO722>
	 <20131007193433.GF13643@jtriplet-mobl1>
	 <20131007212302.GB13318@ZenIV.linux.org.uk>
	 <1381181602.2081.214.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 14:33 -0700, Joe Perches wrote:
> On Mon, 2013-10-07 at 22:23 +0100, Al Viro wrote:
> > On Mon, Oct 07, 2013 at 12:34:33PM -0700, Josh Triplett wrote:
> > 
> > > I've seen far more examples of the 80-column limit making code less
> > > readable rather than more.  It's only really helpful when it forces code
> > > restructuring, *not* when it just forces an arbitrary line break.
> > 
> > So teach that piece of crap to complain about fucked-in-head line breaks like
> > 							ret_val =
> > 							    leaf_shift_left(tb,
> > 									    tb->
> > 									    lnum
> > 									    [0],
> > 									    tb->
> > 									    lbytes
> > 									    -
> > 									    1);
> > in addition to obscenely long lines (and yes, it is a real-world example).

btw: checkpatch does suggest refactoring when there are
6+ indent tabs with an if/while/for/do/switch statement.
so it already does bleat around there.

