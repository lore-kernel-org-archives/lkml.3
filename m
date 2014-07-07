Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaGGNkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:40:47 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:45248 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753221AbaGGNkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:40:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3873:3874:4321:5007:6119:7652:7903:10004:10400:10848:10967:11232:11658:11914:12050:12517:12519:12679:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: use10_407e9c2f4f414
X-Filterd-Recvd-Size: 2599
Message-ID: <1404740441.27043.71.camel@joe-AO725>
Subject: Re: [PATCH v2] declance: Fix 64-bit compilation warnings
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Jul 2014 06:40:41 -0700
In-Reply-To: <20140707120152.CF82BC40921@trevor.secretlab.ca>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	 <20140702.182807.1245632778216212860.davem@davemloft.net>
	 <alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	 <alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	 <1404356734.14741.18.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	 <1404364565.14741.26.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	 <1404368746.14741.36.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	 <1404576420.6384.41.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
	 <1404583739.6384.51.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051917480.15455@eddie.linux-mips.org>
	 <1404585099.6384.53.camel@joe-AO725>
	 <20140707120152.CF82BC40921@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 13:01 +0100, Grant Likely wrote:
> On Sat, 05 Jul 2014 11:31:39 -0700, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2014-07-05 at 19:20 +0100, Maciej W. Rozycki wrote:
> > > On Sat, 5 Jul 2014, Joe Perches wrote:
> > > > I don't think %#p is valid so it
> > > > shouldn't have been set by #.
> > > 
> > >  Huh?  As recently as last Wednesday you pointed me at the specific commit 
> > > from Grant that made it valid (GCC format complaints aside).
> > 
> > Those gcc complaints are precisely the thing
> > that makes it invalid.
> 
> That's the most inane reason ever for saying something is invalid. "The
> tool doesn't recognise it, there for it is invalid?" Seriously?

Inane maybe, but practical.

The tool says "don't do that", so we shouldn't
or we should fix or quiet the tool.

fwiw: I agree with Maciej.

gcc's warning on %#p should be able to be quieted somehow.


