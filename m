Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3JHADT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:03:19 -0400
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:55094 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751431Ab3JHADS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:03:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3315:3351:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10450:10455:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tree14_56d1804c47855
X-Filterd-Recvd-Size: 1438
Message-ID: <1381190594.2081.228.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Add check for sscanf without return use
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 17:03:14 -0700
In-Reply-To: <20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
References: <1381189523.2081.225.camel@joe-AO722>
	 <20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 16:56 -0700, Andrew Morton wrote:
> On Mon, 07 Oct 2013 16:45:23 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Naked use sscanf can be troublesome.
> 
> It would be helpful to expand on "troublesome"?

Dunno, you either know or the couple of paragraphs
it takes to explain with examples won't really be
too helpful in a commit log.

> > Add a warning when the sscanf return value is not used.
> Maybe it should be __must_check?

Maybe.

That might be easier but there'll be a couple
hundred new build warnings.

