Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629AbaKNQWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:22:10 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:39221 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965050AbaKNQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:22:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ring78_1263e6e948c49
X-Filterd-Recvd-Size: 1562
Message-ID: <1415982122.5912.14.camel@perches.com>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 14 Nov 2014 08:22:02 -0800
In-Reply-To: <alpine.DEB.2.10.1411140938400.2443@hadrien>
References: <1415908529.4223.11.camel@perches.com>
	 <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>
	 <1415945558.5912.10.camel@perches.com>
	 <alpine.DEB.2.10.1411140938400.2443@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 10:18 +0100, Julia Lawall wrote:
> On Thu, 13 Nov 2014, Joe Perches wrote:
[]
> > Yes, I agree with some of the things Al Viro said
> > there, but isn't 'type t; t *p;' a subset of
> > "expression *e"?

> No.  How would you expect it to be different.

[]

>   type t means that the type
> is known.  expression *e means that there is a * in the type.

I had thought "expression *" could be r-value and
"type t; t *p;" could be l-value.

But then I don't find (or maybe don't parse too well)
the coccinelle documentation that specifies these
type relationships.

cheers, Joe


