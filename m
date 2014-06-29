Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaF2SZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 14:25:54 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:37994 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753311AbaF2SZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 14:25:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3870:3871:3872:4321:5007:7652:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat49_33131a9ed6a38
X-Filterd-Recvd-Size: 1465
Message-ID: <1404066349.9064.60.camel@joe-AO725>
Subject: Re: [PATCH] HID: roccat: Drop cast
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 29 Jun 2014 11:25:49 -0700
In-Reply-To: <alpine.DEB.2.02.1406291832430.2036@localhost6.localdomain6>
References: <20140626172852.GA2878@himangi-Dell>
	 <1403804286.7977.58.camel@joe-AO725>
	 <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6>
	 <1403848366.7977.92.camel@joe-AO725>
	 <alpine.DEB.2.02.1406291832430.2036@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-29 at 18:34 +0200, Julia Lawall wrote:
> On Thu, 26 Jun 2014, Joe Perches wrote:
> > void func(const void * const p)
> > {
> > 	char *p2 = p;
> > 
> > 	p2[0] = 1;
> > }
> 
> Is this a real example?

No, it's not.

I think I've seen code in the kernel like
	char *p2 = (void *)p;
where p is const and p2 is dereferenced and set.


