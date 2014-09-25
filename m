Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaIYFFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:05:50 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:45739 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750840AbaIYFFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:05:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2893:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3872:3873:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: egg14_4fb52ee974a3c
X-Filterd-Recvd-Size: 1644
Message-ID: <1411621546.4026.10.camel@joe-AO725>
Subject: Re: [PATCH] kernel: acctc.c: Fixed else if not generally userful
 after a break or return warning
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Elshad Mustafayev <elshadimo@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 22:05:46 -0700
In-Reply-To: <20140925050004.GM7996@ZenIV.linux.org.uk>
References: <E1XX0bN-00032o-0x@feisty.vs19.net>
	 <1411619466.4026.2.camel@joe-AO725>
	 <CAAm9=9QeO_VtdY+fJ5JbrBhN52z=JUeU09Nh3Mp04QWf+Qyygw@mail.gmail.com>
	 <20140925050004.GM7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 06:00 +0100, Al Viro wrote:
> It's not you, it's checkpatch.pl plus the fairly common tendency to give
> that thing a lot more respect than it deserves...
> 
> Basically, it's OK as a tool that draws ones attention to a subset of
> code that might or might not be worth looking at; it gives both false
> positives and false negatives and as long as there's not too much of those,
> it's useful.  Provided that it does *not* replace one's taste.  I.e. "hey,
> it points to these lines; let's take a look, some of those might be
> worth some attention", rather than "The Most Holy Oracle Has Spoken;
> Do What It Says".

Just so.

