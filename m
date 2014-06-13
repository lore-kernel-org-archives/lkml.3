Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaFMQsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:48:31 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:46619 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaFMQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:48:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3872:3873:4321:4605:5007:7522:7652:7875:7903:8957:9545:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13161:13200:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache
X-HE-Tag: vest96_f5888f779b2e
X-Filterd-Recvd-Size: 1893
Message-ID: <1402678104.3509.1.camel@joe-AO725>
Subject: Re: [PATCH V2 00/19] irqchip: crossbar: driver fixes
From: Joe Perches <joe@perches.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Date: Fri, 13 Jun 2014 09:48:24 -0700
In-Reply-To: <20140613163714.GR8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
	 <20140613150122.GP8664@titan.lakedaemon.net>
	 <1402676074.12385.40.camel@joe-AO725>
	 <20140613163714.GR8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 12:37 -0400, Jason Cooper wrote:
> On Fri, Jun 13, 2014 at 09:14:34AM -0700, Joe Perches wrote:
> > On Fri, 2014-06-13 at 11:01 -0400, Jason Cooper wrote:
> > > Please format the subject lines like so:
> > > 
> > >   irqchip: crossbar: Set cb pointer ...
> > >                      ^
> > >                      |
> > >                      \-- note the capitalization
> > 
> > I suggest you don't make this a rule and focus
> > on more important stuff instead.
> 
> It's not my rule.  ;-)

Who's rule is it then?

Documentation/SubmittingPatches simply says:

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase

It doesn't say anything about capitalization.

