Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaFKBl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:41:26 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:60342 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbaFKBlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:41:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4385:5007:7652:7775:7903:7904:10004:10400:10848:11232:11658:11914:12050:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate74_8067608e02834
X-Filterd-Recvd-Size: 1746
Message-ID: <1402450879.4082.6.camel@joe-AO725>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, dirk.j.brandewie@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jun 2014 18:41:19 -0700
In-Reply-To: <2859027.TirvIA2s2c@vostro.rjw.lan>
References: <5396208F.6070400@semaphore.gr>
	 <1894836.tjrHdJ7Duz@vostro.rjw.lan> <1402435605.4082.3.camel@joe-AO725>
	 <2859027.TirvIA2s2c@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 02:23 +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 10, 2014 02:26:45 PM Joe Perches wrote:
> > c89 is 25 years ago now.
> Apparently, I'm old.

nah, just older than yesterday.
No doubt better too.

> > > Either way, in my opinion it's better to put the parens into the expression
> > > in this particular case to clearly state the intention.
> > 
> > I don't think so.
> 
> Of course, you're free to disagree, but I guess you'll admit that
> a * b / c is generally different from b / c * a and if you see something
> like this it is hard to say at first sight whether or not this is intentional
> or an expression ordering bug.

true enough.

