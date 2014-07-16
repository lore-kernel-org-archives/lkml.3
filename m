Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbaGPNIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:08:45 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:43571 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752719AbaGPNIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:08:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2736:2739:2828:2894:2911:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4425:5007:6119:7652:7808:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13161:13229:13255:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: camp24_112185544d710
X-Filterd-Recvd-Size: 3364
Message-ID: <1405516116.14773.66.camel@joe-AO725>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Nick Krause <xerofoify@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Jul 2014 06:08:36 -0700
In-Reply-To: <20140716080553.GE1491@thunk.org>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
	 <1405481937.14773.8.camel@joe-AO725>
	 <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
	 <1405484621.14773.22.camel@joe-AO725>
	 <CAPDOMVi87FAukETbMbjtRqejgFN+mWfqZvP+Uw2eT===Oaz0ww@mail.gmail.com>
	 <1405485592.14773.29.camel@joe-AO725> <20140716080553.GE1491@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 04:05 -0400, Theodore Ts'o wrote:
> On Tue, Jul 15, 2014 at 09:39:52PM -0700, Joe Perches wrote:
[]
> > Consistency is a nicety not really a need.
> > 
> > Bugs need fixing.  Defects need eliminating.
> > Enhancements are appreciated.  Inconsistent
> > code style is a minor annoyance.
> 
> Note that patches that clean up code style can in fact be actively
> harmful, because it interferes with other developers who are sending
> patches that fix real bugs and and add new features (because the
> cleanups cause patch conflicts).
[]
> Cleanups as a part of normal code development is fine.
[]
> fixing
> every single nit that checkpatch whines about in a while adds no
> value, and in fact, can add negative value.

I think the negatives are a bit overstated.

As long as style only patches are scheduled, coordinated,
and done with a much lower priority than other real work,
there is some marginal positive value in code style
consistency.

Humans more easily read code of multiple subsystems.
Defects in existing code are sometimes uncovered.
More consistent API use is encouraged.

There are real tradeoffs to be considered in developer
time vs value though.

Even whitespace changes need review and acceptance from
upstream maintainers to make sure defects and new security
issues aren't introduced.

Upstream maintainer time is not cheap and frequently the
upstream maintainer is not cheerful either.

> (Also note that there are some local coding practices where there are
> very good reasons why the checkpatch whines need to be completely
> ignored.  For example, you checkpatch doesn't deal well with the file
> format used in include/tracing/events/*.h.  You need to know when the
> right thing to do is to say, "Go home, checkpatch, you're drunk.")

checkpatch can be a bit of an OCD drunk.  Codetenders
have the responsibility to cut it off when its spent
too long at the file bar.

Of course it's true that checkpatch needs to have its
own bugs fixed and defects eliminated too.


