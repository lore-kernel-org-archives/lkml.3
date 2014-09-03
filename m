Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaICFeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:34:36 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:50136 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754752AbaICFef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:34:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4250:4321:4605:5007:7652:8828:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13071:13095:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: edge34_44f6dedf6ac2e
X-Filterd-Recvd-Size: 1934
Message-ID: <1409722470.2715.5.camel@joe-AO725>
Subject: Re: Bogus error in checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 22:34:30 -0700
In-Reply-To: <CAJhHMCBuUvSb46Q+kvryv2vu=1Pjq8odSs6u7P1h3HyG21k2AA@mail.gmail.com>
References: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>
	 <1409718353.2715.3.camel@joe-AO725>
	 <CAJhHMCBuUvSb46Q+kvryv2vu=1Pjq8odSs6u7P1h3HyG21k2AA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 00:29 -0400, Pranith Kumar wrote:
> Hi Joe,

Hello Pranith.

> On Wed, Sep 3, 2014 at 12:25 AM, Joe Perches <joe@perches.com> wrote:
> > You need to use parentheses around the description like:
> >         commit <commitid> ("commit description")
> > For your case:
> > Commit 615cc2c9cf95 ("Documentation/memory-barriers.txt: fix important
> > typo re memory barriers")
> Ah, OK. But the error message does not say anything about missing
> paranetheses and only stresses on chars in the id:
> 
> $ ./scripts/checkpatch.pl
> patch_dir/0001-doc-memory-barriers.txt-Correct-example-for-reorderi.patch
> ERROR: Please use 12 or more chars for the git commit ID like: 'Commit
> 615cc2c9cf95 ("Documentation/memory-barriers.txt: fix important typo
> re memory barriers")'
> #8:
> Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re
> Is it possible to make it a bit clearer, perhaps?

Maybe.  Suggest a modified message.

