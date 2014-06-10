Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaFJV0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:26:53 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:47038 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752715AbaFJV0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:26:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7775:7903:7904:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crown95_587af8c6bfb11
X-Filterd-Recvd-Size: 1721
Message-ID: <1402435605.4082.3.camel@joe-AO725>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, dirk.j.brandewie@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jun 2014 14:26:45 -0700
In-Reply-To: <1894836.tjrHdJ7Duz@vostro.rjw.lan>
References: <5396208F.6070400@semaphore.gr>
	 <1875587.zmLYOIAyby@vostro.rjw.lan> <53977251.2090804@semaphore.gr>
	 <1894836.tjrHdJ7Duz@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 23:38 +0200, Rafael J. Wysocki wrote:

> > > is.  And the result of (a * 100) / b may generally be different from
> > > a * 100 / b for integers (if the division is carried out first).
> > 
> > I thought that (a * 100) / b is always equivalent to a * 100 / b.
> 
> I'm not actually sure if that's guaranteed by C standards.

It is.  left to right, same precedence.

> It surely
> wasn't some time ago (when there was no formal C standard).

c89 is 25 years ago now.

> Either way, in my opinion it's better to put the parens into the expression
> in this particular case to clearly state the intention.

I don't think so.


