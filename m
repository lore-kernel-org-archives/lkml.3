Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaICEZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:25:59 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:54035 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209AbaICEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:25:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:3873:3874:4250:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13018:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tub66_33c1febadf158
X-Filterd-Recvd-Size: 1447
Message-ID: <1409718353.2715.3.camel@joe-AO725>
Subject: Re: Bogus error in checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 21:25:53 -0700
In-Reply-To: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>
References: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 00:03 -0400, Pranith Kumar wrote:
> I receive an ERROR when running checkpatch.pl on a patch containing
> the following line:
> 
> Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re
> 
> saying that the commit ID should be 12 or more characters when the
> commit ID is indeed 12 characters. I tried fixing it, but my perl is
> not up-to-par.

You need to use parentheses around the description like:
	commit <commitid> ("commit description")

For your case:

Commit 615cc2c9cf95 ("Documentation/memory-barriers.txt: fix important
typo re memory barriers")




